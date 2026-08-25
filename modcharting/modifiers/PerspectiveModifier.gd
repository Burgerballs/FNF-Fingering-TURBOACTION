class_name PerspectiveModifier
extends BaseModifier
func name():
	return '_perspective'
func scale(value:float, clow:float, chigh:float, nlow:float, nhigh:float):
	return (value - clow) * (nhigh - nlow) / (chigh - clow) + nlow;
func doesUpdate():
	return true
func active(player):
	return true
var origin = Vector3(DisplayServer.window_get_size().x * 0.5,DisplayServer.window_get_size().y * 0.5, 0)
func getPos(diff:float, tDiff:float, beat:float, data:int, player:int, obj:Node2D, field:NoteField, pos:Vector3):
	pos -= origin
	pos.y = pos.y / (pos.z)
	pos.x = pos.x / (pos.z)
	pos += origin
	return pos;
