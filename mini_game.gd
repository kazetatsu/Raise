extends Node2D

signal finish
signal miss

func after_beat() -> int:
	return 2


func creature_name() -> String:
	return "super"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
