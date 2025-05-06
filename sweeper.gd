extends Node2D

signal standby_start_mg
signal standby_finish_mg

var rhythm:Node

var kami:Node

var hide_ang:float

var check_beat:int

enum State {
	SSWEEP, # start  sweep
	FSWEEP, # finish sweep
	NONE
}

var state = State.NONE

func _on_bg_want_start_mg():
	check_beat = rhythm.beat + 1
	show()
	state = State.SSWEEP
	

func _on_praiser_just_left():
	check_beat = rhythm.beat + 1
	show()
	state = State.FSWEEP


func _ready():
	rhythm = get_node("/root/BigGame/Rhythm")
	kami = $Kami
	hide_ang = kami.rotation
	hide()


func _process(_delta):
	if state != State.NONE:
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
			else:
				kami.rotation = -ang

			