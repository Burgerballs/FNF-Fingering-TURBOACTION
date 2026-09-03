extends Node2D
class_name Sustain
@export var textureSus:Texture2D
@export var textureEnd:Texture2D
@export var length = 4.0;
var strumtime = 0
var note:Note = null
var timelength = Conductor.step_crotchet*1000
var parentStrumline:NoteField
var width = 50*0.7
var column = 0
var shrinking = false
var shouldDestroy = false
var coyoteTimer = 0.45
var released = false
var dead = false
var confirmedKilled = false
var confirmedCompleted = false
var frames:SpriteFrames
var animations = [
	'purple',
	'blue',
	'green',
	'red'
]
var skin:String:
	set(v):
		skin = v
		frames = parentStrumline.skinData.quant_frames if (Preferences.getPreference('quants') and parentStrumline.skinData.quant_frames != null) else parentStrumline.skinData.frames
		textureSus = frames.get_frame_texture(parentStrumline.skinData.sustainHoldPiecesPrefixes4K[column], 0)
		textureEnd = frames.get_frame_texture(parentStrumline.skinData.sustainHoldEndsPrefixes4K[column], 0)
		texture_filter = TEXTURE_FILTER_NEAREST if not parentStrumline.skinData.antialiased else TEXTURE_FILTER_PARENT_NODE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var c = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if c >= 1. / 240:
		c = 0;
		queue_redraw()
	length = ceil(timelength / (Conductor.step_crotchet*1000))
	if (shrinking && !dead):
		strumtime = Conductor.position*1000
		timelength -= delta*1000
		if (timelength < 0):
			confirmedCompleted = true
			shrinking = false
	if released:
		coyoteTimer = clamp(coyoteTimer - delta, 0, 0.45)
		dead = coyoteTimer <= 0
	shouldDestroy = ((strumtime + timelength) - (Conductor.position * 1000) <= -1000)
	c+= delta;

func get_points(time):
	var pos = ModMan.instance.getPos(time, time,Conductor.beat,column,parentStrumline.playerNum,self,parentStrumline,Vector3.ZERO)
	
	var points = Rect2(-width/2, 0, width/2, 0)
	var scale = (1.0 / pos.z) if (pos.z!=0.0) else 1.0
	
	points.position *= Vector2(scale * parentStrumline.skinData.sustainWidth, scale)
	points.size *= Vector2(scale * parentStrumline.skinData.sustainWidth, scale)
	points.position.x += ModMan.instance.swagWidth*0.5
	points.size.x += ModMan.instance.swagWidth*0.5
	points.position.y += ModMan.instance.swagWidth*0.5
	points.size.y += ModMan.instance.swagWidth*0.5
	
	points.position += Vector2(pos.x, pos.y)
	points.size += Vector2(pos.x, pos.y)
	
	return points

func _draw() -> void:
	if timelength < Conductor.step_crotchet / parentStrumline.scrollSpeed:
		return
	var density = Main.sustainDensity
	var uvProgress = range((density) * 2)
	# top1 x y top2 x y
	# bot1 x y top2 x y
	for i in uvProgress:
		i = (i / density);
	for l in range(length):
		var timel = (timelength / (length)) * (l)
		var timela = (timelength / (length)) * (l+1)
		var time = (strumtime + timel) - parentStrumline.time
		var time2 = (strumtime + timela) - parentStrumline.time
		if time >= 2000: return
		for i in range(density):
			var firstUV = uvProgress[i] / (density)
			var secondUV = uvProgress[i+1] / (density)
				  
			
			var top = get_points(lerp(time, time2, firstUV))
			var bot = get_points(lerp(time, time2, secondUV))
			
			var info = ModMan.instance.getExtraInfo(lerp(time, time2, lerp(firstUV, secondUV, 0.5)), time, Conductor.beat, column, parentStrumline.playerNum, self, parentStrumline)
			
			if info.alpha <= 0: continue
			
			if (top.position.y >= 1280 && bot.position.y >= 1280) or (top.position.y <= 0 && bot.position.y <= 0):
				continue
			
			var texture = textureSus if (l + 1 != length) else textureEnd
			
			var color = Color.WHITE
			
			color = Color.WHITE.darkened((1 - clamp(coyoteTimer / 0.45, 0, 1)) / 2)
			color.a = info.alpha
			if dead or not shrinking:
				color.a *= 0.7
			
			draw_colored_polygon([top.position, top.size, bot.position], color, [Vector2(0,firstUV), Vector2(1,firstUV), Vector2(0,secondUV)], texture)
			draw_colored_polygon([bot.position, bot.size, top.size], color, [Vector2(0,secondUV), Vector2(1,secondUV), Vector2(1,firstUV)], texture)
		
