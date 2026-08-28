extends Node2D

@onready var songtemplate = $Song
@onready var song_list = $SongList
@export var songs:Array = [
	['Test', 'test'],
	['Sporting (Vs Matt V3)', 'sporting'],
	['Opposition (Dave And Tung Sahir)', 'opposition'],
	['Tremendous (the delta 4k one)', 'tremendous']
]
var cur_select:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for song in songs:
		var songEntry = songtemplate.duplicate()
		songEntry.get_child(0).text = song[0]
		song_list.add_child(songEntry)
func select(d:int):
	cur_select = wrap(cur_select+d, 0, songs.size())
func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('ui_up'):
		select(-1)
	if Input.is_action_just_pressed('ui_down'):
		select(1)
	if Input.is_action_just_pressed('ui_accept'):
		Main.launch_song(songs[cur_select][1], '')
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	var it = 0
	for s in song_list.get_children():
		var intended = 1.
		if it == cur_select:
			intended = 1.1
		s.offset_transform_scale = Vector2(lerp(s.offset_transform_scale.x, intended, delta*18.), lerp(s.offset_transform_scale.y, intended, delta*18.))
		it+=1
