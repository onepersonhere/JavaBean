extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var holding_item

func _input(event):
	if event.is_action_pressed("inventory"):
		get_node("Inventory").visible = !get_node("Inventory").visible
		get_node("Inventory").initialise_inventory()
		get_tree().paused = !get_tree().paused
	
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
	
	if event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()
		
	if event.is_action_pressed("esc"):
		$OptionsMenu.visible = !$OptionsMenu.visible

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OptionsMenu_visibility_changed():
	get_tree().paused = !get_tree().paused
