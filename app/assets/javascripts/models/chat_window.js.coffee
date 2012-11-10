

window.ChatWindow = Backbone.Model.extend
    
  initialize: ->
    
    @members = new window.Users()
    @channel = window.PusherAPI.subscribe 'presence-chat'
    
    @channel.bind 'pusher:subscription_succeeded', =>
      
      # build collection of users
      @channel.members().each (m) => 
        @members.add(new User(m.info)) unless parseInt(m.id, 10) == (current_user.getId()) 
      
      @members.each (user) => (@add_member user) 
      
      @ready() if @ready
      
    @channel.bind 'pusher:member_added', (member) => (@add_member member)
    @channel.bind 'pusher:member_removed', (member) => (@remove_member member)
  
  ready: (f) -> @ready = f
  
  add_member: (member) ->
    console.log "add", member

  remove_member: (member) ->
    console.log "remove", member

