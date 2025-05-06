extends Node2D

signal want_start_mg # mg = mini game
signal want_finish_mg
signal mg_miss
signal start_mg
signal start_im(node_mg:Node2D) # im = intermission

var rest_mg_num:int
var node_mg:Node

func instantiate_mg() -> int:
	var mg_index = randi_range(0,0)
	# node_mg = load("res://mg%03d/mini_game.tscn" % mg_index).instantiate()
	# add_child(node_mg)
	node_mg.finish.connect(_on_mg_finish)
	start_mg.connect(node_mg._on_start)
	return mg_index


func disconnect_mg():
	node_mg.finish.disconnect(_on_mg_finish)
	start_mg.disconnect(node_mg._on_start)


func _ready():
	print("start big game")
	rest_mg_num = 4
	node_mg = $Dummy
	var mg_index = instantiate_mg()
	print("rest: 4")
	want_start_mg.emit()


func _on_mg_finish():
	disconnect_mg()
	want_finish_mg.emit()


func _on_kami_standby_start_mg():
	start_mg.emit()
	print("start mini game")


func _on_im_finish():
	want_start_mg.emit()
	print("intermission finished")


func _on_kami_standby_finish_mg():
	print("finish mini game")
	rest_mg_num -= 1
	if rest_mg_num <=0:
		print("finish big game")
	else:
		# remove_child(node_mg)
		var mg_index = instantiate_mg()
		start_im.emit(node_mg)
		print("rest: %d" % rest_mg_num)
	


func _on_praiser_just_left():
	pass # Replace with function body.
