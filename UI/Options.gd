extends CanvasLayer

func _ready():
	var slider = $Control/VBoxContainer/Sound/HSlider
	slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	
	var fullscreen = $Control/VBoxContainer/Fullscreen/CheckButton
	fullscreen.pressed = OS.is_window_fullscreen()
	
	var VSync = $Control/VBoxContainer/VSync/CheckButton
	VSync.pressed = OS.is_vsync_enabled()
	
	var battery = $Control/VBoxContainer/Battery/CheckButton
	battery.pressed = OS.is_in_low_processor_usage_mode()
	
func _on_Back_pressed():
	queue_free()


func _on_CheckButton_toggled(button_pressed):
	OS.set_window_fullscreen(button_pressed)


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_CheckButton_toggled_VSync(button_pressed):
	OS.set_use_vsync(button_pressed)


func _on_CheckButton_toggled_battery(button_pressed):
	OS.set_low_processor_usage_mode(button_pressed)


func _on_Credits_pressed():
	$Control/WindowDialog.popup_centered()
