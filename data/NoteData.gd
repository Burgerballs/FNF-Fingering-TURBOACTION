extends Node
class_name NoteData
var time:float = 0 # Desired time
var column:int = 0 # Desired direction
var length:float = 0
var type:String = ''
func _init(timea, columna, lengtha, typea = ''):
	self.time = timea
	self.column = columna
	self.type = typea
	self.length = lengtha
