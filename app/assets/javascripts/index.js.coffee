


jQuery ->

  Router = Backbone.Router.extend
    routes:
      '': 'catch_all'
    
    catch_all: ->
      chat_window = new ChatWindow()
      chat_window.ready ->
        chat_window_view = new ChatWindowView(model: chat_window)
        ($ '#chat_window_container').html chat_window_view.render().el

  window.router = new Router()
  Backbone.history.start({pushState: true})