extends Node2D
class_name Game
var modManager:ModMan = ModMan.new();
var bf:BaseCharacter
var dad:BaseCharacter
@onready var playerField = $hud/PlrField
@onready var opponentField = $hud/Oppfield
var song:Song
var stage:BaseStage;
var curStage = 'Stage'
var curBF = 'bf'
var songPlayed = false
@onready var camGame:Camera2D = $camGame
var stats:Ratings = Ratings.new()
var strumlines:Array[NoteField] = []
@onready var hud = $hud/SignatureHud
@onready var popups = $hud/PopupManager
# Called when the node enters the scene tree for the first time.
@onready var songName = 'test'
var behaviour:Node2D = null;

signal pre_ready
signal post_ready
signal pre_process(delta:float)
signal post_process(delta:float)
signal note_hit(note:Note)
signal note_missed(note:Note)
signal cam_targeted(character:BaseCharacter)


func _ready() -> void:
	Engine.physics_ticks_per_second = DisplayServer.screen_get_refresh_rate()
	songName = Main.nextSong
	song = Song.parse(Main.nextSong, 'normal')
	
	pre_ready.emit()
	if (song.behaviour != ''):
		behaviour = load(song.behaviour).instantiate()
		behaviour.game = self
		add_child(behaviour)
	
	strumlines = [playerField, opponentField]
	var it = 0
	for line in song.notes:
		for note in line:
			strumlines[it].notesUnspawned.append(note)
		strumlines[it].scrollSpeed = song.speed * Preferences.getPreference('scroll_speed_multiplier')
		strumlines[it].playerNum = it
		it+=1
	stage = load("res://objects/stages/" +curStage+ ".tscn").instantiate()
	playerField.connect('noteHit', good_note_hit)
	playerField.connect('noteMiss', note_miss)
	Conductor.connect('beat_hit', beat_hit)
	
	if Preferences.getPreference('centered_notefield'):
		modManager.setValue('opponentSwap', 0.5, -1)
		modManager.setValue('alpha', 1, 1)
	
	var it2 = 0
	var trackPaths:Array[String] = []
	for k in song.tracks:
		if k == 'vocals':
			playerField.trackIndex = it2
			opponentField.trackIndex = it2
		if k == 'player':
			playerField.trackIndex = it2
		if k == 'opponent':
			opponentField.trackIndex = it2
		trackPaths.append(song.tracks[k])
		it2+=1
	if trackPaths.size() == 1:
		playerField.trackIndex = 0
		opponentField.trackIndex = 0
	
	Main.setupMultitrack(trackPaths)
	Conductor.bpm = song.bpm
	Conductor.position = -Conductor.crotchet*4
	
	add_child(stage)
	bf = load("res://objects/characters/" +curBF+ ".tscn").instantiate()
	add_child(bf)
	bf.position = stage.bf_pos.position
	bf.position.y -= bf.get_size().y
	bf.position.x -= bf.get_size().x / 2
	
	playerField.linkedCharacter = bf
	
	dad = load("res://objects/characters/" +curBF+ ".tscn").instantiate()
	add_child(dad)
	dad.position = stage.dad_pos.position
	dad.flipped = true
	dad.position.y -= dad.get_size().y
	dad.position.x -= dad.get_size().x / 2
	
	opponentField.linkedCharacter = dad
	
	post_ready.emit()
	
func beat_hit(b):
	for char in [bf, dad]:
		char.dance()
		
func retarget(char:BaseCharacter):
	camGame.position = char.cam_pos
	cam_targeted.emit(char)
func note_miss(note):
	stats.handleMiss()
	if note.parentStrumline.trackIndex != 0:
		Main.music.stream.set_sync_stream_volume(note.parentStrumline.trackIndex, -60)
	popups.doPopup('miss')
	hud.handleRating()
	note_missed.emit(note)
func good_note_hit(note:Note):
	var diff = absf(note.strumtime - (Conductor.position * 1000))
	var rating = stats.judgeNote(diff + Preferences.getPreference('judgment_offset'))
	Main.music.stream.set_sync_stream_volume(note.parentStrumline.trackIndex, 0)
	popups.doPopup(rating)
	hud.handleRating()
	note_hit.emit(note)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Conductor.position > 0 and not songPlayed):
		Main.music.play(0.0)
		Conductor.link(Main.music)
		songPlayed = true
	elif (Conductor.position < 0):
		Conductor.position += delta
	pre_process.emit(delta)
		
	for event in song.camera_events:
		if event.time < Conductor.position * 1000:
			retarget(strumlines[event.field].linkedCharacter)
			song.camera_events.erase(event)
	if stats.health < stats.healthMin:
		Main.music.stop()
		get_tree().change_scene_to_file("res://scenes/fuckingdead.tscn")
	bf.resetDance(playerField.keysPressed.find(true) >= 0)
	dad.resetDance(false)
	
	modManager.call_deferred('update', delta)
	post_process.emit(delta)
	if Input.is_action_just_pressed('ui_back'):
		quit()
func quit():
	Main.music.stop()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
