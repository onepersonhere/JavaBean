extends Node


func is_full():
	return PlayerInventory.inventory.size() >= PlayerInventory.NUM_INVENTORY_SLOTS
