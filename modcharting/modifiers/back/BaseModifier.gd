class_name BaseModifier
extends Node
var modMgr:ModMan
var values:Array[float] = [0,0]
func name():
	return 'Modifier'
func active(player):
	return getValue(player) != 0
func doesUpdate():
	return false
func _init(modMgr:ModMan) -> void:
	self.modMgr = modMgr
func getPos(diff:float, tDiff:float, beat:float, data:int, player:int, obj:Node2D, field:NoteField, pos:Vector3):
	return pos
func getExtraInfo(diff:float, tDiff:float, beat:float, data:int, player:int, obj:Node2D, field:NoteField, info:RenderInfo):
	return info
func getValue(player):
	return values[player]
func setValue(player, num):
	if player != -1:
		values[player] = num
	else:
		for i in range(len(values)):
			values[i] = num
func update(delta:float, beat:float):
	pass
