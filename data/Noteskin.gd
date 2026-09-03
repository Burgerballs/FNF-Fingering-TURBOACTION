extends Resource
class_name NoteSkin

@export var frames:SpriteFrames;
@export var quant_frames:SpriteFrames;
@export var scale:float = 0.7
@export var antialiased:bool = false
@export var sustainWidth:float = 1
@export var noteAnimPrefixes4K = [
	'purple',
	'blue',
	'green',
	'red'
]
@export var sustainHoldPiecesPrefixes4K = [
	'purple hold piece',
	'blue hold piece',
	'green hold piece',
	'red hold piece'
]
@export var sustainHoldEndsPrefixes4K = [
	'purple hold end',
	'blue hold end',
	'green hold end',
	'red hold end'
]

@export var receptorsPrefixes4K = [
	['arrowLEFT', 'left press', 'left confirm'],
	['arrowDOWN', 'down press', 'down confirm'],
	['arrowUP', 'up press', 'up confirm'],
	['arrowRIGHT', 'right press', 'right confirm'],
]
