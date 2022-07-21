extends 'res://addons/gut/test.gd'

var userProfile = load("res://UI/Profile/UserProfile.tscn")
var _userProfile = null

func before_each():
	_userProfile = userProfile.instance()
	

func after_each():
	if weakref(_userProfile).get_ref() != null:
		_userProfile.queue_free()

func test_User_Profile():
	var http = HTTPRequest.new()
	add_child(http)
	Firebase.login("invtest@test.com", "123456", http)
	yield(http, "request_completed")
	get_tree().get_root().add_child(_userProfile)
	
	yield(get_tree().create_timer(2), "timeout")
	_userProfile.nickname.text = "westingson"
	_userProfile._on_Confirm_pressed()
	yield(get_tree().create_timer(2), "timeout")
	assert_freed(_userProfile)
	
	http.queue_free()
	get_node("/root/World").queue_free()
	get_node("/root/UI").queue_free()
