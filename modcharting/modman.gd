extends Node2D
class_name ModMan

var swagWidth:float = 160 * 0.7
var playerAmount:int = 2
var spawnTime:float = 1000
var registry:Dictionary = {}
static var instance:ModMan = ModMan.new();

func _init():
	ModMan.instance = self
	var quickRegs = [
		ReverseModifier.new(self),
		AlphaModifier.new(self),
		BeatModifier.new(self),
		PerspectiveModifier.new(self),
		OpponentModifier.new(self)
	]
	for i in quickRegs:
		registry[i.name()] = i
		
		
func setValue(modifier:String, value:float, player:int = -1):
	if registry.has(modifier):
		registry[modifier].setValue(player, value)
	else:
		print('No value named ', modifier, ' exists.')
func getPos(diff:float, tDiff:float, beat:float, data:int, player:int, obj:Node2D, field:NoteField, pos:Vector3):
	
	if (pos == null):
		pos = Vector3();

	diff *= (0.45 * field.scrollSpeed)
	
	pos = Vector3(
		getBaseX(data,player,field.keyCount),
		diff,
		1
	)
	for ident in registry:
		var mod = registry[ident]
		if not mod.active(player) or not mod.doesUsePos(): continue
		pos = mod.getPos(diff,tDiff,beat,data,player,obj,field,pos)
	return pos;
	
func getExtraInfo(diff:float, tDiff, beat:float, data:int, player:int, obj:Node2D, field:NoteField, info:Dictionary = {
	'alpha': 1
}):
	
	for ident in registry:
		var mod = registry[ident]
		if not mod.active(player) or not mod.doesUseInfo(): continue
		info = mod.getExtraInfo(diff,tDiff,beat,data,player,obj,field,info)
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
	for ident in registry:
		var mod = registry[ident]
		if mod.doesUpdate():
			mod.update(delta, Conductor.beat)
