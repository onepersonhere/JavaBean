extends Area2D

func _on_Entrance_body_entered(body):
	if body.name == "Player":
		var player = load("res://Characters/MainCharacter.tscn").instance()
		var root = get_node("/root")
		get_node("/root/World").queue_free()
		root.add_child(load("res://World/House/House.tscn").instance())
		get_node("/root/House").add_child(player)
