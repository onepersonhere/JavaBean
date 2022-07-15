extends Control

onready var http: HTTPRequest = $HTTPRequest
onready var notification: AcceptDialog = $Notification
var information_sent = false
var delete = false
# info
var new_profile = false

onready var nft_addr: Label = $Address/Label
onready var nickname: LineEdit = $MainContainer/Col1/Nickname/LineEdit
onready var character_class: OptionButton = $MainContainer/Col1/Class/OptionButton
onready var location: Label = $MainContainer/Col2/Location/Location

# stats
onready var max_hp: LineEdit = $MainContainer/Col2/HP/LineEdit
onready var max_sp: LineEdit = $MainContainer/Col2/SP/LineEdit
var curr_hp = 0
var curr_sp = 0
onready var strength: LineEdit = $MainContainer/Col1/Stats/Strength/LineEdit
onready var intelligence: LineEdit = $MainContainer/Col1/Stats/Intelligence/LineEdit
onready var dexterity: LineEdit = $MainContainer/Col1/Stats/Dexterity/LineEdit

# currency
onready var coins: LineEdit = $MainContainer/Col2/Coins/LineEdit
onready var gems: LineEdit = $MainContainer/Col2/Gems/LineEdit

onready var profile_pic: TextureRect = $MainContainer/CenterContainer/Col3/CenterContainer/Profile

var profile = {
	"nft_addr": {},
	"nickname": {},
	"character_class": {},
	"location": {},
	"max_hp": {},
	"max_sp": {},
	"curr_hp": {},
	"curr_sp": {},
	"strength": {},
	"intelligence": {},
	"dexterity": {},
	"coins": {},
	"gems": {},
} setget set_profile

func _ready():
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)
	if !new_profile:
		character_class.disabled = true
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body = JSON.parse(body.get_string_from_ascii()).result
	match response_code:
		404:
			nft_addr.text = GlobalVar.get_nft_addr()
			notification.dialog_text = "Please enter your information"
			notification.popup_centered()
			new_profile = true
			return
		200:
			if information_sent:
				notification.dialog_text = "Information saved successfully"
				notification.popup_centered()
				information_sent = false
			if !delete:
				self.profile = result_body.fields

func _on_Confirm_pressed():
	if nickname.text.empty() or character_class.text.empty():
		notification.dialog_text = "Please enter your nickname and class!"
		notification.popup_centered()
		return
	
	GlobalVar.set_nft_addr(nft_addr.text)
	profile.nft_addr = {"stringValue": nft_addr.text}
	profile.nickname = {"stringValue": nickname.text}
	profile.character_class = {"stringValue": character_class.text}
	profile.location = {"stringValue": location.text}
	profile.max_hp = {"integerValue": int(max_hp.text)}
	profile.max_sp = {"integerValue": int(max_sp.text)}
	profile.curr_hp = {"integerValue": int(curr_hp)}
	profile.curr_sp = {"integerValue": int(curr_sp)}
	profile.strength = {"integerValue": int(strength.text)}
	profile.intelligence = {"integerValue": int(intelligence.text)}
	profile.dexterity = {"integerValue": int(dexterity.text)}
	profile.coins = {"integerValue": int(coins.text)}
	profile.gems = {"integerValue": int(gems.text)}
	
	match new_profile:
		true:
			Firebase.save_document("users?documentId=%s" % Firebase.user_info.id, profile, http)
		false:
			Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	information_sent = true
	yield(get_tree().create_timer(1), "timeout")
	get_tree().root.add_child(load("res://UI/UI.tscn").instance())
	
	PlayerStats.initialize()
	Load.load(profile, "World")
	queue_free()
	
	
func set_profile(value: Dictionary) -> void:
	profile = value
	nft_addr.text = profile.nft_addr.stringValue
	nickname.text = profile.nickname.stringValue
	character_class.text = profile.character_class.stringValue
	location.text = profile.location.stringValue
	max_hp.text = profile.max_hp.integerValue
	max_sp.text = profile.max_sp.integerValue
	curr_hp = profile.curr_hp.integerValue
	curr_sp = profile.curr_sp.integerValue
	strength.text = profile.strength.integerValue
	intelligence.text = profile.intelligence.integerValue
	dexterity.text = profile.dexterity.integerValue
	coins.text = profile.coins.integerValue
	gems.text = profile.gems.integerValue


func _on_Inventory_pressed():
	var label = $PopupPanel/RichTextLabel
	label.text = "Inventory:"
	var inv = PlayerInventory.inventory
	var hb = PlayerInventory.hotbar
	var eq = PlayerInventory.equips
	
	for item in inv:
		var item_name = inv[item][0]
		var quantity = str(inv[item][1])
		label.text += "\n\t" + item_name + ", " + quantity
		
	label.text += "\n\nHotbar:"
	
	for item in hb:
		var item_name = hb[item][0]
		var quantity = str(hb[item][1])
		label.text += "\n\t" + item_name + ", " + quantity
	
	label.text += "\n\nEquips:"
	
	for item in eq:
		var item_name = eq[item][0]
		var quantity = str(eq[item][1])
		label.text += "\n\t" + item_name + ", " + quantity
	
	$PopupPanel.popup()


func _on_Edit_pressed():
	pass # Future expansion perhaps?


func _on_RESET_pressed():
	var confirm = $ConfirmationDialog
	confirm.popup_centered()
	

func _on_ConfirmationDialog_confirmed():
	delete = true
	Firebase.delete_document("users/%s" % Firebase.user_info.id, http)
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	get_tree().change_scene("res://UI/Profile/UserProfile.tscn")
