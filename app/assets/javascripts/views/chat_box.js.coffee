
window.ChatBox = BaseView.extend
  template_element: $("#chat_box_template")
  id: 'chat_box'
  events: 
    'keydown #chat_input': 'keypress'
  
  initialize: ->
    @channel = PusherAPI.subscribe "presence-#{@options.id}"
    @channel.bind 'client-is-typing', (data) ->
      console.log "is typing"
      console.log data
    @channel.bind 'client-message', (data) ->
      console.log "message"
      console.log data
  
  keypress: (e) ->
    if e.keyCode == 13
      @send_message()
    else
      @process_keypress()
  
  last_sent: false
  process_keypress: ->
    if !@last_sent || (new Date() - @last_sent) > 500
      @channel.trigger 'is-typing', {
        user: current_user.toJSON(),
        message: ($ '#chat_input').val()
      }
      @last_sent = new Date()
    
  send_message: ->
    @channel.trigger 'message', {
      user: current_user.toJSON(),
      message: ($ '#chat_input').val()
    }
    ($ '#chat_input').val ''
  
  render: ->
    @$el.html @template()
    @