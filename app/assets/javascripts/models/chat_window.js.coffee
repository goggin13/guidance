
window.ChatWindow = Backbone.Model.extend
    
  initialize: ->
    
    @members = new window.Users()
    @channel = window.PusherAPI.subscribe 'presence-chat'
    
    @channel.bind 'pusher:subscription_succeeded', =>
      
      # build collection of users
      @channel.members().each (m) => 
        @members.add(new User(m.info)) unless parseInt(m.info.id, 10) == (current_user.getId()) 
      
      @ready() if @ready
      
    @channel.bind 'pusher:member_added', (member) =>
      (@added new User(member.info)) if @added
    @channel.bind 'pusher:member_removed', (member) => 
      (@removed new User(member.info)) if @removed
  
  ready: (f) -> @ready = f
  bind_added: (f) -> @added = f
  bind_removed: (f) -> @removed = f
