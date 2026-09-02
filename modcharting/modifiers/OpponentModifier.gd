class_name OpponentModifier
extends BaseModifier
func name():
	return 'opponentSwap'

func getPos(diff:float, tDiff:float, beat:float, data:int, player:int, obj:Node2D, field:NoteField, pos:Vector3):
		var distX = 1280 / modMgr.playerAmount;

		pos.x += distX * sign((player + 1) * 2 - 3) * getValue(player);
		return pos;
