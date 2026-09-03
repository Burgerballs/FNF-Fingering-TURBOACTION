extends BaseIcon

@export var iconSlices:Dictionary = {
	0: 1,
	0.2: 0,
	0.8: 2
}
@export var sprite:Sprite2D
func set_icon():
	sprite.flip_h = isPlayer
	for slice in iconSlices:
		if val >= slice:
			if sprite.hframes >= iconSlices[slice]+1:
				sprite.frame_coords.x = iconSlices[slice]
			else:
				sprite.frame_coords.x = 0
