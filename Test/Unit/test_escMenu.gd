extends 'res://addons/gut/test.gd'

var escMenu = load("res://UI/OptionsMenu.tscn")
var _escMenu = null

func before_each():
	_escMenu = escMenu.instance()
	get_tree().root.add_child(_escMenu)

func after_each():
	_escMenu.queue_free()

func test_SaveGame():
	pass

func test_Settings():
	pass

func test_Quest():
	pass

func test_Shop():
	pass

func test_Map():
	pass
	
func test_Inventory():
	pass

func test_Help():
	pass
	
func test_Main_Menu():
	pass

func test_Exit():
	pass

func test_Close():
	pass
