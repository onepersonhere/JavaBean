extends CanvasLayer

onready var map = $Control/ViewportContainer/Viewport/Background
onready var player_pin = $Control/ViewportContainer/Viewport/Pins/PlayerLocation
onready var camera = $Control/ViewportContainer/Viewport/Camera2D
onready var viewport = $Control/ViewportContainer/Viewport

const offset_x = -1100
const offset_y = 100

func _ready():
	var player = get_node("/root/World/YSort/Player")
	var pos_x = player.position.x
	var pos_y = player.position.y 
	player_pin.set_position(Vector2(pos_x + offset_x, pos_y + offset_y))
	
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
		
const move_speed = 20

func _process(delta):
	if Input.is_action_pressed("move_left"):
		camera.offset.x -= move_speed
	
	if Input.is_action_pressed("move_right"):
		camera.offset.x += move_speed
		
	if Input.is_action_pressed("move_up"):
		camera.offset.y -= move_speed
		
	if Input.is_action_pressed("move_down"):
		camera.offset.y += move_speed
