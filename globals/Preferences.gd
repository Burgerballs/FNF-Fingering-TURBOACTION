extends Node
var defaultSaveRef:Dictionary = {
	"downscroll": false,
	"centered_notefield": false,
	"accuracy_system": "Judgment",
	'ghost_tapping': true,
	'scroll_speed_multiplier': 1.,
	'note_offset': 0.,
	'judgment_offset': 0.,
	'sfx_volume': 1.,
	'hitsound_volume': 0.,
	'hold_subdivisions': 1.,
	'quants': false,
	'hitsound_behaviour': "Key Press",
	"controls": {
		"note_left": 'Left',
		'note_down': 'Down',
		'note_up': 'Up',
		'note_right': 'Right',
		"ui_left": 'Left',
		'ui_down': 'Down',
		'ui_up': 'Up',
		'ui_right': 'Right',
		'ui_enter': 'Enter',
		'ui_back': 'Escape',
		'reset': 'R'
	}
}
var defaultSave:Dictionary = defaultSaveRef.duplicate(true)
var playerSaveFile
func _ready():
	var json:Dictionary = {}
	
	if not FileAccess.file_exists("user://Preferences.json"):
		playerSaveFile = FileAccess.open("user://Preferences.json", FileAccess.WRITE)
		playerSaveFile.store_string('{}')
	playerSaveFile = FileAccess.open("user://Preferences.json", FileAccess.READ_WRITE)
	json = JSON.parse_string(playerSaveFile.get_as_text())
	for key in defaultSave:
		if key in json:
			defaultSave[key] = json[key]
		else:
			json[key] = defaultSave[key]
			
	for key in defaultSave["controls"]:
		if not (key in json["controls"]):
			json["controls"][key] = defaultSave["controls"][key]
	saveData()
	actUpon()
func set_binds():
	var binds = ['note_left', 'note_down', 'note_up', 'note_right',
				'ui_left', 'ui_right', 'ui_right', 'ui_right',
				'ui_enter', 'ui_back', 'reset']
	for i in binds:
		Input.set_use_accumulated_input(false)
		var key = InputMap.action_get_events(i)
		var bind = InputEventKey.new()
		bind.set_keycode(OS.find_keycode_from_string(defaultSave["controls"][i].to_lower()))
		InputMap.action_add_event(i, bind)
func actUpon():
	set_binds()
	Main.downscroll = getPreference('downscroll')
	Main.sustainDensity = getPreference('hold_subdivisions')
func saveData():
	var file = FileAccess.open("user://Preferences.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(defaultSave))
func getPreference(string): return defaultSave[string]
func getControl(string): return defaultSave["controls"][string]
func setControl(string, thing): 
	defaultSave["controls"][string] = thing
	actUpon()
	saveData()
func setPreference(str, thing): 
	defaultSave[str] = thing
	saveData()
