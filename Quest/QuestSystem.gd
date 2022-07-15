extends Node


onready var available_quests = $Available
onready var active_quests = $Active
onready var completed_quests = $Completed
onready var delievered_quests = $Delivered

var player: Player

func initialise(game, _player: Player) -> void:
	game.connect("combat_started", self, "_on_Game_combat_started")
	player = _player
	
func find_available(reference: Quest) -> Quest:
	return available_quests.find(reference)

func get_available_quests() -> Array:
	return available_quests.get_quests()

func is_available(reference: Quest) -> bool:
	return available_quests.find(reference) != null

func start(reference: Quest):
	var quest: Quest = available_quests.find(reference)
	quest.connect("completed", self, "_on_Quest_completed", [quest])
	available_quests.remove_child(quest)
	active_quests.add_child(quest)
	quest._start()

func _on_Quest_completed(quest):
	print_debug("quest completed")
	active_quests.remove_child(quest)
	completed_quests.add_child(quest)
	
func deliver(quest: Quest):
	# used by other scripts to deliver the quest
	quest._deliver()
	var rewards = quest.get_rewards()
	# TODO: Tie in with curr inv system
	for item in rewards['items']:
		PlayerInventory.add_item(item.item_name, item.amount)
	
	assert (quest.get_parent() == completed_quests)
	completed_quests.remove_child(quest)
	delievered_quests.add_child(quest)

func _on_Game_combat_started() -> void:
	for quest in active_quests.get_quests():
		quest.notify_slay_objectives()
