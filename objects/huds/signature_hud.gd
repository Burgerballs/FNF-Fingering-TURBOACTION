extends Node2D
@onready var accuracyTxt = $TextContainer/AccuracyText
@onready var scTxt2 = $TextContainer/ScoreText2
@onready var healthBar = $HealthBarBG/HealthBar
@onready var healthBarCont = $HealthBarBG
var stats:Ratings = Ratings.instance;
@onready var judgeCounters = $JudgeCounter
@onready var template = $Cunter
func _ready() -> void:
	for i in stats.ratings:
		if not i['hittable']:
			break
		var j:Panel = template.duplicate()
		j.self_modulate = i['color']
		judgeCounters.add_child(j)
		j.get_child(0).text = i['nameAbb']
		if Main.downscroll:
			healthBarCont.position.y = 80.0
			$TextContainer.alignment = 0
		else:
			healthBarCont.position.y = 720 - 103.0
		
		
func handleRating():
	var it = 0
	for i in stats.ratings:
		if not i['hittable']:
			break
		var j = judgeCounters.get_child(it)
		if (stats.statCount[i['name']] != 0):
			if (j.get_child(0).text != str(stats.statCount[i['name']])):
				j.get_child(0).get_child(0).seek(0)
				j.get_child(0).get_child(0).play('bunce')
			j.get_child(0).text = str(stats.statCount[i['name']])
		it+=1
	
func _process(delta: float) -> void:
	var perc = snappedf((stats.totalPlayed / stats.totalNotes) * 100, 0.001)
	healthBar.value = stats.health
	accuracyTxt.text = (str(snappedf((stats.totalPlayed / stats.totalNotes) * 100, 0.001)) if not is_nan(perc) else '???.?')+'%'
	scTxt2.text = 'Combo Breaks: ' + str(stats.statCount['cb']) + '\nRank: [' + stats.flag + ' | ' + stats.grade + ']'
	
