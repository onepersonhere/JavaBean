extends Node

var nft_addr = ""
var new_game = true
var prev_played = ""

func set_nft_addr(addr):
	self.nft_addr = addr;

func get_nft_addr():
	return nft_addr

func add_npc_as_child(npc_filepath, parent_path, pos_x, pos_y):
	var parent = get_node(parent_path);
	var npc = load(npc_filepath).instance();
	npc.set_position(Vector2(pos_x, pos_y));
	parent.add_child(npc)

func random_background_music():
	var background_music_path = "res://Assets/Sounds/Music/Background/"
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var dir = Directory.new()
	if dir.open(background_music_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			elif !file_name.ends_with(".import"):
				pass
			elif prev_played == file_name:
				pass
			else:
				if rng.randf_range(0, 100) < 20:
					prev_played = file_name
					return get_as_AudioStream(background_music_path + file_name.replace(".import", ""));
			file_name = dir.get_next()
	else:
		print_debug("directory cannot be found")

func get_as_AudioStream(path):
	var file = File.new()
	if file.file_exists(path + ".import"):
		return load(path)
	else:
		return null;
