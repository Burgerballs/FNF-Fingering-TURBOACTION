extends Node2D
class_name BaseIcon

func set_icon():
	return
var isPlayer:bool = false
# Position in the healthbar
var val:float = 0.5:
	set(v):
		set_icon()
		val = v
		return v

func _ready() -> void:
	pass
