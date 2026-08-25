extends Node
class_name Song

var notes:Array = [] # 2D array of notes, X = strumline, Y = note
var speed:float = 3.0
var bpm = 120
var tracks:Dictionary = {}
var camera_events:Array[CameraEvent] = []

static func parse(name:String, difficulty:String = 'normal'):
	var path = "res://assets/songs/"+name.to_lower()
	var header = JSON.parse_string(FileAccess.get_file_as_string(path+"/header.json"))
	var chartPath = path + '/' + header['charts'][difficulty]
	var chart = Song.new()
	match header['format']:
		'vslice':
			chart = parse_vslice(chartPath, difficulty)
		_:
			chart = parse_psych(chartPath)
	for k in header["tracks"]:
		var value = header["tracks"][k]
		chart.tracks.merge({k: path +'/'+ value})
	return chart

static func parse_vslice(path, difficulty = 'normal'):
	var t = JSON.parse_string(FileAccess.get_file_as_string(path))
	var chart = Song.new()
	chart.notes = [[],[]]
	for note:Dictionary in t['notes'][difficulty]:
		
		var time:float = note['t']
		var column:int = int(note['d']) % 4
		var length:float = 0 if not note.has('l') else note['l']
		chart.notes[int(note['d'])/4].append(NoteData.new(time,column, length))
	return chart

static func parse_psych(path):
	var t = JSON.parse_string(FileAccess.get_file_as_string(path))['song']
	var chart = Song.new()
	chart.bpm = t['bpm']
	chart.notes = [[],[]]
	var it = 0
	for sec:Dictionary in t['notes']:
		
		var event = CameraEvent.new()
		event.field = 0 if sec['mustHitSection'] else 1
		event.time = ((60.0 / chart.bpm) * 1000*4) * it
		chart.camera_events.append(event)
		
		for note in sec['sectionNotes']:
			var daNoteData:int = int(note[1]);
			var time:int = int(note[0]);
			var susLength = note[2];
			if (daNoteData == -1): continue
			var gottaHitNote:bool = (daNoteData < 4) if sec.mustHitSection else (daNoteData >= 4);
			chart.notes[0 if gottaHitNote else 1].append(NoteData.new(time,daNoteData%4, susLength))
		it += 1
	return chart
