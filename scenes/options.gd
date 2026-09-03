extends Node2D

# Hardcoded because I am lazy.

var internalOptionsArr = []

@onready var optionTemplate = $OptionTemplate
@onready var categoryTemplate = $CategoryTemplate
@onready var creditTemplate = $CreditTemplate
@onready var categoryDivider = $CategoryDivider
@onready var optionContainer = $OptionsPanel/OptionContainer
@onready var categoryContainer = $Panel/VBoxContainer


@onready var selectorOption = $ColorRect/SelectorOption
@onready var selectorCat = $SelectorCategory

var optionsReg = {
	"downscroll": {
		"type": "toggle",
		"prevName": "Downscroll",
		"desc": "Notes move downwards instead of up. The HUD changes to reflect that change."
	},
	"centered_notefield": {
		"type": "toggle",
		"prevName": "Centered Notefield",
		"desc": "Your strumline will be in the middle of the screen, may not be supported on all songs."
	},
	"accuracy_system": {
		"type": "array",
		"prevName": "Accuracy System",
		"desc": "The way how accuracy will be calculated.",
		"options": ["Judgment", "Wife3", 'SuperBBE2Complex']
	},
	"ghost_tapping": {
		"type": "toggle",
		"prevName": "Ghost Tapping",
		"desc": "You will take damage if you press a key without any notes present once disabled."
	},
	"sfx_volume": {
		"type": "num",
		"bounds": [0.,1.,0.1],
		"prevName": "SFX Volume",
		"desc": "The sound level where SFX will play (eg; menu selection sounds, missing notes, etc)",
		"format": func(num): return '%s' % [str(int(num*100.))] + '%'
	},
	"hitsound_volume": {
		"type": "num",
		"bounds": [0.,1.,0.1],
		"prevName": "Hitsound Volume",
		"desc": "The sound level where hitsounds will play, depends on hitsound behaviour.",
		"format": func(num): return '%s' % [str(int(num*100.))] + '%'
	},
	"hitsound_behaviour": {
		"type": "array",
		"prevName": "Hitsound Behaviour",
		"desc": "How will hitsounds be played.",
		"options": ["Key Press", "Note Hit"]
	},
	"note_left": {
		"type": "control",
		"prevName": "Left Note [4K]",
		"desc": "The key used for the LEFT note direction"
	},
	"note_down": {
		"type": "control",
		"prevName": "Down Note [4K]",
		"desc": "The key used for the DOWN note direction"
	},
	"note_up": {
		"type": "control",
		"prevName": "Up Note [4K]",
		"desc": "The key used for the UP note direction"
	},
	"note_right": {
		"type": "control",
		"prevName": "Right Note [4K]",
		"desc": "The key used for the RIGHT note direction."
	},
	"ui_left": {
		"type": "control",
		"prevName": "UI Left",
		"desc": "The key used for navigating left in menus."
	},
	"ui_down": {
		"type": "control",
		"prevName": "UI Down",
		"desc": "The key used for navigating down in menus."
	},
	"ui_up": {
		"type": "control",
		"prevName": "UI Up",
		"desc": "The key used for navigating up in menus."
	},
	"ui_right": {
		"type": "control",
		"prevName": "UI Right",
		"desc": "The key used for navigating right in menus."
	},
	"ui_enter": {
		"type": "control",
		"prevName": "Accept",
		"desc": "The key used for confirming selections."
	},
	"ui_back": {
		"type": "control",
		"prevName": "Back",
		"desc": "The key used for leaving menus or cancelling selections."
	},
	"reset": {
		"type": "control",
		"prevName": "Reset",
		"desc": "The key used for triggering instant death, used for debugging or ragequitting purposes."
	},
	"scroll_speed_multiplier": {
		"type": "num",
		"bounds": [0.5,5.,0.1],
		"prevName": "Scroll Speed Multiplier",
		"desc": "The multiplier used for the speed of notes scrolling.",
		"format": func(num): return '%s' % [str(num)] + 'X'
	},
	"judgment_offset": {
		"type": "num",
		"bounds": [-200,200,1],
		"prevName": "Judgment Offset",
		"desc": "The offset for where notes get judged, + is later, - is earlier.",
		"format": func(num): return '%s%s' % ['-' if num < 0 else '+' if num > 0 else '', str(abs(int(num)))] + 'ms'
	},
	"note_offset": {
		"type": "num",
		"bounds": [-200,200,1],
		"prevName": "Note Offset",
		"desc": "The offset for where notes are positioned, + is later, - is earlier",
		"format": func(num): return '%s%s' % ['-' if num < 0 else '+' if num > 0 else '', str(abs(int(num)))] + 'ms'
	},
	"quants": {
		"type": "toggle",
		"prevName": "Use Quant Colors",
		"desc": "Enabling this makes notes colored by their time!"
	},
	"unlimitedFps": {
		"type": "toggle",
		"prevName": "Unlimited Framerate",
		"desc": "Enabling this will make the game try to do as many frames as it can, expect higher GPU and CPU usage."
	},
	"fpsLimit": {
		"type": "num",
		"bounds": [60,480,1],
		"prevName": "Framerate Limit",
		"desc": "How many frames will the game be allowed to do per second. Will be ignored if Unlimited Framerate is enabled.",
		"format": func(num): return '%s FPS' % [str(num)]
	},
	"hold_subdivisions": {
		"type": "num",
		"bounds": [1,4,1],
		"prevName": "Sustain Subdivisions",
		"desc": "How many subdivisions are made for each sustain piece.",
		"format": func(num): return 'x%s' % [str(num)]
	},
	"marsh": {
		"type": "credit",
		"prevName": "MarshmallowMoth",
		"desc": "Responsible for many of the code from Troll Engine which I reused for the modcharting system."
	},
	"myceli": {
		"type": "credit",
		"prevName": "Myceli",
		"desc": "The person who may or may not have made this engine."
	},
	"riconuts": {
		"type": "credit",
		"prevName": "Riconuts",
		"desc": "Drew the \"Epic!!\" graphic used in the default skin of the engine. Originated from Troll Engine."
	},
	"srt": {
		"type": "credit",
		"prevName": "SRTHero278",
		"desc": "Made the shader for color quants, originated from Vs Camellia's Never2x."
	}
}

