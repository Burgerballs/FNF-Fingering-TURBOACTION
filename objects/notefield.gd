class_name NoteField
extends Node2D

@export var playerNum:int = 0
@export var player:bool = false
@export var keyCount:int = 4
var keysPressed = [false, false, false, false]
signal noteHit(note:Note)
signal noteMiss(note:Note)
@onready var strums = $Strums
@onready var holds = $Holds
@onready var notes = $Notes
var trackIndex:int = 1
var linkedCharacter:BaseCharacter
var scrollSpeed = 1;
var notesUnspawned:Array[NoteData] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	readyStrums()
	Conductor.step_hit.connect(step_hit)
func readyStrums():
	for i in range(keyCount):
		var n:StrumNote = load("res://objects/StrumNote.tscn").instantiate()
		n.column = i
		strums.add_child(n)
		n.sprite.material = n.sprite.material.duplicate()
		n.pos = ModMan.instance.getPos(0, 0, Conductor.beat, n.column, playerNum, n, self, Vector3(0,0,0))
		n.playStatic()

func asc(a:Note,b:Note):
	return a.strumtime < b.strumtime

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _spawn_loop():
	for i in notesUnspawned.filter(func(d): return d.time - time <= 2000):
		var note = notesUnspawned.pop_front()
		notesUnspawned.erase(note)
		var n:Note = load("res://objects/Note.tscn").instantiate()
		n.column = note.column
		n.length = i.length
		n.strumtime = note.time
		notes.add_child(n)
		n.position.y = 10000000
		n.sprite.material = n.sprite.material.duplicate()
		n.parentStrumline = self
		var color:Color = QuantShit.getQuantColor(note.time)
		n.sprite.material.set_shader_parameter('color', Vector3(color.r, color.g, color.b))
		if n.length > 0:
			var s:Sustain = load("res://objects/Sustain.tscn").instantiate()
			s.strumtime = 0
			s.parentStrumline = self
			s.strumtime = n.strumtime
			s.timelength = n.length
			s.column = n.column
			s.material = s.material.duplicate()
			s.material.set_shader_parameter('color', Vector3(color.r, color.g, color.b))
			holds.add_child(s)
			n.sustain = s
		n.refresh_note()
var time = 0
var spawnTimer:float = 2
func _process(delta: float) -> void:
	time = Conductor.position*1000
	spawnTimer+=delta
	if spawnTimer >= 1./24.:
		_spawn_loop()
		spawnTimer = 0
	for strum in strums.get_children():
		strum.pos = ModMan.instance.getPos(0, 0, Conductor.beat, strum.column, playerNum, strum, self, Vector3(0,0,0))
		strum.info = ModMan.instance.getExtraInfo(0,0, Conductor.beat, strum.column, playerNum, strum, self)
	for note in notes.get_children():
		if note.strumtime - (Conductor.position*1000) < 0 and not player:
			good_note_hit(note)
			strums.get_child(note.column).sprite.material.set_shader_parameter('color', note.sprite.material.get_shader_parameter('color'))
			strums.get_child(note.column).playConfirm(note.sustain == null)
			if note.sustain != null:
				note.sustain.shrinking = true
			if trackIndex != 0:
				Main.music.stream.set_sync_stream_volume(trackIndex, 0)
		if not note.canHit && note.strumtime - (Conductor.position*1000) < 0 and not note.missed:
			note.missed = true
			noteMiss.emit(note)
			
		if note.shouldDestroy:
			notes.remove_child(note)
			note.queue_free()
		else:
			note.info = ModMan.instance.getExtraInfo(note.strumtime-time, note.strumtime-time, Conductor.beat, note.column, playerNum, note, self)
			note.pos = ModMan.instance.getPos(note.strumtime-time, note.strumtime-time, Conductor.beat, note.column, playerNum, note, self, Vector3(0,0,0))
	for sus in holds.get_children():
		
		if sus.shouldDestroy:
			holds.remove_child(sus)
			sus.queue_free()
		if sus.shrinking && not sus.dead:
			if trackIndex != 0:
				Main.music.stream.set_sync_stream_volume(trackIndex, 0)
			linkedCharacter.play('sing' + (['LEFT','DOWN','UP','RIGHT'])[sus.column], true)
		elif sus.confirmedCompleted:
			if not Input.is_action_pressed(Main.noteBinds[keyCount][sus.column]):
				strums.get_child(sus.column).playStatic()
		elif sus.dead && not sus.confirmedKilled:
			if player:
				strums.get_child(sus.column).playStatic()
			else:
				strums.get_child(sus.column).playConfirm(true)
			sus.confirmedKilled = true
			noteMiss.emit(sus)
			
func step_hit(step):
	for sus in holds.get_children():
		if sus.shrinking && not sus.dead:
			strums.get_child(sus.column).playConfirm()
func good_note_hit(note:Note):
	note.wasHit = true
	note.shouldDestroy = true
	linkedCharacter.play('sing' + (['LEFT','DOWN','UP','RIGHT'])[note.column], true)
	if player:
		noteHit.emit(note)
		if (note.sustain != null):
			time = Conductor.position*1000
			note.sustain.timelength += note.strumtime-time
			note.sustain.shrinking = true
func _unhandled_input(_event: InputEvent) -> void:
	if !player: return
	var it = 0
	for i in range(keyCount):
		keysPressed[it] = Input.is_action_pressed(Main.noteBinds[keyCount][it])
		if Input.is_action_just_pressed(Main.noteBinds[keyCount][it]):
			var sustains = holds.get_children().filter(func(a:Sustain):return a.column == it and a.released and not a.dead)
			for sus in sustains:
				sus.released = false
				sus.coyoteTimer = 0.45
				
			var noteses = notes.get_children().filter(func(a:Note):return a.canHit and not a.wasHit and a.column == it)
			noteses.sort_custom(asc)
			if (noteses.size() >= 1):
				if Preferences.getPreference('quants'):
					strums.get_child(i).sprite.material.set_shader_parameter('color', noteses[0].sprite.material.get_shader_parameter('color'))
				strums.get_child(i).playConfirm()
				var note:Note = noteses[0]
				good_note_hit(note)
			elif sustains.size() == 0:
				strums.get_child(i).playPress()
		elif Input.is_action_just_released(Main.noteBinds[keyCount][it]):
			var sustains = holds.get_children().filter(func(a:Sustain):return a.column == it and a.shrinking)
			if sustains.size() == 0:
				strums.get_child(i).playStatic()
			for sus in sustains:
				sus.released = true
		it+=1
