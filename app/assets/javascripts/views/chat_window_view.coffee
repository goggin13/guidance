
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
    
    @model.channel.bind "client-request", (data) =>
      view = new VideoChatInvitation(model: data)
      @$el.append view.render().el
    
    
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


window.VideoChatInvitation = BaseView.extend
  template_element: $("#video_chat_invitation_template")
  events: 
    "click .accept": 'accept_invitation'
    "click .decline": 'decline_invitation'
  
  decline_invitation: -> @remove()
  
  accept_invitation: ->
    OpenTokAPI.video_chat @model.session_id
    ($ '.video_chat_me').fadeOut()
    @remove()
    
  render: ->
    @$el.html @template(@model.from)
    @
    
window.ChatUserRow = BaseView.extend
  model: window.User
  template_element: $("#chat_user_row_template")
  events: 
    'click .video_chat_me': 'request_chat'
  
  request_chat: ->
    return if current_user.isChatting()
    ($ '.video_chat_me').fadeOut()
    data = 
      user_id: @model.getId()
      from: current_user.toJSON()
      session_id: '1_MX4xMTI3fn5TYXQgTm92IDEwIDAwOjA1OjA3IFBTVCAyMDEyfjAuOTQ4NTcwM34'
    
    @options.channel.trigger "request", data
    OpenTokAPI.video_chat data.session_id
    
  
  render: ->
    @$el.html @template(@model.toJSON())
    @