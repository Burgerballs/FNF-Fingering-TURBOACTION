extends Node
class_name SongBehaviour
# The SongBehaviour class dictates what a song does whilst played, eg; modcharts, basic mechanics, in-song events, the likes.

var game:Game

# event structure:
	#{
		#"step": 24,
		#"func": func(): 
			#print('hello! world')
	#}
var eventQueue:Array[Dictionary] = []


func queueFunction(step:float, function:Callable):
	eventQueue.append({
		'step': step,
		'func': function
	})
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.note_hit.connect(good_note_hit)
	game.note_missed.connect(note_missed)
	game.pre_ready.connect(_pre_ready)
	game.post_ready.connect(_post_ready)
	game.pre_process.connect(_pre_process)
	game.post_process.connect(_post_process)
	Conductor.beat_hit.connect(beat_hit)
	Conductor.step_hit.connect(step_hit)
	Conductor.bar_hit.connect(bar_hit)
	
func beat_hit(beat:int):
	pass
func step_hit(step:int):
	pass
func bar_hit(bar:int):
	pass
func _pre_ready():
	pass
func _post_ready():
	pass
func good_note_hit(note:Note):
	pass
func note_missed(note):
	pass

func _pre_process(delta: float) -> void:
	pass
func _post_process(delta: float) -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in eventQueue.filter(func(t):return t['step'] - Conductor.step <= 0):
		i['func'].call()
		eventQueue.remove_at(eventQueue.find(i))
