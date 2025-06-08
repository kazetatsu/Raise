extends Node2D

signal standby_start_mg
signal standby_finish_mg

var rhythm:Node

var kami:Node2D
var partition:Sprite2D

var hide_ang:float

var check_beat:int

enum State {
	SSWEEP, # start  sweep
	FSWEEP, # finish sweep
	NONE
}

var state = State.NONE

func _on_bg_want_start_mg():
	kami.scale = Vector2(-1.0, 1.0) # flip x-axis
	check_beat = rhythm.beat + 1
	state = State.SSWEEP
	show()
	

func _on_praiser_just_left():
	kami.scale = Vector2(1.0, 1.0)
	check_beat = rhythm.beat + 1
	state = State.FSWEEP
	show()


func _ready():
	rhythm = get_node("/root/BigGame/Rhythm")
	kami = $Kami
	partition = $"../Partition"
	hide_ang = kami.rotation
	hide()


func _process(_delta):
	if state == State.NONE:
		return

	if rhythm.beat > check_beat:
		if state == State.SSWEEP:
			standby_start_mg.emit()
		else:
			standby_finish_mg.emit()
		hide()
		state = State.NONE
	else:
		# t in [-1,1]
		var t = rhythm.t
		t += float(rhythm.beat - check_beat)

		var ang = t * hide_ang
		if state == State.SSWEEP:
			kami.rotation = ang
			partition.ang = ang
		else:
			kami.rotation = -ang
			partition.ang = -ang

			