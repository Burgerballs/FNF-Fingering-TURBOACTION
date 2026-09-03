@tool
extends AnimatedSprite2D
class_name AnimatedSprite

@export var playing: bool = false:
	set(value):
		return set_playing(value);

	get:
		return is_playing()

func set_playing(value):
	if value:
		play()
	else:
		pause()
