
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
    
  render: ->
    @$el.html @template({})
    $ul = @$('ul')
    @model.members.each (member) ->
      row = new ChatUserRow(model: member)
      $ul.append row.render().el
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