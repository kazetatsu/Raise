extends "res://mini_game.gd"

var is_playing = false

func _on_start():
	is_playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_playing and Input.is_action_pressed("W"):
		finish.emit()
		is_playing = false
