extends CanvasLayer

onready var http = $HTTPRequest
var at_check_quest_done = false;
var quest_done = {"quest_1": "Not Done", "quest_2": "Not Done", "quest_3": "Not Done"}
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


func _on_TextureButton2_pressed():
	on_quest_done("quest_2")


func _on_TextureButton3_pressed():
	on_quest_done("quest_3")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if at_check_quest_done:
		if response_code == 200:
			set_quest_done(body)
		else:
			Firebase.save_document("daily_quests_done/%s" % user_id, quest_done, http)
	else:
		if response_code != 200:
			print_debug(response_code)
		else:
			update_notice_board()

func set_quest_done(body):
	var result_body = JSON.parse(body.get_string_from_ascii()).result
	self.quest_done = result_body.fields

func on_quest_done(quest):
	quest_done[quest] = "Done"
	Firebase.update_document("daily_quests_done/%s" % user_id, quest_done, http)

func update_notice_board():
	pass
