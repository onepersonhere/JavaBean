extends Action

onready var rng = RandomNumberGenerator.new()
onready var inventory_stuff = $Popup/Inventory/ScrollContainer/VBoxContainer
func _ready():
	pass # Replace with function body.


func interact():
	if active:
		$Popup.popup_centered()
		active = false
		
		update_val()
	else:
		$Popup.hide()
		emit_signal("finished")
		active = true

func update_val():
	var player = get_tree().get_nodes_in_group("Player")[0];
	$Popup/Coins/Coins_value.text = str(player.COINS)
	$Popup/Gems/Gems_value.text = str(player.GEMS)
	
	load_inventory_stuff()

func load_inventory_stuff():
	var inventory = PlayerInventory.inventory
	var hotbar = PlayerInventory.hotbar
	
	for stuff in inventory:
		add_as_panel(stuff, inventory)
		
	for stuff in hotbar:
		add_as_panel(stuff, hotbar)
	

func add_as_panel(stuff, location):
	var item_name = location[stuff][0]
	var amt = location[stuff][1]
	var panel = load("res://Characters/Actions/ItemPanel.tscn").instance();
	panel.find_node("TextureRect").texture = load("res://Inventory/Icons/" + item_name + ".png")
	panel.find_node("Name_val").text = item_name
	panel.find_node("Amt_val").text = str(amt)
	# TODO: Construct a pricing system based on weightage of the price of the object.
	panel.find_node("Price_val").text = str(rng.randi_range(1, 100)) + " coin(s)"
	inventory_stuff.add_child(panel)