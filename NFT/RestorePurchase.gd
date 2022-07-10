extends CanvasLayer

onready var http = $HTTPRequest
onready var wallet_addr = $ConfirmationDialog/VBoxContainer/wallet_addr
onready var token_id = $ConfirmationDialog/VBoxContainer/token_id
onready var contract_addr = $ConfirmationDialog/VBoxContainer/contract_addr
onready var notification = $AcceptDialog
var base_url = "https://testnets-api.opensea.io/api/v1/asset/"
var creator_addr = "0xd8b6eb581f77b1205fa312ec9c1a22d960b5900f"
var item_name
var img_req = false
var img

func _ready():
	$ConfirmationDialog.popup_centered()
	wallet_addr.text = GlobalVar.get_nft_addr()

func _on_ConfirmationDialog_confirmed():
	var url = base_url + "/" + contract_addr.text + "/" + token_id.text;
	http.request(url, [], false, HTTPClient.METHOD_GET)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200 && !img_req:
		check(JSON.parse(body.get_string_from_ascii()).result)
	elif response_code == 200 && img_req:
		img = InventoryManager.image_loader(body, img_req, item_name)
	else:
		print_debug(response_code)

func check(result_body):
	var created = false;
	var found = false;
	var quantity = 0;
	
	# check creator
	if result_body["creator"]["address"] == creator_addr:
		created = true;
		
	# duplicated code from purchase scanner, TODO: merge them together
	for owner in result_body["top_ownerships"]:
		quantity = owner["quantity"]
		var addr = owner["owner"]["address"]
		
		if addr == wallet_addr.text.to_lower():
			found = true;
			break;
	
	if found && created:
		if add_item_to_inventory(result_body["name"], result_body["description"],
		 quantity, result_body["traits"], result_body["image_url"]):
			notification.dialog_text = "item(s) added to inventory"
		else:
			notification.dialog_text = "item(s) already in inventory"
	else:
		notification.dialog_text = "item does not exist"
	notification.popup_centered()

func add_item_to_inventory(name, desc, quantity, traits, img_url):
	# request image first
	item_name = name
	img_req = true
	http.request(img_url)
	yield(http, "request_completed")
	img_req = false
	
	InventoryManager.add_new_item(name, quantity, InventoryManager.parse_traits(traits, desc), img)
