extends Control

onready var rng = RandomNumberGenerator.new()
onready var inventory_stuff = $ScrollContainer/VBoxContainer
func _ready():
	rng.randomize()
	
func load_inventory_stuff():
	var inventory = PlayerInventory.inventory
	var hotbar = PlayerInventory.hotbar
	
	for stuff in inventory:
		if not check_if_exist(stuff, "inventory"):
			add_as_panel(stuff, inventory, "inventory")
		
	for stuff in hotbar:
		if not check_if_exist(stuff, "hotbar"):
			add_as_panel(stuff, hotbar, "hotbar")
	

func add_as_panel(stuff, location, location_name):
	var item_name = location[stuff][0]
	var amt = location[stuff][1]
	var panel = load("res://Characters/Actions/ShopAction/ItemPanel.tscn").instance();
	panel.find_node("TextureRect").texture = load("res://Inventory/Icons/" + item_name + ".png")
	panel.find_node("Name_val").text = item_name
	panel.find_node("Amt_val").text = str(amt)
	
	panel.location = location_name
	panel.stuff = stuff
	panel.item_name = item_name
	# TODO: Construct a pricing system based on weightage of the price of the object.
	panel.find_node("Price_val").text = str(rng.randi_range(1, 100)) + " coin(s)"
	inventory_stuff.add_child(panel)

func check_if_exist(cstuff, clocation):
	var children = inventory_stuff.get_children()
	for child in children:
		if child.stuff == cstuff && child.location == clocation:
			return true
	return false
