extends "res://mini_game.gd"

func mg_code(): return "af"
func after_beat(): return 2
func creature_name(): return "ARCHER FISH"

signal shoot(ang:float)

const FALL_TIME = 0.5
const LEACH_TIME = 0.35

var ang:float
@export var ang_speed:float
@export var ang_min:float
@export var ang_max:float

var t:float
@export var freeze_time:float
#var hit_timer:Node

enum State {
	AIM,
	ATTACK,
	NONE
}
var state = State.NONE

var aim_line:Node

func _ready():
	aim_line = $AimLine

	ang = PI / 4.0
	aim_line.rotation = -ang


func _process(delta):
	match state:
		State.AIM:
			ang += ang_speed * Input.get_axis("move_down", "move_up") * delta
			ang = max(ang, ang_min)
			ang = min(ang, ang_max)
			aim_line.rotation = -ang

			if Input.is_action_just_pressed("attack"):
				aim_line.hide()
				shoot.emit(ang)
				t = freeze_time
				state = State.ATTACK
		State.ATTACK:
			t -= delta
			if t < 0.0:
				aim_line.show()
				state = State.AIM
		_:
			pass


func _on_bg_start_mg():
	state = State.AIM


# Callback when bullet hit bag
func _on_area_2d_body_entered(_body):
	state = State.NONE
	$FallTimer.start(LEACH_TIME)


func _on_fall_timer_timeout():
	finish.emit()
	$FishEatingBag.show()
