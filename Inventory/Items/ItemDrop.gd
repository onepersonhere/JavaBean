extends KinematicBody2D

const ACCELERATION = 1000
const MAX_SPEED = 100
var velocity = Vector2.ZERO
var item_name

var player = null
var being_picked_up = false

func _ready():
	# Random item drop
	var items: Dictionary = JsonData.item_data;
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for item in items:
		if items[item].has("Price(ETH)"):
			continue;
		if item == "Red Bean":
			continue;
		if (rng.randi_range(1, 10) < 3):
			item_name = item;
			break;
	if item_name == null:
		item_name = "Slime Potion"
	$Sprite.texture = load("res://Inventory/Icons/" + item_name + ".png")
	$Timer.start()

func _physics_process(delta):
	if being_picked_up == true:
		# move to player
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		# check distance
		var distance = global_position.distance_to(player.global_position)
		if distance < 5:
			PlayerInventory.add_item(item_name, 1)
			queue_free()
	velocity = move_and_slide(velocity)
	
func pick_up_item(body):
	player = body
	being_picked_up = true
	$AudioStreamPlayer2D.play()

func _on_Timer_timeout():
	queue_free()
