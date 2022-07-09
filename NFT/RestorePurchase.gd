extends CanvasLayer

onready var http = $HTTPRequest
onready var wallet_addr = $ConfirmationDialog/VBoxContainer/wallet_addr
onready var token_id = $ConfirmationDialog/VBoxContainer/token_id
onready var contract_addr = $ConfirmationDialog/VBoxContainer/contract_addr
onready var notification = $AcceptDialog
var base_url = "https://testnets-api.opensea.io/api/v1/asset/"
var creator_addr = "0xd8b6eb581f77b1205fa312ec9c1a22d960b5900f"

func _ready():
	$ConfirmationDialog.popup_centered()


func _on_ConfirmationDialog_confirmed():
	var url = base_url + "/" + contract_addr.text + "/" + token_id.text;
	http.request(url, [], false, HTTPClient.METHOD_GET)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		check(JSON.parse(body.get_string_from_ascii()).result)
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
		
		if addr == wallet_addr.text:
			found = true;
			break;
	
	if found && created:
		if add_item_to_inventory(quantity):
			notification.dialog_text = "item(s) added to inventory"
		else:
			notification.dialog_text = "item(s) already in inventory"
	else:
		notification.dialog_text = "item does not exist"
	notification.popup_centered()

func add_item_to_inventory(quantity):
	# grab item pic
	# parse item traits
	# add them as JSON
	# add them to inventory
	return true
