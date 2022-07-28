extends Node


func find(_quest: Quest) -> Quest:
	# Finds a quest by reference and returns it
	for quest in get_children():
		if quest != null && quest.name.find(_quest.name) != -1:
			return quest
	return null


func get_quests() -> Array:
	return get_children()
