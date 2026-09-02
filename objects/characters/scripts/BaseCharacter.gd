class_name BaseCharacter
extends Node2D
var curDance:int = 0
@export var danceArray:Array[String] = ['idle']
@export var anims:Array[BaseAnim] = [] 
var curAnim:String = 'idle'
@export var singDuration:float = 4.0
var holdTimer:float = 0;
@export var animationPlayer:AnimationPlayer
@export var cameraPosition:Node2D

var canPlaySpecials:
	get():
		return animationPlayer != null
var cam_pos:Vector2:
	get:
		var pos = cameraPosition.global_position
		if not flipped:
			return pos
		else:
			var difference = (global_position.x + get_size().x) - pos.x
			return Vector2(difference, pos.y)
signal on_flip
var flipped = false:
	set(v):
		flipped = v
		on_flip.emit()
func find_animation(name = 'idle'):
	for anim in anims:
		if (anim.name == name):
			return anim
	return null

func get_size():
	return Vector2(0,0)
func play(name, forced = false):
	holdTimer = 0
	curAnim = name
	var anim = find_animation(name)
	if anim != null:
		if anim is SpecialAnim:
			if animationPlayer != null:
				animationPlayer.play(anim.anim_name)
				if forced:
					animationPlayer.seek(0, true)
func resetDance(holding:bool):
	if (holdTimer * (Conductor.step_crotchet*100) > singDuration && !holding):
		dance(true)
		holdTimer = 0
func dance(forced = false):
	curDance = wrapi(curDance + 1, 0, danceArray.size() - 1)
	play(danceArray[curDance])
func _process(delta: float) -> void:
	if (curAnim.begins_with('sing')):
		holdTimer = holdTimer + delta
	else:
		holdTimer = 0
	
