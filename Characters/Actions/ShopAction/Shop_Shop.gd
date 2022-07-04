extends Control

onready var shop_stuff = $ScrollContainer/VBoxContainer
onready var rng = RandomNumberGenerator.new()
var loaded = false;

func _ready():
	rng.randomize()
	
func load_shop_stuff():
	var items: Dictionary = JsonData.item_data;
	if not loaded:
		for item in items:
			if (rng.randi_range(1, 10) < 5):
				add_item_to_shop(item, items);
		loaded = true

func add_item_to_shop(item, items):
	var item_name = item;
	var amt = rng.randi_range(1, 99)
	var panel = load("res://Characters/Actions/ShopAction/ItemPanelShop.tscn").instance();
	
	panel.find_node("TextureRect").texture = load("res://Inventory/Icons/" + item_name + ".png")
	panel.find_node("Name_val").text = item_name
	panel.find_node("Amt_val").text = str(amt)
	panel.item_name = item_name
	
	# TODO: Construct a pricing system based on weightage of the price of the object.
	panel.find_node("Price_val").text = str(rng.randi_range(1, 100)) + " coin(s)"
	shop_stuff.add_child(panel)
