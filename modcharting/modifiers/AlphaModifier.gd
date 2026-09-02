class_name AlphaModifier
extends BaseModifier
func name():
	return 'alpha'
func active(player):
	return true
	

func getExtraInfo(diff:float, tDiff:float, beat:float, data:int, player:int, obj:Node2D, field:NoteField, info:RenderInfo):
	
	info.alpha -= getValue(player)
	
	return info
