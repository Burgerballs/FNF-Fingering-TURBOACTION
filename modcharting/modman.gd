extends Node2D
class_name ModMan

var swagWidth:float = 160 * 0.7
var playerAmount:int = 2
var spawnTime:float = 1000
var registry:Dictionary = {}
var beatFactors:Array[Array] = [[0,0,0],[0,0,0]]
static var instance:ModMan = ModMan.new();

func _init():
	ModMan.instance = self
	var quickRegs = [
		'reverse',
		'alpha',
		'beat',
		'opponentSwap'
	]
	for i in quickRegs:
		registry[i] = BaseModifier.new(self)
func scale(value:float, clow:float, chigh:float, nlow:float, nhigh:float):
	return (value - clow) * (nhigh - nlow) / (chigh - clow) + nlow;
func updateBeat(axis:int, beat:float, pn:int, offset:float, mult:float):
		if (beatFactors[pn] == null):
			beatFactors[pn] = [];

		var accelTime:float = 0.2;
		var totalTime:float = 0.5;

		beat = (beat + accelTime + offset) * (mult + 1.);
		var evenBeat = int(beat) % 2 != 0;

		if (beat < 0):
			return;

		beat -= floorf(beat);
		beat += 1;
		beat -= floorf(beat);
		
		if (beat >= totalTime):
			return;

		var amount:float = 0;
		if (beat < accelTime):
			amount = scale(beat, 0, accelTime, 0, 1.);
			amount *= amount;
		else:
			amount = scale(beat, accelTime, totalTime, 1., 0);
			amount = 1. - (1. - amount) * (1. - amount);

		if (evenBeat):
			amount *= -1.;

		beatFactors[pn][axis] = 40. * amount;
func getReverseValue(data:int, player:int):
	var v = getValue('reverse', player)
	
	v = 1 - v if Main.downscroll else v
	
	return v
func getValue(modifier:String, player:int = -1):
	if registry.has(modifier):
		return registry[modifier].getValue(player)
func setValue(modifier:String, value:float, player:int = -1):
	if registry.has(modifier):
		registry[modifier].setValue(player, value)
	else:
		print('No value named ', modifier, ' exists.')
var origin = Vector3(DisplayServer.window_get_size().x * 0.5,DisplayServer.window_get_size().y * 0.5, 0)
func getPos(diff:float, tDiff:float, beat:float, data:int, player:int, obj:Node2D, field:NoteField, pos:Vector3):
	
	if (pos == null):
		pos = Vector3();

	diff *= (0.45 * field.scrollSpeed)
	
	pos = Vector3(
		getBaseX(data,player,field.keyCount),
		diff,
		1
	)
	
	# Reverse
	var swagOffset:float = (swagWidth / 2);
	var reversePerc = getReverseValue(data, player);
	var shift = lerp(swagOffset, 720 - (swagOffset*2.75), reversePerc);
	pos.y = shift + lerp(diff, -diff, reversePerc);
	
	# OpponentSwap
	var distX = 1280 / playerAmount;
	
	pos.x += distX * sign((player + 1) * 2 - 3) * getValue('opponentSwap', player);
	
	# Beat
	pos.x += getValue('beat', player) * (beatFactors[player][0] * sin(((diff) / 30.) + PI * 0.5));
	
	# Perspective
	pos -= origin
	pos.y = pos.y / (pos.z)
	pos.x = pos.x / (pos.z)
	pos += origin
	return pos;
	
func getExtraInfo(diff:float, tDiff, beat:float, data:int, player:int, obj:Node2D, field:NoteField, info:Dictionary = {
	'alpha': 1
}):
	
	info['alpha'] -= getValue('alpha', player)
	return info
# TAKEN FROM THIS!!! THANKS MARSH AND STUFF!!
# https://github.com/troll-slaiyers/FNF-Troll-Engine/blob/b47ea131177e523372474a11e6d0856d17658689/source/funkin/modchart/ModManager.hx#L565
func getBaseX(direction:int = 0, player:float = 0, receptorAmount:int = 4):
	var spaceWidth:int = 1280 / playerAmount;
	var spaceX = spaceWidth * (playerAmount-1-player);

	var baseX:float = spaceX + (spaceWidth - swagWidth * receptorAmount) * 0.5;
	var x:float = baseX + swagWidth * direction;

	return x;
func update(delta: float) -> void:
	for player in range(len(beatFactors)):
		updateBeat(0, Conductor.beat, player, 0, 0);
		updateBeat(1, Conductor.beat, player, 0, 0);
		updateBeat(2, Conductor.beat, player, 0, 0);
