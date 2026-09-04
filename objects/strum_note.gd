extends Node2D
class_name StrumNote

@onready var sprite:AnimatedSprite2D = $sprite
@export var column = 0;
var pos:Vector3 = Vector3()
var sustain:Sustain
var length = 2000
var parentStrumline:NoteField;
var info = {
	'alpha': 1
}
var strumAnims:Array = [
	['arrowLEFT', 'left press', 'left confirm'],
	['arrowDOWN', 'down press', 'down confirm'],
	['arrowUP', 'up press', 'up confirm'],
	['arrowRIGHT', 'right press', 'right confirm'],
	
]
var skin:String:
	set(v):
		skin = v
		sprite.sprite_frames = parentStrumline.skinData.quant_frames if (Preferences.getPreference('quants') and parentStrumline.skinData.quant_frames != null) else parentStrumline.skinData.frames
		strumAnims = parentStrumline.skinData.receptorsPrefixes4K
		texture_filter = TEXTURE_FILTER_NEAREST if not parentStrumline.skinData.antialiased else TEXTURE_FILTER_PARENT_NODE
		var scale = (1.0 / pos.z)
		modulate.a = info['alpha']
		sprite.material.set_shader_parameter('scale', Vector2(parentStrumline.skinData.scale * scale, parentStrumline.skinData.scale * scale))
var switchToStatic = false
func playStatic():
	switchToStatic = false
	sprite.set_frame_and_progress(0,0)
	sprite.play(strumAnims[column][0])
	sprite.material.set_shader_parameter('canColor', false)
func playPress():
	switchToStatic = false
	sprite.set_frame_and_progress(0,0)
	sprite.play(strumAnims[column][1])
	sprite.material.set_shader_parameter('canColor', false)
func playConfirm(doStatic=false):
	sprite.set_frame_and_progress(0,0)
	switchToStatic = doStatic
	sprite.play(strumAnims[column][2])
	timer = 0
	if Preferences.getPreference('quants'):
		sprite.material.set_shader_parameter('canColor', true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

var timer = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.material.set_shader_parameter('position', Vector2(pos.x, pos.y))
	modulate.a = info['alpha']
	var scale = (1.0 / pos.z)
	sprite.material.set_shader_parameter('scale', Vector2(parentStrumline.skinData.scale * scale , parentStrumline.skinData.scale * scale))
	if switchToStatic:
		timer += delta
		if timer >= 0.15:
			playStatic()
			timer = 0
			switchToStatic = false
