extends Node2D

onready var hotbar = $HotbarSlots
onready var slots = hotbar.get_children()
func _ready():
	for i in range(slots.size()):
		#slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
	initialise_hotbar()

func initialise_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialise_items(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
			
