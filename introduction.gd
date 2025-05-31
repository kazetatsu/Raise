extends Node2D

signal finish()

enum State {
	RISE,
	TALK,
}
var state = State.RISE

var curtain:Sprite2D
var seriph_label:Label
var tween:Tween
var rhythm:Node

var node_mg:Node

func _ready():
	seriph_label = $Label
	rhythm = get_node("/root/BigGame/Rhythm")
	seriph_label.hide()


func _process(delta:float):
	if state == State.RISE and rhythm.beat > 4:
		seriph_label.show()
		state = State.TALK

	if state == State.TALK and rhythm.beat > 7:
		finish.emit()
		queue_free()
