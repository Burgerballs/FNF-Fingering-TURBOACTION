extends CanvasLayer
@onready var music:AudioStreamPlayer = $music
@onready var sfx:Node = $sfx
var sustainDensity:float = 1;

var downscroll:bool = true
var nextSong:String = 'test'
var noteBinds = {
	4: [
		'note_left',
		'note_down',
		'note_up',
		'note_right'
	]
}
@onready var fpsLabel = $FPS
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var elapsedTimer:float = 0
var frameCount:int = 0
func _process(delta: float) -> void:
	elapsedTimer+=delta
	frameCount = frameCount + 1
	if elapsedTimer >= 0.25:
		fpsLabel.text = 'FPS: '+str(frameCount*4) + ' [' + str(floor(delta*50000)/50) + 'ms]\n' 
		fpsLabel.text += 'RAM: ' + str(floor(OS.get_static_memory_usage() / 10000000.0 * 100) / 100) + 'MB\n'
		fpsLabel.text += 'VRAM: ' + str(floor(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 10000000.0 * 100) / 100) + 'MB\n'
		fpsLabel.text += 'DRAW CALLS: ' + str(int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)))
		frameCount = 0
		elapsedTimer = 0
	pass
func setupMultitrack(tracks:Array[String]):
	var syncStream:AudioStreamSynchronized = AudioStreamSynchronized.new()
	var it = 0
	for i in tracks:
		syncStream.stream_count += 1
		syncStream.set_sync_stream(it, load(i))
		it+=1
	music.stream = syncStream
func play_sound(stream, custom_pitch: float = 1.0, start_time: float = 0.0, volume: float = 1.0, bus_name:String = 'SFX'):
	var new_sound: AudioStreamPlayer = AudioStreamPlayer.new()
	new_sound.volume_db = linear_to_db(volume)
	new_sound.stream = stream
	new_sound.pitch_scale = custom_pitch
	new_sound.finished.connect(new_sound.queue_free)
	sfx.add_child(new_sound)
	new_sound.set_bus(bus_name)
	new_sound.play(start_time)
func launch_song(song:String, chart:String):
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
	nextSong = song
	print(song)
