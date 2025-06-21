extends Node2D

var is_moving = false

var t_raw = 0.0
@onready var fall_time:float = get_parent().FALL_TIME

@onready var a:Vector2 = -position
@onready var b:Vector2 = position

func _process(delta):
	if not is_moving:
		return

	t_raw += delta
	var t = t_raw / fall_time
	t = t*t
	position = a * t + b


# Callback when bullet hit bag
func _on_area_2d_body_entered(_body):
	is_moving = true

func _on_fall_timer_timeout():
	queue_free()
