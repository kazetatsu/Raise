extends Node2D

signal finish

enum State {
	COME,
	BEFORE,
	AFTER,
	LEAVE,
	NONE
}
	
var state = State.NONE

const r = 0.3
var rhythm:Node
var check_beat:int
var after_beat:int # Length of beats in State.AFTER
var creature_name:String

var kami:Node
@export var come_pos:Vector2
@export var leave_pos:Vector2
var kami_head:Node
@export var top_pos:Vector2
@export var bottom_pos:Vector2

func _ready():
	rhythm = get_node("/root/BigGame/Rhythm")
	kami = $Kami
	kami_head = $Kami/Head
	kami.hide()


func _process(_delta):
	match state:
		State.COME:
			if rhythm.beat <= check_beat:
				var t = rhythm.t
				t = - t*t + 2.0*t
				kami.position = t * come_pos + (1.0 - t) * leave_pos
			else:
				kami.position = come_pos
				check_beat = rhythm.beat + 1
				state = State.BEFORE
		State.BEFORE:
			if rhythm.beat <= check_beat:
				var t = rhythm.t
				if t < r:
					t /= r
					kami_head.position = t * bottom_pos + (1.0 - t) * top_pos
				else:
					t = (t - r) / (1.0 - r)
					kami_head.position = t * top_pos + (1.0 - t) * bottom_pos
			else:
				check_beat = rhythm.beat + after_beat
				kami_head.position = top_pos
				state = State.AFTER
		State.AFTER:
			if rhythm.beat > check_beat:
				check_beat = rhythm.beat
				state = State.LEAVE
		State.LEAVE:
			if rhythm.beat <= check_beat:
				var t = rhythm.t
				kami.position = t * leave_pos + (1.0 - t) * come_pos
			else:
				kami.position = leave_pos
				kami.hide()
				finish.emit()
				state = State.NONE
		_:
			pass


func _on_bg_start_im(node_mg:Node2D):
	after_beat = node_mg.after_beat()
	creature_name = node_mg.creature_name()
	check_beat = rhythm.beat

	kami.position = leave_pos
	kami_head.position = top_pos
	kami.show()

	state = State.COME
