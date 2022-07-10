extends CanvasLayer

onready var http = $HTTPRequest
onready var notification = $AcceptDialog
onready var wallet_addr = $ConfirmationDialog/VBoxContainer/LineEdit
var token_id
var contract_addr
var img_req = false;
var img
var item_name;

var base_url = "https://testnets-api.opensea.io/api/v1/asset/"

func initialise(token_id, contract):
	$ConfirmationDialog.popup_centered()
	self.token_id = token_id
	self.contract_addr = contract

func _on_ConfirmationDialog_confirmed():
	# check if wallet addr matches the "top_ownerships" owners addresses
	var url = base_url + "/" + contract_addr + "/" + token_id;
	http.request(url, [], false, HTTPClient.METHOD_GET)
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200 && !img_req:
		check(JSON.parse(body.get_string_from_ascii()).result)
	elif response_code == 200 && img_req:
		img = InventoryManager.image_loader(body, img_req, item_name)
	else:
		print_debug(response_code)

func check(result_body):
	var found = false;
	var quantity = 0;
	
	for owner in result_body["top_ownerships"]:
		quantity = owner["quantity"]
		var addr = owner["owner"]["address"]
		
		if addr == wallet_addr.text.to_lower():
			found = true;
			break;
	
	if found:
		if InventoryManager.is_full():
			notification.dialog_text = "inventory is full!"
			
		elif add_item_to_inventory(result_body["name"], result_body["description"],
		 quantity, result_body["traits"], result_body["image_url"]):
			notification.dialog_text = "item(s) added to inventory"
		else:
			notification.dialog_text = "item(s) already in inventory"
	else:
		notification.dialog_text = "item not bought"
		
	yield(get_tree().create_timer(1), "timeout")
	notification.popup_centered()

func add_item_to_inventory(name, desc, quantity, traits, img_url):
	# request image first
	item_name = name
	img_req = true
	http.request(img_url)
	yield(http, "request_completed")
	img_req = false
	
	InventoryManager.add_new_item(name, quantity, InventoryManager.parse_traits(traits, desc), img)
