extends CanvasLayer

onready var http = $HTTPRequest
onready var notification = $AcceptDialog
onready var wallet_addr = $ConfirmationDialog/VBoxContainer/LineEdit
var token_id
var contract_addr

var base_url = "https://testnets-api.opensea.io/api/v1/asset/"

func initialise(token_id, contract):
	$ConfirmationDialog.popup_centered()
	self.token_id = token_id
	self.contract_addr = contract
	print(contract_addr)

func _on_ConfirmationDialog_confirmed():
	# check if wallet addr matches the "top_ownerships" owners addresses
	var url = base_url + "/" + contract_addr + "/" + token_id;
	http.request(url, [], false, HTTPClient.METHOD_GET)
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		check(JSON.parse(body.get_string_from_ascii()).result)
	else:
		print_debug(response_code)

func check(result_body):
	var found = false;
	var quantity = 0;
	
	for owner in result_body["top_ownerships"]:
		quantity = owner["quantity"]
		var addr = owner["owner"]["address"]
		
		if addr == wallet_addr.text:
			found = true;
			break;
	
	if found:
		if add_item_to_inventory(quantity):
			notification.dialog_text = "item(s) added to inventory"
		else:
			notification.dialog_text = "item(s) already in inventory"
	else:
		notification.dialog_text = "item not bought"
	notification.popup_centered()

func add_item_to_inventory(quantity):
	# parse item traits
	# add them as JSON
	# add them to inventory
	return true
