extends Node2D

var SPEED = 30
var FRICTION = 15
var SHIFT_DIRECTION = Vector2.ZERO

onready var label = $Label

func _ready():
	SHIFT_DIRECTION = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	
func set_damage(damage):
	label.text = str(int(damage))
	
func _process(delta):
	global_position += SPEED * SHIFT_DIRECTION * delta
	SPEED = max(SPEED - FRICTION * delta, 0)
