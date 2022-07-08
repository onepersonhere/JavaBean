extends 'res://addons/gut/test.gd'

var MainMenu = load("res://UI/Main Menu.tscn")
var _MainMenu = null

func before_each():
	_MainMenu = MainMenu.instance()
	get_tree().root.add_child(MainMenu)

func after_each():
	_MainMenu.queue_free()

func test_Login():
	pass

func test_Register():
	pass

func test_Options():
	pass
