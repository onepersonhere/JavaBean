extends Area2D

export var pos_x: int;
export var pos_y: int;
export var entering_area: String;
export var entering_area_name: String;
export var exit_area_name: String;

func _on_Entrance_body_entered(body):
	if not body is KinematicBody2D:
		return
	if body.name == "Player":
		var root = get_node("/root")
		get_node("/root/" + exit_area_name).queue_free()
		call_deferred("add_player")
		

func add_player():
	var root = get_node("/root")
	var player = load("res://Characters/MainCharacter.tscn").instance()
	root.add_child(load(entering_area).instance())
	get_node("/root/" + entering_area_name).add_child(player)
	player.position.x = pos_x
	player.position.y = pos_y
