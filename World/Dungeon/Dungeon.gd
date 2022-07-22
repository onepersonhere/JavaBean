extends Node2D
var fog;

func _ready():
	var UI = get_node("/root/UI")
	fog = load("res://Shaders/fog.tscn").instance()
	UI.add_child(fog);
	UI.move_child(fog, 0);

func _exit_tree():
	fog.queue_free()

