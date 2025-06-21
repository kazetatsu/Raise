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
#var bag:Node
#var bullet:Node

#var should_check_hit = false

func _ready():
	aim_line = $AimLine
	#bag = $Bag
	#bullet = $Bullet
	#hit_timer = $HitTimer

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
				"""
				bullet.rotation = -ang
				bullet.start()

				should_check_hit = true
				"""

				t = freeze_time
				state = State.ATTACK
		State.ATTACK:
			t -= delta
			if t < 0.0:
				aim_line.show()
				state = State.AIM
		_:
			pass


"""
func _physics_process(_delta):
	if should_check_hit:
		var start_pos = bullet.position
		var end_pos = bullet.position + 1000.0 * Vector2.from_angle(ang)

		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
		var result = space_state.intersect_ray(query)
		if result.has("position"):
			var dist = (result["position"] - start_pos).length()
			var t_fly = (dist / bullet.speed)
			hit_timer.start(t_fly)

		should_check_hit = false
"""

func _on_bg_start_mg():
	state = State.AIM


# Callback when bullet hit bag
func _on_area_2d_body_entered(_body):
	state = State.NONE
	$FallTimer.start(LEACH_TIME)


func _on_fall_timer_timeout():
	finish.emit()
	$FishEatingBag.show()
