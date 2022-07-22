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
			elif file_name.find(".import") != -1:
				pass
			elif prev_played == file_name:
				pass
			else:
				if rng.randf_range(0, 100) < 20:
					prev_played = file_name
					return get_as_AudioStreamMp3(background_music_path + file_name);
			file_name = dir.get_next()

func get_as_AudioStreamMp3(path):
	var file = File.new()
	if file.file_exists(path):
		file.open(path, file.READ)
		var buffer = file.get_buffer(file.get_len())
		var stream = AudioStreamMP3.new()
		stream.data = buffer
		return stream;
	else:
		return null;

func get_as_AudioStreamOGG(path):
	var file = File.new()
	if file.file_exists(path):
		file.open(path, file.READ)
		var buffer = file.get_buffer(file.get_len())
		var stream = AudioStreamOGGVorbis.new()
		stream.data = buffer
		return stream;
	else:
		return null;
