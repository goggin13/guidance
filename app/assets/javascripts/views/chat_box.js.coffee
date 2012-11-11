
window.ChatBox = BaseView.extend
  template_element: $("#chat_box_template")
  id: 'chat_box'
  events:
    'keypress #chat_input': 'handle_keypressed'

  initialize: ->
    _.bindAll @
    @channel = PusherAPI.subscribe "presence-#{@options.room_id}"
    console.log "listening to room presence-#{@options.room_id}"
    
    is_typing_view = false
    entered_text_timeout = false
    entered_text = ->
      return unless is_typing_view
      is_typing_view.model.message = "has entered text."
      is_typing_view.render()
      
    @channel.bind 'client-is-typing', (data) =>
      unless is_typing_view
        is_typing_view = new IsTypingMessage(model: data)
        @$('ul').append is_typing_view.el
      if data.message == ""
        is_typing_view.remove()
        is_typing_view = false
        return
      old_text = data.message
      data.message = "is typing..."
      is_typing_view.model = data
      is_typing_view.render()
      (clearTimeout entered_text_timeout) if entered_text_timeout
      entered_text_timeout = setTimeout entered_text, 500

    @channel.bind 'client-message', (data) =>
      if is_typing_view
        is_typing_view.remove() 
        is_typing_view = false
      view = new ChatMessage(model: data)
      @$('ul').append view.render().el
    
    setInterval @process_keypress, 500
  
  handle_keypressed: (e) ->
    console.log "keypressed"
    if e.keyCode == 13
      console.log "send message"
      @send_message()
  
  last_sent: ""
  process_keypress: ->
    current = ($ '#chat_input').val()
    return if current == @last_sent
    
    @channel.trigger 'is-typing', {
      user: current_user.toJSON(),
      message: current
    }
    @last_sent = current
    
  send_message: ->
    data = {
      user: current_user.toJSON(),
      message: ($ '#chat_input').val()
    }
    console.log "SEND MESSAGEs"
    @channel.trigger 'message', data
    view = new ChatMessage(model: data)
    @$('ul').append view.render().el
    ($ '#chat_input').val ''
  
  render: ->
    @$el.html @template()
    @

ChatMessage = BaseView.extend
  template_element: $("#chat_message_template")
  tagName: 'li'
  
  render: ->
    @$el.html @template(@model)
    @

IsTypingMessage = BaseView.extend
  template_element: $("#chat_is_typing_template")
  tagName: 'li'

  render: ->
    @$el.html @template(@model)
    @
    
window.CollaborationView = BaseView.extend
  template_element: $("#collaboration_template")
  id: "collaboration_view"
  
  render: ->
    @$el.html @template(@model)
    @  
  