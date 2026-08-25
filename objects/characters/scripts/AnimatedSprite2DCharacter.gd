class_name AnimatedSprite2DCharacter
extends BaseCharacter
@export var sprite:AnimatedSprite2D

func _ready() -> void:
	connect('on_flip', flip)

func find_animation(name = 'idle'):
	for anim in anims:
		if (anim.name == name):
			return anim
	return null

func get_size():
	return sprite.sprite_frames.get_frame_texture(find_animation(danceArray[0]).prefix, 0).get_size()

func play(name, forced = false):
	var anim = find_animation(name)
	if anim != null:
		sprite.sprite_frames.set_animation_speed(anim.prefix, anim.fps)
		sprite.position = -anim.offset
		if flipped:
			sprite.position.x = -sprite.position.x
		holdTimer = 0
		curAnim = name
		sprite.play(anim.prefix)
		if forced:
			sprite.set_frame_and_progress(0,0)

func dance(forced = false):
	if ((sprite.is_playing() || curAnim.begins_with('sing')) && !forced): return
	curDance = wrapi(curDance + 1, 0, danceArray.size() - 1)
	play(danceArray[curDance])

func flip() -> void:
	sprite.flip_h = flipped
