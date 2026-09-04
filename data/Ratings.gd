class_name Ratings
extends Node

static var ratings = [
	{
		"ms": 22.5,
		"name": "epic",
		"nameAbb": 'Ep',
		"doCB": false,
		"power": 1,
		"color": Color(0.600, 0.400, 1.0, 1.0),
		"hittable": true,
		"health": 1.15,
		"score": 500
	},
	{
		"ms": 45,
		"name": "sick",
		"nameAbb": 'Si',
		"doCB": false,
		"power": 0.9,
		"color": Color(0.0, 0.783, 1.0, 1.0),
		"hittable": true,
		"health": 0.75,
		"score": 350
	},
	{
		"ms": 90,
		"name": "good",
		"nameAbb": 'Go',
		"doCB": false,
		"power": 0.1,
		"color": Color(0.225, 0.997, 0.0, 1.0),
		"hittable": true,
		"health": 0.25,
		"score": 100
	},
	{
		"ms": 135,
		"name": "bad",
		"nameAbb": 'Ba',
		"doCB": true,
		"power": -1,
		"color": Color(1.0, 1.0, 1.0, 1.0),
		"hittable": true,
		"health": 0,
		"score": 0
	},
	{
		"ms": 180,
		"name": "shit",
		"nameAbb": 'Sh',
		"doCB": true,
		"power": -5,
		"color": Color(0.46, 0.46, 0.46, 1.0),
		"hittable": true,
		"health": -0.25,
		"score": -150
	},
	{
		"ms": 180,
		"name": "miss",
		"nameAbb": 'Ms',
		"doCB": true,
		"power": -5,
		"color": Color(1.0, 0.0, 0.0, 1.0),
		"hittable": true,
		"health": -5
	},
	{
		"ms": 180,
		"name": "cb",
		"nameAbb": 'Cb',
		"doCB": true,
		"power": -1,
		"color": Color(0.69, 0.0, 0.0, 1.0),
		"hittable": true
	}
]
static var max_ms = 180
static var hittables = [
	ratings[0],
	ratings[1],
	ratings[2],
	ratings[3],
	ratings[4],
]
var statCount = {
	"epic": 0,
	"sick": 0,
	"good": 0,
	"bad": 0,
	"shit": 0,
	"miss": 0,
	"cb": 0,
}
static var gradeSet = [
	['SS+++', 1],
	["SS++", 0.99],
	["SS+", 0.98],
	["SS", 0.96],
	["S+", 0.94],
	["S", 0.92],
	["S-", 0.89],
	["A+", 0.86],
	["A", 0.83],
	["A-", 0.8],
	["B+", 0.76],
	["B", 0.72],
	["B-", 0.68],
	["C+", 0.64],
	["C", 0.6],
	["C-", 0.5],
	["D+", 0.5],
	["D", 0.45],
	["D-", 0.01],
	["F", -1],
	["ULTRA F", -200]
]
static var instance:Ratings
var healthMax = 2
var healthMin = 0
var health = 1:
	set(v):
		if v > healthMax:
			v = 2
		health = v
		return v
var combo = 0
var score:int = 0
var grade:String:
	get:
		if (totalPlayed >= 1):
			for grade in gradeSet:
				if (totalPlayed/totalNotes) >= grade[1]:
					return grade[0];
		return '?';
var flag:String:
	get:
		if statCount['cb'] > 10:
			return 'CLEAR'
		if statCount['cb'] > 0 and statCount['cb'] < 10:
			return 'SDCB'
		if statCount['good'] > 10:
			return 'GFC'
		if statCount['good'] > 0:
			return 'SDG'
		if statCount['sick'] > 10:
			return 'SFC'
		if statCount['sick'] > 0:
			return 'SDS'
		if statCount['epic'] > 0:
			return 'EFC'
		return '???'
func _init() -> void:
	instance = self

func handleMiss():
	totalNotes+=2.0
	combo = 0
	health += ratings[5]['health'] * 0.02
	statCount['miss'] += 1
	statCount['cb'] += 1
	score -= 500
func react(rating, diff):
	statCount[rating['name']] += 1
	totalNotes+=1.0
	totalPlayed+=rating['power']
	health += rating['health'] * 0.02
	score += rating['score']
	if rating['doCB']:
		combo = 0
		statCount['cb'] += 1
	else:
		combo+=1

var totalNotes:float = 0.0
var totalPlayed:float = 0.0
func judgeNote(diff):
	var rating = ratings[4]
	for r in hittables:
		if (r['ms'] >= diff):
			rating = r
			break
	react(rating, diff)
	
	return rating['name']
