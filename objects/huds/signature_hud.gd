extends Node2D
@onready var accuracyTxt = $TextContainer/AccuracyText
@onready var scTxt2 = $TextContainer/ScoreText2
@onready var healthBar:ProgressBar = $HealthBarBG/HealthBar
@onready var healthBarCont = $HealthBarBG
var stats:Ratings = Ratings.instance;
@onready var judgeCounters = $JudgeCounter
@onready var template = $Cunter
var iconP1:BaseIcon
var iconP2:BaseIcon
@onready var scoreTxt:Label = $HealthBarBG/ScoreText
func setupIcons(game:Game):
	if game.bf.icon != null:
		iconP1 = game.bf.icon
		iconP1.isPlayer = true
		game.bf.remove_child(iconP1)
		add_child(iconP1)
		iconP1.set_icon()
	if game.dad.icon:
		iconP2 = game.dad.icon
		game.dad.remove_child(iconP2)
		add_child(iconP2)
		iconP2.set_icon()
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
	Conductor.beat_hit.connect(beat_hit)
		
func beat_hit(b):
	iconP1.scale = Vector2(1.2,1.2)
	iconP2.scale = Vector2(1.2,1.2)
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
	scoreTxt.text = 'Score: ' + str(stats.score)
	accuracyTxt.text = (str(snappedf((stats.totalPlayed / stats.totalNotes) * 100, 0.001)) if not is_nan(perc) else '???.?')+'%'
	scTxt2.text = 'Combo Breaks: ' + str(stats.statCount['cb']) + '\nRank: [' + stats.flag + ' | ' + stats.grade + ']'
	
	iconP1.val = healthBar.ratio
	iconP2.val = 1 - healthBar.ratio
	
	iconP1.position = Vector2(healthBar.global_position.x + remap(1 - healthBar.ratio, 0, 1, 0, healthBar.size.x) + 62, 
		healthBar.global_position.y + (healthBar.size.y/2.))
	iconP2.position = Vector2(healthBar.global_position.x + remap(1 - healthBar.ratio, 0, 1, 0, healthBar.size.x) - 62, 
		healthBar.global_position.y + (healthBar.size.y/2.))
	iconP1.scale = lerp(iconP1.scale, Vector2.ONE, delta * 12)
	iconP2.scale = lerp(iconP2.scale, Vector2.ONE, delta * 12)
