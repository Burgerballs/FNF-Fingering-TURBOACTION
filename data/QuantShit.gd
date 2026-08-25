class_name QuantShit
extends Node
static var quants:Array[int] = [
	4,
	8,
	12,
	16,
	20,
	24,
	32,
	48,
	64,
	96,
	192
]
static var quant_colors:Array[Color] = [
	Color("f34d00ff"), # 4
	Color("408dffff"), # 8
	Color("ce24ffff"), # 12
	Color("4cff00ff"), # 16
	Color("40c2cbff"), # 20
	Color("ff00d4ff"), # 24
	Color("f2e63dff"), # 32
	Color("ff5a93ff"), # 48
	Color("00c6ceff"), # 64
	Color("4d8c6eff"), # 96
	Color("ffffffff") # 192
]
static func getQuantColor(timeAt:float): 
	return (quant_colors[quants.find(getQuantFromTime(timeAt))])
static func getQuantFromTime(timeAt:float):
	var beat:float = timeAt / (Conductor.crotchet*1000.);


	var row:int = roundi(beat * 48);
	for quant in quants:
		if (row % (192 / quant) == 0):
			return quant;
	return quants[quants.size() - 1];
