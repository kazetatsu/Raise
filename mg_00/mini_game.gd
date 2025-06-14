extends "res://mini_game.gd"

var is_playing = false

func _process(_delta):
	if not is_playing:
		return

	if Input.is_action_just_pressed("attack"):
		$Message.text = "finished"
		finish.emit()
		is_playing = false


	if Input.is_action_just_pressed("touch"):
		$Message.text = "missed"
		miss.emit()
		$Timer.start(0.25)


func _on_bg_start_mg():
	is_playing = true
	$Message.text = "now playing"


func _on_timer_timeout():
	if is_playing:
		$Message.text = "now playing"