extends Node2D

signal start_mg

var node_mg:Node2D

var mg_code:String
@onready var message:Label = $Message
@onready var uis:Control = $UIs
@onready var sb:Button = $UIs/StartButton
@onready var tb:Button = $UIs/TerminateButton
@onready var ib:Button = $UIs/InstantiateButton

func delete_mg():
	node_mg.finish.disconnect(_on_mg_finish)
	start_mg.disconnect(node_mg._on_bg_start_mg)
	node_mg.queue_free()
	node_mg = null


func _ready():
	uis.show()
	ib.show()
	sb.hide()
	tb.hide()
	message.text = "This is dummy of big game."


func _on_line_edit_text_changed(new_text:String):
	mg_code = new_text


func _on_instantiate_button_pressed():
	if node_mg: delete_mg()

	var path = "res://mg_%s/mini_game.tscn" % mg_code
	if ResourceLoader.exists(path):
		node_mg = load(path).instantiate()
		add_child(node_mg)
		node_mg.finish.connect(_on_mg_finish)
		start_mg.connect(node_mg._on_bg_start_mg)

		sb.show()
		message.text = "instantiated"
	else:
		message.text = "not exist"


func _on_start_button_pressed():
	uis.hide()
	start_mg.emit()
	sb.hide()
	ib.hide()
	message.text = "mg started"


func _on_terminate_button_pressed():
	delete_mg()
	tb.hide()
	ib.show()
	message.text = "terminated"


func _on_mg_finish():
	tb.show()
	uis.show()
	message.text = "mg finished"


func _on_quit_button_prssed():
	get_tree().quit()
