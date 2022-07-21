extends 'res://addons/gut/test.gd'

var MainMenu = load("res://UI/Main Menu.tscn")
var _MainMenu = null

func before_each():
	_MainMenu = MainMenu.instance()
	get_node("/root").add_child(_MainMenu)

func after_each():
	_MainMenu.queue_free()

func test_Login():
	# _MainMenu.get_node("Video").OnLoginGuiInput(fake_click())
	# should change to login screen
	# however, will queue_free() GUT due to how change_scene() works
	pass
	
func test_Register():
	# _MainMenu.get_node("Video").OnRegisterGuiInput(fake_click())
	# should change to reg screen
	# however, will queue_free() GUT due to how change_scene() works
	pass

func test_Options():
	_MainMenu.get_node("Video")._on_Options_pressed()
	assert_not_null(get_node_or_null("/root/Options"))
	get_node_or_null("/root/Options").queue_free()
	pass

func fake_click():
	var ev = InputEventAction.new()
	ev.action = "left_click"
	ev.pressed = true
	return ev
