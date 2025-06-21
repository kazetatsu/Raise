extends Node2D

const gravity = 1200.0
var is_falling = false
var t = 0.0
@onready var fall_time:float = get_parent().FALL_TIME
var x_a:PackedFloat32Array
var y_a:PackedFloat32Array

func _process(delta):
	if not is_falling:
		return

	t += delta
	var x = x_a[1] * t + x_a[0]
	var y = y_a[2] * t * t + y_a[1] * t + y_a[0]
	position = Vector2(x, y)


# Callback when bullet hit bag
func _on_area_2d_body_entered(_body):
	$Area2D.queue_free()
	var a2 = 0.5 * gravity
	var a0 = position.y
	var a1 = -a0 / fall_time - a2 * fall_time
	y_a = PackedFloat32Array([a0, a1, a2])

	a0 = position.x
	a1 = -a0 / fall_time
	x_a = PackedFloat32Array([a0, a1])

	is_falling = true


func _on_fall_timer_timeout():
	queue_free()
