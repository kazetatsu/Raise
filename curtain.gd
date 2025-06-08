extends Node2D

var alpha = 1.0

const NUM = 144 # 9*16
const PART_SIZE = 64.0
var parts:Array[Sprite2D]
var thresholds:PackedFloat32Array

func _ready():
	var scene_part = preload("res://curtain_part.tscn")
	parts = []
	var thresholds_arr = []
	for i in NUM:
		var c = i % 16
		var r = i / 16
		var node_part = scene_part.instantiate()
		node_part.name = "Part%02x" % i
		add_child(node_part)
		node_part.position.x = PART_SIZE * c
		node_part.position.y = PART_SIZE * r
		parts.append(node_part)
		thresholds_arr.append(randf())
	thresholds = PackedFloat32Array(thresholds_arr)

	var rhythm = get_node("../../Rhythm")
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "alpha", 0.0, 2 * rhythm.period)
	tween.tween_callback(tween.kill)


func _process(_delta):
	for i in NUM:
		if thresholds[i] >= alpha:
			parts[i].hide()
