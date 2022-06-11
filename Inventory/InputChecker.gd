extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var holding_item

func _input(event):
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialise_inventory()
	
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
	
	if event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass