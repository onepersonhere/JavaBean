extends Control


onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $VBoxContainer/Username/LineEdit
onready var password : LineEdit = $VBoxContainer/Password/LineEdit
onready var confirm : LineEdit = $VBoxContainer/Confirm/LineEdit
onready var notification : AcceptDialog = $Notification

func _ready():
	pass 


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response_body = JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.dialog_text = response_body.result.error.message.capitalize()
		notification.window_title = str(response_code)
		notification.popup()
	else:
		get_tree().change_scene("res://UI/Login.tscn")


func _on_Register_pressed():
	if password.text != confirm.text or password.text.empty() or username.text.empty():
		notification.dialog_text = "Invalid password or username"
		notification.window_title = "Task Failed Successfully"
		notification.popup()
	else:
		Firebase.register(username.text, password.text, http)


func _on_Back_pressed():
	get_tree().change_scene("res://Main.tscn")
