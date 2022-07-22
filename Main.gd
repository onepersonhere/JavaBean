extends Node

func _ready():
	OS.center_window()
	if GlobalVar.prev_played != "":
		# reload every thing
		reset_quest_system()
		reset_global_var()

func reset_quest_system():
	QuestSystem.reset()

func reset_global_var():
	GlobalVar.new_game = true
	GlobalVar.nft_addr = ""
