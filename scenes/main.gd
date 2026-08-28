extends Node2D

var poo = [
	'freeplay',
	'options'
]
@onready var rect = $ColorRect
@onready var vcont = $VBoxContainer
var cur_select:int = 0

func _process(delta:float) -> void:
	rect.position = lerp(rect.position, vcont.get_child(cur_select).global_position, delta*18)
	rect.size = lerp(rect.size, vcont.get_child(cur_select).size, delta*18)
func select(d:int):
	cur_select = wrap(cur_select+d, 0, poo.size())
func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('ui_up'):
		select(-1)
	if Input.is_action_just_pressed('ui_down'):
		select(1)
	if Input.is_action_just_pressed('ui_accept'):
		match poo[cur_select]:
			'freeplay':
				get_tree().change_scene_to_file("res://scenes/freeplay.tscn")
