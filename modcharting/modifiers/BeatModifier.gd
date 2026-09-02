class_name BeatModifier
extends BaseModifier
func name():
	return 'beat'
func doesUsePos():
	return true
var beatFactors:Array[Array] = [[0,0,0],[0,0,0]]
func scale(value:float, clow:float, chigh:float, nlow:float, nhigh:float):
	return (value - clow) * (nhigh - nlow) / (chigh - clow) + nlow;
func doesUpdate():
	return true
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

func update(delta:float, beat:float):
	for player in range(len(beatFactors)):
		updateBeat(0, beat, player, 0, 0);
		updateBeat(1, beat, player, 0, 0);
		updateBeat(2, beat, player, 0, 0);

func getPos(diff:float, tDiff:float, beat:float, data:int, player:int, obj:Node2D, field:NoteField, pos:Vector3):
	pos.x += getValue(player) * (beatFactors[player][0] * sin(((diff) / 30.) + PI * 0.5));
	return pos;
