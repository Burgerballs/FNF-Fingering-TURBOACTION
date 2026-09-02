class_name ReverseModifier
extends BaseModifier
func name():
	return 'reverse'
func active(player):
	return true
func doesUsePos():
	return true

func getReverseValue(data:int, player:int):
	var v = values[player]
	
	v = 1 - v if Main.downscroll else v
	
	return v

func getPos(diff:float, tDiff:float, beat:float, data:int, player:int, obj:Node2D, field:NoteField, pos:Vector3):
	var p = pos
	var swagOffset:float = (modMgr.swagWidth / 2);
	var reversePerc = getReverseValue(data, player);
	var shift = lerp(swagOffset, 720 - (swagOffset*2.75), reversePerc);
	p.y = shift + lerp(diff, -diff, reversePerc);
	return p
