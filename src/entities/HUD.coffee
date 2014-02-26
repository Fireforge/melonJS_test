
###
a HUD container and child items
###
game.HUD = game.HUD or {}
game.HUD.Container = me.ObjectContainer.extend(init: ->
  
  # call the constructor
  @parent()
  
  # persistent across level change
  @isPersistent = true
  
  # non collidable
  @collidable = false
  
  # make sure our object is always draw first
  @z = Infinity
  
  # give a name
  @name = "HUD"
  
  # add our child score object at position
  @addChild new game.HUD.ScoreItem("score", "left", 10, 10)
  
  # add our child score object at position
  @addChild new game.HUD.ScoreItem("hiscore", "right", (me.video.getWidth() - 10), 10)
  return
)

###
a basic HUD item to display score
###
game.HUD.ScoreItem = me.Renderable.extend(
  
  ###
  constructor
  ###
  init: (score, align, x, y) ->
    
    # call the parent constructor 
    # (size does not matter here)
    @parent new me.Vector2d(x, y), 10, 10
    
    # create a font
    @font = new me.BitmapFont("atascii",
      x: 24
    )
    @font.alignText = "bottom"
    @font.set align, 1.2
    
    # ref to the score variable
    @scoreRef = score
    
    # make sure we use screen coordinates
    @floating = true
    return

  
  ###
  draw the score
  ###
  draw: (context) ->
    @font.draw context, game.data[@scoreRef], @pos.x, @pos.y
    return
)
