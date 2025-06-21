extends Sprite2D

#var is_flying = false
#var t = 0.0
const time_fly = 1.0
const speed = 600.0

@onready var scene_body = preload("res://mg_af/bullet_body.tscn")
var body:RigidBody2D

'''
func _ready():
	body = $Body


func _process(delta):
	if is_flying:
		t += delta
		if t < time_fly:
			body.position.x += delta * speed
		else:
			hide()
			is_flying = false


func start():
	t = 0.0
	body.position.x = 0.0
	show()
	is_flying = true
'''

func _on_mg_fired(ang:float):
	rotation = -ang

	body = scene_body.instantiate()
	add_child(body)
	#body.global_rotation = -ang
	var impulse = Vector2.from_angle(-ang)
	impulse *= body.mass
	impulse *= speed
	body.apply_central_impulse(impulse)

	$HideTimer.start(time_fly)
	show()


func _on_hide_timer_timeout():
	if body:
		body.queue_free()
		body = null
	hide()
	
