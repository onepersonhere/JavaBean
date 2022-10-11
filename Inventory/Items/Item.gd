extends Node2D

var item_name
var item_quantity
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_item(name, quantity):
	item_name = name
	item_quantity = quantity
	# get info of item
	$TextureRect.texture = load("res://Inventory/Icons/" + item_name + ".png")
	scale($TextureRect.texture)
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	
	# label toggle
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)
		
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)

func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)

func scale(texture):
	if texture != null && texture.get_size() != Vector2(16, 16):
		var isz = texture.get_size()
		var th = 16 #target height
		var tw = 16 #target width
		var s = Vector2((isz.x/(isz.x/tw))/400, (isz.y/(isz.y/th))/400)
		$TextureRect.rect_scale = s
