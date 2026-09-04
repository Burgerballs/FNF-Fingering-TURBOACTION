extends FunctionEvent

var gameZoom = 0.015
var hudZoom = 0.03

func action(game:Game):
	game.camGame.zoom += gameZoom
	game.hudContainer.scale += hudZoom
