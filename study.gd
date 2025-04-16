extends Node2D

var scene_mg:Resource
var node_mg:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_mg = preload("res://study_mg.tscn")
	node_mg = scene_mg.instantiate()
	add_child(node_mg)
	node_mg.finish.connect(_on_study_mg_finish)
	print("start")


func _on_study_mg_finish():
	remove_child(node_mg)
	print("minigame finished")
