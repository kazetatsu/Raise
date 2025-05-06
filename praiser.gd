extends Node2D

signal just_left

var rhythm:Node

enum State {
	STANDBY,
	COME,
	WAIT,
	MISS,
	FINISH,
	LEAVE,
	NONE
}

var state = State.NONE
var t:float
var check_beat:int
var miss_time:float
@export var leave_pos:Vector2
@export var come_pos:Vector2
@export var top_pos:Vector2
@export var bottom_pos:Vector2

const r = 0.25

var kami:Node
var kami_head:Node

func _ready():
	rhythm = get_node("/root/BigGame/Rhythm")
	kami = $Kami
	kami_head = $Kami/Head
	hide()
	state = State.NONE


func _on_bg_want_finish_mg():
	t = rhythm.t
	check_beat = rhythm.beat + 2
	if t >= 0.5:
		pass
		#sound = 
	else:
		pass
		#sound = 
	#face = 
	kami_head.position = top_pos
	state = State.FINISH


func _on_mg_miss():
	t = miss_time
	#face = 
	kami_head.position = top_pos
	state = State.MISS


func _on_sweeper_standby_start_mg():
	check_beat = rhythm.beat
	#face = 
	kami.position = leave_pos
	kami_head.position = top_pos
	show()
	state = State.COME


func _process(delta):
	match state:
		State.COME:
			if rhythm.beat <= check_beat:
				t = rhythm.t
				kami.position = t * come_pos + (1.0 - t) * leave_pos
			else: # rhythm.beat > check_beat
				kami.position = come_pos
				state = State.WAIT
		State.WAIT:
			t = rhythm.t
			if t < r:
				t /= r
				kami_head.position = t * bottom_pos + (1.0 - t) * top_pos
			else:
				t = (t-r) / (1.0-r)
				kami_head.position = t * top_pos + (1.0 - t) * bottom_pos
		State.MISS:
			t -= delta
			if t < 0.0:
				state = State.WAIT
		State.FINISH:
			if rhythm.beat > check_beat:
				check_beat = rhythm.beat
				state = State.LEAVE
		State.LEAVE:
			if rhythm.beat <= check_beat:
				t = rhythm.t
				kami.position = t * leave_pos + (1.0 - t) * come_pos
			else: # rhythm.beat > check_beat
				hide()
				state = State.NONE
				just_left.emit()
		_: # STANDBY, NONE
			pass
