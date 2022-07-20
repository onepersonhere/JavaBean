extends CanvasLayer
var val = "mapValue"

onready var http = $HTTPRequest
onready var http2 = $HTTPRequest2
var at_check_quest_done = false;
var quest_done = {
"quest_1": {"stringValue" : "Not Done"},
"quest_2": {"stringValue" : "Not Done"},
"quest_3": {"stringValue" : "Not Done"}
}
onready var datetime = OS.get_datetime()
onready var time = 5 # datetime["weekday"] for now use 5
onready var user_id = str(datetime["day"]) + str(datetime["month"]) + str(datetime["year"]) + Firebase.user_info.id

onready var text_field_1 = $Control/Col1/RichTextLabel
onready var text_field_2 = $Control/Col2/RichTextLabel
onready var text_field_3 = $Control/Col3/RichTextLabel

var quest_node_1: Quest = null
var quest_node_2: Quest = null
var quest_node_3: Quest = null

func _ready():
	var link = "daily_quests/%s" % "day_" + str(time)
	
	Firebase.get_document(link, http)
	
	yield(http, "request_completed")
	at_check_quest_done = true
	Firebase.get_document("daily_quests_done/%s" % user_id, http)
	

func _on_TextureButton1_pressed():
	on_quest_done("quest_1")
	$Control/Col1/HBoxContainer/TextureButton1.disabled = true
	# add quest to player's quest system
	add_quest(quest_node_1)
	
func _on_TextureButton2_pressed():
	on_quest_done("quest_2")
	$Control/Col2/HBoxContainer/TextureButton2.disabled = true
	# add quest to player's quest system
	add_quest(quest_node_2)
	
func _on_TextureButton3_pressed():
	on_quest_done("quest_3")
	$Control/Col3/HBoxContainer/TextureButton3.disabled = true
	# add quest to player's quest system
	add_quest(quest_node_3)
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if at_check_quest_done:
		if response_code == 200:
			set_quest_done(body)
		elif response_code == 404:
			Firebase.save_document("daily_quests_done?documentId=%s" % user_id, quest_done, http2)
		else:
			var response_body = JSON.parse(body.get_string_from_ascii())
			print_debug(response_body.result.error.message.capitalize())
	else:
		if response_code != 200:
			var response_body = JSON.parse(body.get_string_from_ascii())
			print_debug(response_body.result.error.message.capitalize())
		else:
			update_notice_board(body)
			
func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	if response_code == 200:
		set_quest_done(body)
	else:
		var response_body = JSON.parse(body.get_string_from_ascii())
		print_debug(response_body.result.error.message.capitalize())
		
func set_quest_done(body):
	var result_body = JSON.parse(body.get_string_from_ascii()).result.fields
	# manually set them
	quest_done["quest_1"]["stringValue"] = result_body["quest_1"]["stringValue"]
	quest_done["quest_2"]["stringValue"] = result_body["quest_2"]["stringValue"]
	quest_done["quest_3"]["stringValue"] = result_body["quest_3"]["stringValue"]
	
	if quest_done["quest_1"]["stringValue"] == "Not Done":
		$Control/Col1/HBoxContainer/TextureButton1.disabled = false
	if quest_done["quest_2"]["stringValue"] == "Not Done":
		$Control/Col2/HBoxContainer/TextureButton2.disabled = false
	if quest_done["quest_3"]["stringValue"] == "Not Done":
		$Control/Col3/HBoxContainer/TextureButton3.disabled = false

func on_quest_done(quest):
	quest_done[quest]["stringValue"] = "Done"
	Firebase.update_document("daily_quests_done/%s" % user_id, quest_done, http)

func update_notice_board(body):
	var result_body = JSON.parse(body.get_string_from_ascii()).result.fields
	value_parser("quest_1", text_field_1, result_body["quest_1"][val].fields)
	value_parser("quest_2", text_field_2, result_body["quest_2"][val].fields)
	value_parser("quest_3", text_field_3, result_body["quest_3"][val].fields)
	
func value_parser(quest_no, field, value):
	var description = value["description"]["stringValue"]
	var name = value["name"]["stringValue"]
	var objective: Dictionary = value["objective"]["mapValue"]["fields"]
	var rewards: Array = value["reward"]["arrayValue"]["values"]
	var type = value["type"]["stringValue"]
	
	var text = name + "\n\n" + description + "\nObjective(s):\n\t"
	
	match type:
		"QuestSlayObjective":
			text += "amount" + ": " + objective["amount"]["integerValue"] + "\n\t"
			text += "enemies" + ": " + objective["battler_to_slay"]["stringValue"] + "\n\t"
			
			text += "rewards:\n\t\t"
			for reward in rewards:
				var fields = reward.mapValue.fields
				text += fields.amount.integerValue + " " + fields.item_name.stringValue + "\n\t\t"
			 
	field.text = text
	
	create_quest_node(quest_no, description, name, objective, rewards, type)
		
func create_quest_node(quest_no, description, name, objective, rewards, type):
	
	match quest_no:
		"quest_1":
			quest_node_1 = QuestManager.create_quest(name, description, objective, rewards, type, true, "Quest_1")
		"quest_2":
			quest_node_2 = QuestManager.create_quest(name, description, objective, rewards, type, true, "Quest_2")
		"quest_3":
			quest_node_3 = QuestManager.create_quest(name, description, objective, rewards, type, true, "Quest_3")

func add_quest(quest):
	QuestManager.add_quest_and_start(quest)


