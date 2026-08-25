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
		BeatModifier.new(self),
		PerspectiveModifier.new(self)
	]
	for i in quickRegs:
		registry[i.name] = i
func getPos(diff:float, tDiff:float, beat:float, data:int, player:int, obj:Node2D, field:NoteField, pos:Vector3):
	
	if (pos == null):
		pos = Vector3();

	diff *= (0.45 * 3.15)
	
	pos = Vector3(
		getBaseX(data,player,field.keyCount),
		diff,
		1
	)
	for ident in registry:
		var mod = registry[ident]
		if not mod.active(player): continue
		pos = mod.getPos(diff,tDiff,beat,data,player,obj,field,pos)
	return pos;
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
		if not mod.doesUpdate():
			mod.update(delta, Conductor.beat)
