extends CanvasLayer

onready var player_pin = $Control/ViewportContainer/Viewport/Pins/PlayerLocation
onready var camera = $Control/ViewportContainer/Viewport/Camera2D
onready var viewport = $Control/ViewportContainer/Viewport

var offset_x = -1100
var offset_y = 100
var zoom = 1

func _ready():
	set_offsets()
	set_map()
	set_player_pin()
	set_quest_pins()

func set_map():
	var _map = get_map_background()
	_map.set_position(Vector2(offset_x, offset_y))
	viewport.add_child(_map)
	viewport.move_child(_map, 0)
	camera.zoom = zoom

func set_offsets():
	var map_name = get_tree().get_nodes_in_group("map")[0].name
	match map_name:
		# TODO: Fine Tuning
		"House":
			offset_x = 0
			offset_y = 0
			zoom = Vector2(1, 1)
		"HouseSecondFloor":
			offset_x = -0
			offset_y = 0
			zoom = Vector2(1, 1)
		"FarmHouse":
			offset_x = -0
			offset_y = 0
			zoom = Vector2(1, 1)
		"FortifiedHouse":
			offset_x = -0
			offset_y = 0
			zoom = Vector2(1, 1)
		"Inn":
			offset_x = -0
			offset_y = 0
			zoom = Vector2(1, 1)
		"InnSecondFloor":
			offset_x = -0
			offset_y = 0
			zoom = Vector2(1, 1)
		"Basement":
			offset_x = -0
			offset_y = 0
			zoom = Vector2(1, 1)
		"DungeonBottomLeft":
			offset_x = -0
			offset_y = 0
			zoom = Vector2(1, 1)
		"DungeonBottomRight":
			offset_x = -0
			offset_y = 0
			zoom = Vector2(1, 1)
		"DungeonTop":
			offset_x = -0
			offset_y = 0
			zoom = Vector2(1, 1)
		_:
			offset_x = -1100
			offset_y = 100
			zoom = Vector2(1, 1)

func get_map_background():
	var map_name = get_tree().get_nodes_in_group("map")[0].name
	var background;
	match map_name:
		"House":
			background = load("res://World/House/House.tscn").instance()
		"HouseSecondFloor":
			background = load("res://World/House/HouseSecondFloor.tscn").instance()
		"FarmHouse":
			background = load("res://World/FarmHouse/FarmHouse.tscn").instance()
		"FortifiedHouse":
			background = load("res://World/FortifiedHouse/FortifiedHouse.tscn").instance()
		"Inn":
			background = load("res://World/Inn/Inn.tscn").instance()
		"InnSecondFloor":
			background = load("res://World/Inn/InnSecondFloor.tscn").instance()
		"Basement":
			background = load("res://World/Basement/Basement.tscn").instance()
		"DungeonBottomLeft":
			background = load("res://World/Dungeon/DungeonBottomLeft.tscn").instance()
		"DungeonBottomRight":
			background = load("res://World/Dungeon/DungeonBottomRight.tscn").instance()
		"DungeonTop":
			background = load("res://World/Dungeon/DungeonTop.tscn").instance()
		_:
			background = load("res://World/Background.tscn").instance()
	return background
	
func set_player_pin():
	var player = get_tree().get_nodes_in_group("Player")[0]
	var pos_x = player.position.x
	var pos_y = player.position.y 
	player_pin.set_position(Vector2(pos_x + offset_x, pos_y + offset_y))

func set_quest_pins():
	for quest_npc in get_tree().get_nodes_in_group("quest"):
		if quest_npc.quest_bubble.visible:
			var bubble_pic = quest_npc.quest_bubble.animated_sprite.animation
			var quest_pin = load("res://UI/Minimap/quest_pin.tscn").instance()
			quest_pin.animation(bubble_pic)
			quest_pin.set_position(Vector2(quest_npc.position.x + offset_x, quest_npc.position.y + offset_y))
			
			viewport.get_node("Pins").add_child(quest_pin)

func _input(event):
	if event.is_action_pressed("esc"):
		queue_free()
		get_tree().paused = false
		get_node("/root/UI/CanvasLayer/UserInterface/Hotbar").visible = true
		
	if event.is_action_pressed("scroll_up"):
		if camera.zoom.x > 0.1:
			camera.zoom.x = camera.zoom.x / 1.1
			camera.zoom.y = camera.zoom.y / 1.1
	
	if event.is_action_pressed("scroll_down"):
		if camera.zoom.x <= 1:
			camera.zoom.x = camera.zoom.x / 0.9
			camera.zoom.y = camera.zoom.y / 0.9
		
const move_speed = 1

func _process(delta):
	if Input.is_action_pressed("move_left"):
		camera.offset.x -= move_speed
	
	if Input.is_action_pressed("move_right"):
		camera.offset.x += move_speed
		
	if Input.is_action_pressed("move_up"):
		camera.offset.y -= move_speed
		
	if Input.is_action_pressed("move_down"):
		camera.offset.y += move_speed
