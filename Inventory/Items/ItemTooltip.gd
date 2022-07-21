extends CanvasLayer

onready var popupMenu = $PopupMenu
func _ready():
	pass

func _popup(item_name):
	var item = JsonData.item_data[item_name]
	for properties in item:
		$PopupMenu.add_item(properties + ": " + str(item[properties]))
