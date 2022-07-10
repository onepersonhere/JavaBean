extends Node

func _ready():
	pass

func is_full():
	return PlayerInventory.inventory.size() >= PlayerInventory.NUM_INVENTORY_SLOTS

func add_new_item(item_name, quantity, traits: Dictionary):
	if JsonData.item_data.has(item_name):
		return false
	else:
		JsonData.item_data[item_name] = traits
		JsonData.SaveData(JsonData.path)
	
	PlayerInventory.add_item(item_name, quantity)

func parse_traits(traits: Array, description):
	# convert from array to dictionary
	var dic_traits: Dictionary;
	for trait in traits:
		dic_traits[trait.trait_type] = trait.value
		
	dic_traits["description"] = description
	return dic_traits
