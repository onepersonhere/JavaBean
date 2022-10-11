extends Panel

var default_tex = preload("res://Inventory/Images/item_slot_default_background.png")
var empty_tex = preload("res://Inventory/Images/item_slot_empty_background.png")
var selected_tex = preload("res://Inventory/Images/item_slot_selected_background.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var ItemClass = preload("res://Inventory/Items/Item.tscn")
var item = null
var slot_index
var slot_type

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	SHIRT,
	PANTS,
	SHOES,
}

var mouse_not_exited = false;

func _ready():
	self.connect("mouse_entered", self, "_on_mouse_entered")
	self.connect("mouse_exited", self, "_on_mouse_exited")
	
	# create new styleboxtexture
	default_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	
	empty_style = StyleBoxTexture.new()
	empty_style.texture = empty_tex
	
	selected_style = StyleBoxTexture.new()
	selected_style.texture = selected_tex
	
	refresh_style()
		
func refresh_style():
	# can also use match
	if SlotType.HOTBAR == slot_type && PlayerInventory.active_item_slot_index == slot_index:
		set('custom_styles/panel', selected_style)
	elif item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)
		
func pickFromSlot():
	# picks item from slot
	remove_child(item)
	var inventoryNode = find_parent("UserInterface")
	inventoryNode.add_child(item)
	item = null
	refresh_style()
	
func putIntoSlot(new_item):
	# puts item into slot
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("UserInterface")
	inventoryNode.remove_child(item)
	
	add_child(item)
	refresh_style()
	
func initialise_item(item_name, item_quantity):
	# set item
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()

func reset():
	if item != null:
		remove_child(item)
	item = null
	refresh_style()

var tooltip;
func _on_mouse_entered():
	mouse_not_exited = true
	yield(get_tree().create_timer(1), "timeout") 
	
	if mouse_not_exited && item != null && weakref(tooltip).get_ref() == null:
		var item_name = item.item_name;
		
		tooltip = load("res://Inventory/Items/ItemTooltip.tscn").instance()
		tooltip._popup(item_name)
		
		add_child(tooltip)
		tooltip.popupMenu.popup()

func _on_mouse_exited():
	mouse_not_exited = false;
	if weakref(tooltip).get_ref() != null:
		weakref(tooltip).get_ref().queue_free();
