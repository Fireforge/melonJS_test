game.MoleEntity = me.AnimationSheet.extend(
  init: (x, y) ->
    
    # call the constructor
    @parent x, y, me.loader.getImage("mole"), 178, 140
    
    # idle animation
    @addAnimation "idle", [0]
    
    # laugh animation
    @addAnimation "laugh", [
      1
      2
      3
      2
      3
      1
    ]
    
    # touch animation
    @addAnimation "touch", [
      4
      5
      6
      4
      5
      6
    ]
    
    # set default one
    @setCurrentAnimation "idle"
    
    # means fully hidden in the hole
    @isVisible = false
    @isOut = false
    @timer = 0
    @initialPos = @pos.y
    
    # tween to display/hide the moles
    @displayTween = null
    @hideTween = null
    
    # register on mouse event
    me.input.registerPointerEvent "mousedown", this, @onMouseDown.bind(this)
    return

  
  ###
  callback for mouse click
  ###
  onMouseDown: ->
    if @isOut is true
      @isOut = false
      
      # set touch animation
      @setCurrentAnimation "touch", @hide.bind(this)
      
      # make it flicker
      @flicker 20
      
      # play ow FX
      me.audio.play "ow"
      
      # add some points
      game.data.score += 100
      if game.data.hiscore < game.data.score
        
        # i could save direclty to me.save
        # but that allows me to only have one
        # simple HUD Score Object
        game.data.hiscore = game.data.score
        
        # save to local storage
        me.save.hiscore = game.data.hiscore
      
      # stop propagating the event
      return false
    return

  
  ###
  display the mole
  goes out of the hole
  ###
  display: ->
    finalpos = @initialPos - 140
    @displayTween = me.entityPool.newInstanceOf("me.Tween", @pos).to(
      y: finalpos
    , 200)
    @displayTween.easing me.Tween.Easing.Quadratic.Out
    @displayTween.onComplete @onDisplayed.bind(this)
    @displayTween.start()
    
    # the mole is visible
    @isVisible = true
    return

  
  ###
  callback when fully visible
  ###
  onDisplayed: ->
    @isOut = true
    @timer = me.timer.getTime()
    return

  
  ###
  hide the mole
  goes into the hole
  ###
  hide: ->
    finalpos = @initialPos
    @displayTween = me.entityPool.newInstanceOf("me.Tween", @pos).to(
      y: finalpos
    , 200)
    @displayTween.easing me.Tween.Easing.Quadratic.In
    @displayTween.onComplete @onHidden.bind(this)
    @displayTween.start()
    return

  
  ###
  callback when fully visible
  ###
  onHidden: ->
    @isVisible = false
    
    # set default one
    @setCurrentAnimation "idle"
    return

  
  ###
  update the mole
  ###
  update: ->
    if @isVisible
      
      # call the parent function to manage animation
      @parent()
      
      # hide the mode after 1/2 sec
      if @isOut is true
        if (me.timer.getTime() - @timer) > 500
          @isOut = false
          
          # set default one
          @setCurrentAnimation "laugh"
          @hide()
          
          # play laugh FX
          #me.audio.play("laugh");
          
          # decrease score by 25 pts
          game.data.score -= 25
          game.data.score = 0  if game.data.score < 0
        return true
    @isVisible
)

###
a mole manager (to manage movement, etc..)
###
game.MoleManager = me.ObjectEntity.extend(
  moles: []
  timer: 0
  init: ->
    settings = {}
    settings.width = 10
    settings.height = 10
    
    # call the parent constructor
    @parent 0, 0, settings
    
    # add the first row of moles
    i = 0

    while i < 3
      @moles[i] = new game.MoleEntity((112 + (i * 310)), 127 + 40)
      me.game.add @moles[i], 15
      i++
    
    # add the 2nd row of moles
    i = 3

    while i < 6
      @moles[i] = new game.MoleEntity((112 + ((i - 3) * 310)), 383 + 40)
      me.game.add @moles[i], 35
      i++
    
    # add the 3rd row of moles
    i = 6

    while i < 9
      @moles[i] = new game.MoleEntity((112 + ((i - 6) * 310)), 639 + 40)
      me.game.add @moles[i], 55
      i++
    @timer = me.timer.getTime()
    return

  
  #
  #  * update function
  #  
  update: ->
    
    # every 1/2 seconds display moles randomly
    if (me.timer.getTime() - @timer) > 500
      i = 0

      while i < 9
        hole = Number::random(0, 2) + i
        @moles[hole].display()  if not @moles[hole].isOut and not @moles[hole].isVisible
        i += 3
      @timer = me.timer.getTime()
    false
)
