extends CanvasLayer
var val = "stringValue"

onready var http = $HTTPRequest
onready var http2 = $HTTPRequest2
var at_check_quest_done = false;
var quest_done = {
"quest_1": {val : "Not Done"},
"quest_2": {val : "Not Done"},
"quest_3": {val : "Not Done"}
}
onready var user_id = Firebase.user_info.id
onready var time = OS.get_datetime()["weekday"]

onready var text_field_1 = $Control/Col1/RichTextLabel
onready var text_field_2 = $Control/Col2/RichTextLabel
onready var text_field_3 = $Control/Col3/RichTextLabel


func _ready():
	var link = "daily_quests/%s" % "day_" + str(time)
	
	Firebase.get_document(link, http)
	
	yield(get_tree().create_timer(1), "timeout")
	at_check_quest_done = true
	Firebase.get_document("daily_quests_done/%s" % user_id, http)
	

func _on_TextureButton1_pressed():
	on_quest_done("quest_1")
	$Control/Col1/HBoxContainer/TextureButton1.disabled = true

func _on_TextureButton2_pressed():
	on_quest_done("quest_2")
	$Control/Col2/HBoxContainer/TextureButton2.disabled = true

func _on_TextureButton3_pressed():
	on_quest_done("quest_3")
	$Control/Col3/HBoxContainer/TextureButton3.disabled = true


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if at_check_quest_done:
		if response_code == 200:
			set_quest_done(body)
		else:
			Firebase.save_document("daily_quests_done/%s" % user_id, quest_done, http2)
	else:
		if response_code != 200:
			print_debug(response_code)
		else:
			update_notice_board(body)
			
func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	if response_code == 200:
		set_quest_done(body)
	else:
		print_debug(response_code)
		
func set_quest_done(body):
	var result_body = JSON.parse(body.get_string_from_ascii()).result.fields
	
	# manually set them
	quest_done["quest_1"][val] = result_body["quest_1"][val]
	quest_done["quest_2"][val] = result_body["quest_2"][val]
	quest_done["quest_3"][val] = result_body["quest_3"][val]
	
	if quest_done["quest_1"][val] == "Not Done":
		$Control/Col1/HBoxContainer/TextureButton1.disabled = false
	if quest_done["quest_2"][val] == "Not Done":
		$Control/Col2/HBoxContainer/TextureButton2.disabled = false
	if quest_done["quest_3"][val] == "Not Done":
		$Control/Col3/HBoxContainer/TextureButton3.disabled = false

func on_quest_done(quest):
	quest_done[quest][val] = "Done"
	Firebase.update_document("daily_quests_done/%s" % user_id, quest_done, http)

func update_notice_board(body):
	var result_body = JSON.parse(body.get_string_from_ascii()).result.fields
	value_parser(text_field_1, result_body["quest_1"][val])
	value_parser(text_field_2, result_body["quest_2"][val])
	value_parser(text_field_3, result_body["quest_3"][val])
	
func value_parser(field, value):
	field.text = value


