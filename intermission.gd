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

var mg_code:String
var creature_name:String

var kami:Node2D
@export var kami_come_pos:Vector2
@export var kami_leave_pos:Vector2

var kami_before:Node2D
var kami_after:Node2D

var seriph:Node2D
var seriph_label:Label
@export var seriph_come_pos:Vector2
@export var seriph_leave_pos:Vector2

var anim:AnimationPlayer
var tween:Tween

func _ready():
	rhythm = get_node("/root/BigGame/Rhythm")

	kami = $Kami
	kami_before = $Kami/Before
	kami_after  = $Kami/After

	seriph = $Seriph
	seriph_label = $Seriph/Label

	anim = $AnimationPlayer

	$Smoke/Part1.hide()
	$Smoke/Part2.hide()
	$Smoke/Part3.hide()
	$Smoke/Part4.hide()

	kami.position = kami_come_pos
	kami_before.show()
	kami_after.hide()
	seriph.position = seriph_come_pos
	seriph_label.hide()


func into_before():
	kami.position = kami_come_pos
	kami_before.show()
	seriph.position = seriph_come_pos
	seriph_label.text = "Your next life is..."
	seriph_label.show()
	check_beat = rhythm.beat + 1
	state = State.BEFORE


func _process(_delta):
	# COME -> BEFORE
	if state == State.COME and rhythm.beat > check_beat:
		into_before()

	# BEFORE -> AFTER
	if state == State.BEFORE and rhythm.beat > check_beat:
		kami_before.hide()
		kami_after.show()

		seriph_label.text = creature_name + " !"
		anim.play("smoke")

		check_beat = rhythm.beat + after_beat
		state = State.AFTER

	# AFTER -> LEAVE
	if state == State.AFTER and rhythm.beat > check_beat:
		seriph_label.hide()

		if tween: tween.kill()
		tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_IN)
		tween.set_parallel()
		tween.tween_property(kami, "position", kami_leave_pos, rhythm.period)
		tween.tween_property(seriph, "position", seriph_leave_pos, rhythm.period)

		check_beat = rhythm.beat
		state = State.LEAVE

	# LEAVE -> NONE
	if state == State.LEAVE and rhythm.beat > check_beat:
		seriph.hide()
		kami_after.hide()
		finish.emit()
		state = State.NONE


func change_img():
	var img = Image.load_from_file("res://mg_%s/predator.png" % mg_code)
	$Creature.texture = ImageTexture.create_from_image(img)


func _on_bg_decided_next_mg(node_mg:Node2D):
	after_beat = node_mg.after_beat()
	mg_code = node_mg.mg_code()
	creature_name = node_mg.creature_name()


func _on_bg_start_im():
	kami_before.show()
	seriph.show()

	if tween: tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel()
	tween.tween_property(kami, "position", kami_come_pos, rhythm.period)
	tween.tween_property(seriph, "position", seriph_come_pos, rhythm.period)

	check_beat = rhythm.beat
	state = State.COME


func _on_sweeper_standby_start_mg():
	hide()
	var img = Image.load_from_file("res://mg_%s/pray.png" % mg_code)
	$Creature.texture = ImageTexture.create_from_image(img)


func _on_praiser_just_left():
	self.show()


func _on_intro_finish():
	# Start intermission from the middle
	# NONE -> BEFORE
	into_before()
	show()
