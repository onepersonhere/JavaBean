extends Node

func _ready():
	pass

func is_full():
	return PlayerInventory.inventory.size() >= PlayerInventory.NUM_INVENTORY_SLOTS

func add_new_item(item_name, quantity, traits: Dictionary, _texture):
	JsonData.item_data[item_name] = traits
	JsonData.SaveData(JsonData.path)
	
	PlayerInventory.add_item(item_name, int(quantity))

func parse_traits(traits: Array, description):
	# convert from array to dictionary
	var dic_traits: Dictionary = {};
	for trait in traits:
		dic_traits[trait.trait_type] = trait.value
		
	dic_traits["description"] = description
	return dic_traits

func image_loader(url, add_item, item_name):
	# image can only be in png form
	var image = Image.new()
	var image_error = image.load_png_from_buffer(url)
	if image_error != OK:
		print("An error occurred while trying to display the image.")
		return null;
	else:
		if add_item:
			save_img(item_name, image)
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		return texture;

func save_img(item_name, img):
	var path = "res://Inventory/Icons/" + item_name + ".png"
	# check if path exist
	if Directory.new().open(path) == OK:
		print_debug("file exist")
	else:
		print_debug("saved")
		img.save_png(path)
		yield(get_tree().create_timer(1), "timeout")

func get_active_item_stats():
	if PlayerInventory.active_item_slot_index < PlayerInventory.hotbar.size():
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot_index][0]
		var stats = JsonData.item_data[item_name];
		return stats;
	else: return null;
	
func get_active_item_name():
	if PlayerInventory.active_item_slot_index < PlayerInventory.hotbar.size():
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot_index][0]
		return item_name;
	else: return null;

func refresh_inventory():
	var inventory = get_node("/root/UI/CanvasLayer/UserInterface/Inventory")
	var hotbar = get_node("/root/UI/CanvasLayer/UserInterface/Hotbar")
	inventory.initialise_inventory()
	inventory.initialise_equip_slots()
	hotbar.initialise_hotbar()
