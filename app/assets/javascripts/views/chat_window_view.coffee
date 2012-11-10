
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
    row = new ChatUserRow(model: user)
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
    console.log "request chat with #{@model.getName()}"  
  
  render: ->
    @$el.html @template(@model.toJSON())
    @