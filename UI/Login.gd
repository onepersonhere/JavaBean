extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $VBoxContainer/Username/LineEdit
onready var password : LineEdit = $VBoxContainer/Password/LineEdit
onready var notification : AcceptDialog = $Notification

func _ready():
	pass 


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.


func _on_Login_pressed():
	if password.text.empty() or username.text.empty():
		notification.dialog_text = "Invalid password or username"
		notification.window_title = "Task Failed Successfully"
		notification.popup()
