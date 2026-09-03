class_name Note
extends Node2D
@onready var sprite = $sprite
var pos:Vector3 = Vector3()
var strumtime:float = 0
var column:int = 0
var shouldDestroy:bool = false
var canHit:bool = false
var sustain:Sustain
var parentStrumline:NoteField
var length = 0
var tooLate = false
var wasHit:bool = false
var health:float = 0.22;
var missed = false
var skin:String:
	set(v):
		skin = v
		texture_filter = TEXTURE_FILTER_NEAREST if not parentStrumline.skinData.antialiased else TEXTURE_FILTER_PARENT_NODE
		sprite.sprite_frames = parentStrumline.skinData.quant_frames if (Preferences.getPreference('quants') and parentStrumline.skinData.quant_frames != null) else parentStrumline.skinData.frames
var info = {
	'alpha': 1
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func refresh_note():
	sprite.play(parentStrumline.skinData.noteAnimPrefixes4K[column])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (position != Vector2.ZERO):
		position = Vector2.ZERO
	sprite.material.set_shader_parameter('position', Vector2(pos.x, pos.y))
	
	var scale = (1.0 / pos.z)
	modulate.a = info['alpha']
	sprite.material.set_shader_parameter('scale', Vector2(parentStrumline.skinData.scale * scale, parentStrumline.skinData.scale * scale))
	
	canHit = absf(strumtime - (Conductor.position * 1000)) <= Ratings.max_ms

	shouldDestroy = strumtime - (Conductor.position * 1000) <= -1000
