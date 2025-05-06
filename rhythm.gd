extends Node

var t = 0.0
var s = 0.0
var beat = 0
var speed:float
@export var bpm:float
var period:float

func _ready():
	period = 60.0 / bpm
	speed = bpm / 60.0

func _process(delta):
	t += speed * delta
	if t >= 1.0:
		beat += 1
		t -= 1.0
		print(t)