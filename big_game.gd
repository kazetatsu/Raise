extends Node2D

signal want_start_mg # mg = mini game
signal want_finish_mg
signal mg_miss
signal start_mg
signal start_im() # im = intermission
signal decided_next_mg(node_mg:Node2D)

var rest_mg_num:int
var node_mg:Node

var mg_index2code = ["00", "af", "ct"]

func instantiate_mg():
	var mg_index = randi_range(0,0)
	var mg_code = mg_index2code[mg_index]
	# node_mg = load("res://mg_%s/mini_game.tscn" % mg_code).instantiate()
	# add_child(node_mg)
	node_mg.finish.connect(_on_mg_finish)
	start_mg.connect(node_mg._on_bg_start_mg)
	decided_next_mg.emit(node_mg)


func disconnect_mg():
	node_mg.finish.disconnect(_on_mg_finish)
	start_mg.disconnect(node_mg._on_bg_start_mg)


func _ready():
	print("start big game")
	rest_mg_num = 4
	node_mg = $MiniGameStab
	instantiate_mg()
	print("rest: 4")


func _on_mg_finish():
	disconnect_mg()
	want_finish_mg.emit()


func _on_kami_standby_start_mg():
	start_mg.emit()
	print("start mini game")


func _on_intermission_finish():
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
