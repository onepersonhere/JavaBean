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
		var exit_area = get_node("/root/" + exit_area_name)
		#save(exit_area)
		exit_area.queue_free()
		call_deferred("add_player")
		

func add_player():
	var root = get_node("/root")
	var player = load("res://Characters/MainCharacter.tscn").instance()
	root.add_child(load(entering_area).instance())
	get_node("/root/" + entering_area_name).add_child(player)
	player.set_position(Vector2(pos_x, pos_y))
	
	player.scale = Vector2(1, 1)
	player.find_node("Camera2D").zoom = Vector2(0.45,0.45)

# TODO: Save when going in
func save(area):
	Save.save();

func scene_changer(pos_x, pos_y, entering_area, entering_area_name, exit_area_name):
	print_debug("called")
	self.pos_x = pos_x;
	self.pos_y = pos_y;
	self.entering_area = entering_area;
	self.entering_area_name = entering_area_name;
	self.exit_area_name = exit_area_name;
	var player = get_tree().get_nodes_in_group("Player")[0];
	
	_on_Entrance_body_entered(player);
