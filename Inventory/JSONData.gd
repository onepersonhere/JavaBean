extends Node

var item_data : Dictionary
var path = "res://Inventory/Data/ItemData.json"

func _ready():
	item_data = LoadData(path)

func LoadData(file_path):
	var json_data
	var file_data = File.new()
	# retrieve info from file
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	
	return json_data.result

func SaveData(file_path):
	var file_data = File.new()
	# save info
	file_data.open(file_path, File.WRITE)
	file_data.store_line(to_json(item_data))
	file_data.close()
