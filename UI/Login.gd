extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $VBoxContainer/Username/LineEdit
onready var password : LineEdit = $VBoxContainer/Password/LineEdit
onready var notification : AcceptDialog = $Notification

func _ready():
	pass 

func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	var response_body = JSON.parse(body.get_string_from_ascii())
	if response_code == 0:
		notification.dialog_text = "Please connect to the internet!!"
		notification.popup_centered()
	elif response_code != 200:
		notification.dialog_text = response_body.result.error.message.capitalize()
		notification.popup_centered()
	else:
		yield(get_tree().create_timer(0.5), "timeout")
		#warning-ignore:return_value_discarded
		get_tree().change_scene("res://UI/Profile/UserProfile.tscn")


func _on_Login_pressed():
	if password.text.empty() or username.text.empty():
		notification.dialog_text = "Invalid password or username"
		notification.window_title = "Task Failed Successfully"
		notification.popup()
	else:
		Firebase.login(username.text, password.text, http)


func _on_Back_pressed():
	#warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")
