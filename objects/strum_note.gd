extends Node2D
class_name StrumNote

@onready var sprite:AnimatedSprite2D = $sprite
@export var column = 0;
var pos:Vector3 = Vector3()
var sustain:Sustain
var length = 2000
var strumAnims:Array = [
	['arrowLEFT', 'left press', 'left confirm'],
	['arrowDOWN', 'down press', 'down confirm'],
	['arrowUP', 'up press', 'up confirm'],
	['arrowRIGHT', 'right press', 'right confirm'],
	
]

var switchToStatic = false
func playStatic():
	sprite.frame = 0
	sprite.play(strumAnims[column][0])
func playPress():
	sprite.frame = 0
	sprite.play(strumAnims[column][1])
func playConfirm(doStatic=false):
	sprite.frame = 0
	switchToStatic = doStatic
	sprite.play(strumAnims[column][2])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.material.set_shader_parameter('position', Vector2(pos.x, pos.y))
	var scale = (1.0 / pos.z)
	sprite.material.set_shader_parameter('scale', Vector2(0.7 * scale, 0.7 * scale))


func _on_sprite_animation_finished() -> void:
	if switchToStatic:
		playStatic()
		switchToStatic = false
