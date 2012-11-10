
BaseView = Backbone.View.extend
  template: (context) ->
    raw_template = @template_element.html()
    template_function = Handlebars.compile(raw_template)
    template_function(context)

window.ChatWindowView = BaseView.extend
  model: window.ChatWindow
  template_element: $("#chat_window_template")
    
  initialize: ->
    _.bindAll @
    @rows = []
    @model.bind_added @add_row_for_user
    @model.bind_removed @remove_row_for_user
  
  remove_row_for_user: (user) ->
    _.each @rows, (row) ->
      row.remove() if row.model.getId() == user.getId()
  
  add_row_for_user: (user) ->
    @remove_row_for_user(user)
    row = new ChatUserRow(model: user, channel: @model.channel)
    @rows.push row
    @$('ul').append row.render().el
    
  render: ->
    @$el.html @template({})
    @model.members.each (member) => (@add_row_for_user member)
    @


window.ChatUserRow = BaseView.extend
  model: window.User
  template_element: $("#chat_user_row_template")
  events: 
    'click .video_chat_me': 'request_chat'
      
  request_chat: ->
    data = 
      user_id: @model.getId()
      from: current_user.toJSON()
      session_id: '1_MX4xMTI3fn5TYXQgTm92IDEwIDAwOjA1OjA3IFBTVCAyMDEyfjAuOTQ4NTcwM34'
    
    console.log "request chat with data", data
    @options.channel.trigger "request", data
    apiKey = '1127'
    sessionId = data.session_id
    token = 'T1==cGFydG5lcl9pZD0xMTI3JnNpZz1hMzczM2JmOTJiODk2MTk1ZWE2MGFkNjY3YTJkYmYzMDY5MDVmMjQ2OnNlc3Npb25faWQ9MV9NWDR4TVRJM2ZuNVRZWFFnVG05MklERXdJREF3T2pBMU9qQTNJRkJUVkNBeU1ERXlmakF1T1RRNE5UY3dNMzQmY3JlYXRlX3RpbWU9MTM1MjUzNDcwNyZleHBpcmVfdGltZT0xMzUyNjIxMTA3JnJvbGU9cHVibGlzaGVyJm5vbmNlPTk4ODcxMw=='

    TB.setLogLevel(TB.DEBUG)

    session = TB.initSession(sessionId)
    session.addEventListener 'sessionConnected', (data) -> sessionConnectedHandler(data)
    session.addEventListener 'streamCreated', (data) -> streamCreatedHandler(data)
    session.connect(apiKey, token)

    sessionConnectedHandler = (event) ->
      console.log "sessionConnectedHandler"
      publishProps = {height:240, width:320}
      publisher = TB.initPublisher(apiKey, 'myPublisherDiv', publishProps)
      session.publish(publisher)
      subscribeToStreams(event.streams)

    streamCreatedHandler = (event) ->
      console.log "streamCreatedHandler"
      subscribeToStreams(event.streams)

    subscribeToStreams = (streams) ->
      _.each streams, (stream) ->
        return if (stream.connection.connectionId == session.connection.connectionId)
        div = document.createElement('div')
        div.setAttribute('id', 'stream' + stream.streamId)
        document.body.appendChild(div)

        subscribeProps = {height:240, width:320}
        session.subscribe(stream, div.id)
  
  render: ->
    @$el.html @template(@model.toJSON())
    @