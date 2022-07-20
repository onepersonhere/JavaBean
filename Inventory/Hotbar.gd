extends Node2D

const SlotClass = preload("res://Inventory/Slot.gd")
onready var hotbar = $HotbarSlots
onready var active_item_label = $ActiveItemLabel
onready var slots = hotbar.get_children()
func _ready():
	#warning-ignore:return_value_discarded
	PlayerInventory.connect("active_item_updated", self, "update_active_item_label")
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		#warning-ignore:return_value_discarded
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.HOTBAR
	initialise_hotbar()
	update_active_item_label()

func update_active_item_label():
	if slots[PlayerInventory.active_item_slot_index].item != null:
		active_item_label.text = slots[PlayerInventory.active_item_slot_index].item.item_name
	else:
		active_item_label.text = ""

func initialise_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialise_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
		else:
			slots[i].reset()
			
func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			# Currently holding an item
			if find_parent("UserInterface").holding_item != null:
				# Empty slot
				if !slot.item:
					left_click_empty_slot(slot)
				# Slot alr contain an item
				else: 
					# Different item -> swap
					if find_parent("UserInterface").holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					# Same item -> Merge?
					else:
						left_click_same_item(slot)
			# Not holding an item
			elif slot.item:
				left_click_not_holding(slot)
			update_active_item_label()

func left_click_empty_slot(slot: SlotClass):
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null

func left_click_different_item(event: InputEvent, slot: SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent("UserInterface").holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity)
		slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
		find_parent("UserInterface").holding_item.queue_free()
		find_parent("UserInterface").holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		find_parent("UserInterface").holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	find_parent("UserInterface").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position()
