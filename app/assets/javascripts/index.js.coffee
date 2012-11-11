

jQuery ->

  Router = Backbone.Router.extend
    routes:
      'counselors': 'counselors'
      '#counselors': 'counselors'
      '/counselors': 'counselors'
      '': 'catch_all'
    
    counselors: ->
      $('#my_content').html("")
      chat_window = new ChatWindow()
      chat_window.ready ->
        chat_window_view = new ChatWindowView(model: chat_window)
        ($ '#chat_window_container').html chat_window_view.render().el
        ($ '#chat_window_container').fadeIn()
    
    catch_all: ->
      # view = new CollaborationView()
      # $('#my_content').append view.render().el
      # 
      view = new ChatBox(room_id: "blah")
      $('#my_content').append view.render().el
      # 
      $('#my_content').append "<div class='clear'></div>"
      
  window.router = new Router()
  Backbone.history.start({pushState: true})
  
  ($ "a.push_nav").live 'click', ->
    navigateTo ($ this).attr('href')
    false

  window.navigateTo = (url) -> 
    # Pull of leading / if we are in old browser, so routes function properly
    # url = url.substring(1) if (url.indexOf("/") == 0)
    window.router.navigate url, true