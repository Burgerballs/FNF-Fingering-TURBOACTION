extends SongBehaviour



func _pre_ready():
	game.opponentField.skin = 'funkinpixel'
	for it in range(8):
		var sec = it * 16
		for i in [0, 4, 8, 11, 14]:
			queueFunction(i + sec, func():
				game.opponentField.skin = 'funkin'
			)
			queueFunction(i+1 + sec, func():
				game.opponentField.skin = 'funkinpixel'
			)
	for it in range(16):
		var sec = it * 16 + 128
		for i in [0, 8]:
			queueFunction(i + sec, func():
				game.opponentField.skin = 'funkin'
				game.playerField.skin = 'funkinpixel'
			)
			queueFunction(i+4 + sec, func():
				game.opponentField.skin = 'funkinpixel'
				game.playerField.skin = 'funkin'
			)
	
