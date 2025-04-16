extends "res://mini_game.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event.is_action_released("W"):
		finish.emit()
