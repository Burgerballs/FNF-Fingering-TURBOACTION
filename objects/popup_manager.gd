extends Node2D
@onready var ratings = $ratings
@onready var ratingsAnim = $ratings/AnimationPlayer
@onready var digits = $digits
@onready var comboTemplate = $ComboTemplate
var indexes = [
	'epic',
	'sick',
	'good',
	'bad',
	'shit',
	'miss'
]
var fadeTimer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fadeTimer -= delta * (Conductor.step_crotchet*100)
	modulate.a = fadeTimer
func doPopup(judgement = 'epic'):
	var d = 0
	fadeTimer = 5
	for i in indexes:
		if i == judgement:
			ratings.frame_coords.y = d
		d+=1
	ratingsAnim.play('bump')
	ratingsAnim.seek(0)
	var comboDigits = Ratings.instance.combo
	var it = 0
	for i in digits.get_children():
		i.queue_free()
	for i in str(comboDigits).split():
		var digit:Sprite2D = comboTemplate.duplicate()
		digit.frame_coords.x = int(i)
		digits.add_child(digit)
		digit.visible = true
		digit.position.x += 46 * it
		digit.get_child(0).play('bump')
		it += 1
