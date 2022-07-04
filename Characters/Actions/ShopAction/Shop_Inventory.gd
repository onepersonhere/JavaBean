extends Control

onready var rng = RandomNumberGenerator.new()
onready var inventory_stuff = $ScrollContainer/VBoxContainer
func _ready():
	rng.randomize()
	
func load_inventory_stuff():
	var player = get_tree().get_nodes_in_group("Player")[0];
	
	var inventory = get_tree().get_nodes_in_group("Inventory")[0]
	var hotbar = get_tree().get_nodes_in_group("Hotbar")[0]
	
	# reset the shop
	for child in inventory_stuff.get_children():
		child.queue_free()
		
	for slot in inventory.inventory_slots.get_children():
		if exist(slot):
			add_as_panel(slot, inventory, "inventory")
		
	for slot in hotbar.slots:
		if exist(slot):
			add_as_panel(slot, hotbar, "hotbar")
	

func add_as_panel(slot, location, location_name):
	var item_name = slot.item.item_name
	var amt = slot.item.item_quantity
	var panel = load("res://Characters/Actions/ShopAction/ItemPanel.tscn").instance();
	panel.find_node("TextureRect").texture = load("res://Inventory/Icons/" + item_name + ".png")
	panel.find_node("Name_val").text = item_name
	panel.find_node("Amt_val").text = str(amt)
	
	panel.location = location_name
	panel.slot = slot
	panel.item_name = item_name
	# TODO: Construct a pricing system based on weightage of the price of the object.
	panel.find_node("Price_val").text = str(rng.randi_range(1, 100)) + " coin(s)"
	inventory_stuff.add_child(panel)

func exist(slot):
	return slot.item != null
