extends Area2D

export var pos_x: int;
export var pos_y: int;
export var house_name: String;
export var exit_name: String

func _on_Exit_body_entered(body):
	if body.name == "Player":
		var player = load("res://Characters/MainCharacter.tscn").instance()
		var root = get_node("/root")
		
		get_node("/root/" + house_name).queue_free()
		root.add_child(load("res://World/House/House.tscn").instance())
		get_node("/root/House").add_child(player)
		
		player.position.x = pos_x
		player.position.y = pos_y
