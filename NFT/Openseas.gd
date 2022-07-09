extends Node

onready var http = $HTTPRequest
onready var shop = $Shop/Control/ScrollContainer/HBoxContainer/VBoxContainer
# currently only active on testnet
const api_key = ""

const base_url = "https://testnets-api.opensea.io/api/v1/"
const address = "0xd8b6eb581F77B1205fa312EC9C1A22D960B5900F"

var pic = false;
var curr_pointer

func _ready():
	get_assets()
	
func get_req_headers() -> PoolStringArray:
	return PoolStringArray([
		"Accept: application/json",
		"X-API-KEY: %s" % api_key
	])


func get_assets():
	var url = base_url + "assets?owner=" + address + "&order_direction=desc&offset=0&limit=20"
	http.request(url, [], false, HTTPClient.METHOD_GET)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if !pic:
		var result_body = JSON.parse(body.get_string_from_ascii()).result
		if response_code == 200:
			print_debug("get successful")
			parse_assets(result_body["assets"])
		else:
			print_debug(response_code)
	else:
		var image = Image.new()
		var image_error = image.load_png_from_buffer(body)
		if image_error != OK:
			print("An error occurred while trying to display the image.")
		else:
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			curr_pointer.texture = texture 
		pic = false
	
func parse_assets(assets):
	for asset in assets:
			var name = asset["name"]
			var description = asset["description"]
			var traits = asset["traits"]
			var image = asset["image_url"]
			var link = asset["permalink"]
			var token_id = asset["token_id"]
			
			yield(add_panels(name, description, traits, image, link, token_id), "completed")
			# redundant info for now 
			var id = asset["id"]
			var contract = asset["asset_contract"]["address"]
			var asset_contract_address = base_url + "asset_contract/" + contract
			

func add_panels(name, desc, traits, img, link, token_id):
	var panel = load("res://NFT/ObjectPanel.tscn").instance()
	
	panel.connect("buy_opened", self, "check_purchase", [token_id])
	
	# image stuff
	shop.add_child(panel)
	curr_pointer = panel.texture
	pic = true
	
	http.request(img)
	yield(http, "request_completed")
	
	var text = "%s\n\t%s\n\t\tTraits:\n" % [name, desc]
	for trait in traits:
		text += "\t\t\t" + trait["trait_type"] + ": " + str(trait["value"]) + "\n"
	
	panel.description.text = text
	panel.buy_link = link
	panel.view_link = img
	panel.enable()

func check_purchase(token_id):
	print_debug(token_id)
