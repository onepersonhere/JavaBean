extends Node2D

const SlotClass = preload("res://Inventory/Slot.gd")
onready var hotbar = $HotbarSlots
onready var slots = hotbar.get_children()
func _ready():
	for i in range(slots.size()):
		#slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.HOTBAR
	initialise_hotbar()

func initialise_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialise_items(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
			
