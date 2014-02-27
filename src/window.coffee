window.onReady ->
    game.onload()
    
    # Mobile browser hacks
    if me.device.isMobile and !navigator.isCocoonJS
        # Prevent the webview from moving on a swipe
        window.document.addEventListener "touchmove", ->
            e.preventDefault()
            window.scroll(0, 0)
            return false
        , false

        # Scroll away mobile GUI
        ( ->
            window.scrollTo(0, 1)
            me.video.onresize(null)
        ).defer()

        me.event.subscribe me.event.WINDOW_ONRESIZE, (e) ->
            window.scrollTo(0, 1)