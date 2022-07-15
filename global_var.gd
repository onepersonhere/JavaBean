extends Node

var nft_addr = ""
var new_game = true

func set_nft_addr(addr):
	self.nft_addr = addr;

func get_nft_addr():
	return nft_addr

func add_npc_as_child(npc_filepath, parent_path, pos_x, pos_y):
	var parent = get_node(parent_path);
	var npc = load(npc_filepath).instance();
	npc.set_position(Vector2(pos_x, pos_y));
	parent.add_child(npc)
