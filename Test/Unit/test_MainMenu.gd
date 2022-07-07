extends 'res://addons/gut/test.gd'

var MainMenu = load("res://UI/Main Menu.tscn")
var _MainMenu = null

func before_each():
	_MainMenu = MainMenu.instance()
	get_node("/root").add_child(_MainMenu)

func after_each():
	_MainMenu.queue_free()

func test_Login():
	#_MainMenu.get_node("Video").OnLoginGuiInput(fake_click())
	# should change to login screen
	#var login = get_tree().get_nodes_in_group("Login")
	
	#gut.p(login)
	#assert_not_null(login)
	#assert_true(login.name == "Login")
	#login.queue_free()
	pass

func test_Register():
	pass

func test_Options():
	pass

func fake_click():
	var ev = InputEventAction.new()
	ev.action = "left_click"
	ev.pressed = true
	return ev