var categories = {
	"Gameplay": [
		'downscroll',
		'centered_notefield',
		'accuracy_system',
		'ghost_tapping',
		'scroll_speed_multiplier',
		'judgment_offset',
		'note_offset'
	],
	"Visuals": [
		'quants'
	],
	"Performance": [
		'hold_subdivisions',
		'unlimitedFps',
		'fpsLimit'
	],
	"Audio": [
		"sfx_volume",
		"hitsound_volume",
		"hitsound_behaviour"
	],
	"Controls": [
		"note_left",
		"note_down",
		"note_up",
		"note_right",
		'reset',
		'ui_left',
		'ui_down',
		'ui_up',
		'ui_right',
		'ui_enter',
		'ui_back'
	],
	"Credits": [
		'myceli',
		'marsh',
		'riconuts',
		'srt'
	]
}

var catLinker = {}

var curSelect:int = 1
var catSelect:int = 0

func getValueString(option):
	match optionsReg[option]['type']:
		'num':
			var pref = Preferences.getPreference(option)
			var format = (func(num): return num) if not optionsReg[option].has('format') else optionsReg[option]['format']
			return '< '+str(format.call(pref))+' >'
		'array':
			var pref = Preferences.getPreference(option)
			return '< '+pref+' >'
		'toggle':
			var pref = Preferences.getPreference(option)
			return ('< Enabled >' if pref else '< Disabled >')
		'control':
			var pref = Preferences.getControl(option)
			return '< '+pref+' >'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Main.music.stream = load("res://assets/music/options.ogg")
	Main.music.stream.loop = true
	Main.music.play()
	
	var iterator = 0
	var it2 = 0
	for key in categories:
		# Blanks get skipped to make category dividers easier to manage.
		internalOptionsArr.append('')
		catLinker.merge({iterator: it2})
		iterator += 1
		var divider = categoryDivider.duplicate()
		divider.get_node('Name').text = key
		optionContainer.add_child(divider)
		var categoryLabel = categoryTemplate.duplicate()
		categoryLabel.text = key
		categoryContainer.add_child(categoryLabel)
		for option in categories[key]:
			internalOptionsArr.append(option)
			iterator += 1
			if optionsReg[option]['type'] != 'credit':
				var optionObj = optionTemplate.duplicate()
				
				optionObj.get_node('Name').text = optionsReg[option]['prevName']
				optionObj.get_node('Description').text = optionsReg[option]['desc']
				optionObj.get_node('Value').text = getValueString(option)
				optionContainer.add_child(optionObj)
			else:
				var optionObj = creditTemplate.duplicate()
				
				optionObj.get_node('Name').text = optionsReg[option]['prevName']
				optionObj.get_node('Description').text = optionsReg[option]['desc']
				optionContainer.add_child(optionObj)
		it2+=1
			
	selectorOption.position.y = optionContainer.get_child(curSelect).global_position.y

