class_name AnimatedSprite2DCharacter
extends BaseCharacter
@export var sprite:AnimatedSprite2D

func _ready() -> void:
	connect('on_flip', flip)

func get_size():
	return sprite.sprite_frames.get_frame_texture(find_animation(danceArray[0]).prefix, 0).get_size()*sprite.scale

func play(name, forced = false):
	var anim = find_animation(name)
	if animationPlayer != null:
		animationPlayer.play('RESET')
	if anim != null:
		if anim is SpecialAnim:
			if animationPlayer != null:
				
				animationPlayer.play(anim.anim_name)
				if forced:
					animationPlayer.seek(0, true)
		else:
			sprite.sprite_frames.set_animation_speed(anim.prefix, anim.fps)
			sprite.offset = -anim.offset
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
