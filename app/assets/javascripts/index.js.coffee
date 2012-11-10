


jQuery ->

  Router = Backbone.Router.extend
    routes:
      '': 'catch_all'
    
    catch_all: ->
      chat_window = new ChatWindow()
      chat_window.ready ->
        chat_window_view = new ChatWindowView(model: chat_window)
        ($ '#chat_window_container').html chat_window_view.render().el
      
      chat_window.channel.bind "client-request", (data) ->
        console.log "request recieved", data
        apiKey = '1127'
        console.log "session_id", data.session_id
        sessionId = data.session_id
        token = 'T1==cGFydG5lcl9pZD0xMTI3JnNpZz1hMzczM2JmOTJiODk2MTk1ZWE2MGFkNjY3YTJkYmYzMDY5MDVmMjQ2OnNlc3Npb25faWQ9MV9NWDR4TVRJM2ZuNVRZWFFnVG05MklERXdJREF3T2pBMU9qQTNJRkJUVkNBeU1ERXlmakF1T1RRNE5UY3dNMzQmY3JlYXRlX3RpbWU9MTM1MjUzNDcwNyZleHBpcmVfdGltZT0xMzUyNjIxMTA3JnJvbGU9cHVibGlzaGVyJm5vbmNlPTk4ODcxMw=='

        TB.setLogLevel(TB.DEBUG)

        session = TB.initSession(sessionId)
        session.addEventListener 'sessionConnected', (data) ->
          console.log "data sessionConnected", data
          sessionConnectedHandler(data)
        session.addEventListener 'streamCreated', (data) ->
          console.log "data streamCreated", data
          streamCreatedHandler(data)
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
            console.log "subscribe"
            session.subscribe(stream, div.id)

  window.router = new Router()
  Backbone.history.start({pushState: true})