func setCategory(add:int):
	if (add == 0):
		var num = curSelect
		while not catLinker.has(num):
			num -= 1
		catSelect = catLinker[num]
	else:
		catSelect = wrap(catSelect + add, 0, len(categories))
		curSelect = catLinker.find_key(catSelect) + 1

func doScroll(add:int):
	curSelect = wrap(curSelect + add, 0, len(internalOptionsArr))
	if internalOptionsArr[curSelect] == '':
		doScroll(add)
		setCategory(0)

func modifyPref(add:int):
	var option = internalOptionsArr[curSelect]
	if option != '':
		var optionData = optionsReg[option]
		if (optionData['type'] == 'control' or optionData['type'] == 'credit'): return
		var pref = Preferences.getPreference(option)
		match optionData['type']:
			'num':
				pref = clampf(snappedf(pref + (optionData['bounds'][2] * add), optionData['bounds'][2]), optionData['bounds'][0], optionData['bounds'][1])
				print(pref)
			'array':
				var curPref = optionData['options'].find(pref)
				pref = optionData['options'][wrap(curPref + add, 0, len(optionData['options']))]
			'toggle':
				pref = not pref
		Preferences.setPreference(option, pref)
		Preferences.actUpon()
		optionContainer.get_child(curSelect).get_node('Value').text = getValueString(option)
		
var canSelect = true
var binding = false
func _unhandled_key_input(event: InputEvent) -> void:
	if (canSelect):
		if Input.is_key_pressed(KEY_SHIFT):
			if Input.is_action_just_pressed('ui_up'):
				setCategory(-1)
			elif Input.is_action_just_pressed('ui_down'):
				setCategory(1)
		else:
			if Input.is_action_just_pressed('ui_up'):
				doScroll(-1)
			elif Input.is_action_just_pressed('ui_down'):
				doScroll(1)
		
		var SHIFTMOD = 1 if not Input.is_key_pressed(KEY_SHIFT) else 5
		if Input.is_action_just_pressed('ui_left'):
			modifyPref(-1 * SHIFTMOD)
		elif Input.is_action_just_pressed('ui_right'):
			modifyPref(1 * SHIFTMOD)
		if Input.is_action_just_pressed('ui_enter'):
			if (optionsReg[internalOptionsArr[curSelect]]['type'] == 'control'):
				canSelect = false
				binding = true
				optionContainer.get_child(curSelect).get_node('Value').text = '< Press Any Key >'
		if Input.is_action_just_pressed('ui_back'):
			get_tree().change_scene_to_file("res://scenes/Main.tscn")
	elif (binding):
		if event.is_pressed():
			print('oooo')
			var key = OS.get_keycode_string(event.keycode)
			if (internalOptionsArr[curSelect] == 'ui_enter') or (internalOptionsArr[curSelect] != 'ui_enter' && !Input.is_action_just_pressed('ui_enter')):
				Preferences.setControl(internalOptionsArr[curSelect], key)
				Preferences.actUpon()
				optionContainer.get_child(curSelect).get_node('Value').text = getValueString(internalOptionsArr[curSelect])
				binding = false
				canSelect = true

# Called every frame. 'deltab' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	selectorOption.global_position.y = lerpf(selectorOption.global_position.y, optionContainer.get_child(curSelect).global_position.y + 2, delta * 24.)
	selectorCat.global_position.y = lerpf(selectorCat.global_position.y, categoryContainer.get_child(catSelect).global_position.y - 4, delta * 24.)
	var offset = -optionContainer.get_child(curSelect).position.y + 240
	optionContainer.offset_transform_position.y = lerpf(optionContainer.offset_transform_position.y, offset, delta * 12)
	selectorOption.offset_transform_position.y = lerpf(optionContainer.offset_transform_position.y, offset, delta * 12)
