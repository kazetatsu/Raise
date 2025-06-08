extends Sprite2D

var ang:float
var background:Sprite2D
const BG_SCALE = 1024.0 / 1920.0

func _ready():
	background = $BackGround
	ang = rotation


func _process(_delta):
	if not visible:
		return

	rotation = ang

	background.global_position = Vector2.ZERO
	background.global_rotation = 0.0
	background.global_scale.x = BG_SCALE
	background.global_scale.y = BG_SCALE


func _on_praiser_just_left():
	show()


func _on_sweeper_standby_start_mg():
	hide()