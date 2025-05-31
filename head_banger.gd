extends Node2D

const r = 0.25
const rinv = 1.0 / r
const rmir = 1.0 / (1.0 - r)

var head:Sprite2D
var rhythm:Node

@export var top_pos:Vector2
@export var bottom_pos:Vector2

func _ready():
	head = $Head
	rhythm = get_node("/root/BigGame/Rhythm")


func _process(_delta):
	if not visible:
		return

	var t = rhythm.t
	if t < r:
		t = (r - t) * rinv
	else:
		t = (t - r) * rmir
	head.position = t * top_pos + (1.0 - t) * bottom_pos
