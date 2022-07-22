extends Control
class_name QuestJournal

signal updated

onready var tree := $Column/Tree

export var active_icon: Texture
export var inactive_icon: Texture
export var completed_icon: Texture
export var objective_completed: Texture
export var objective_uncompleted: Texture

var tree_root: TreeItem
var active := false


func _ready() -> void:
	set_signals()
	tree.set_hide_root(true)
	tree_root = tree.create_item()

func set_signals():
	for quest in QuestSystem.get_available_quests():
		if !quest.is_connected("started", self, "_on_quest_started"):
			quest.connect("started", self, "_on_quest_started", [quest])
		if !quest.is_connected("completed", self, "_on_quest_completed"):
			quest.connect("completed", self, "_on_quest_completed", [quest])
		if !quest.is_connected("delivered", self, "_on_quest_delivered"):
			quest.connect("delivered", self, "_on_quest_delivered", [quest])
		print_debug(quest.name)

func _on_quest_started(quest: Quest) -> void:
	var quest_root = _add_tree_item(tree_root, quest.title, active_icon, quest)
	#warning-ignore:return_value_discarded
	_add_tree_item(quest_root, quest.description)
	
	for reward_text in quest.get_rewards_as_text():
		#warning-ignore:return_value_discarded
		_add_tree_item(quest_root, reward_text)
		
	for objective in quest.get_objectives():
		#warning-ignore:return_value_discarded
		objective.connect("updated", self, "_on_Objective_updated")
		#warning-ignore:return_value_discarded
		objective.connect("completed", self, "_on_Objective_completed")
		
		_add_tree_item(
			quest_root,
			objective.as_text(),
			objective_completed if objective.completed else objective_uncompleted,
			objective
		)
	
	emit_signal("updated")


func _add_tree_item(
	root: TreeItem,
	text: String,
	icon: Texture = null,
	metadata = null,
	selectable: bool = false,
	collapsed: bool = true
) -> TreeItem:
	var item = tree.create_item(root)
	item.set_icon(0, icon)
	item.set_text(0, text)
	item.set_selectable(0, selectable)
	item.collapsed = collapsed
	if metadata != null:
		item.set_metadata(0, metadata)
	return item


func _on_Objective_updated(objective: QuestObjective) -> void:
	var objective_item = _find_objective_tree_item(objective)
	if objective_item == null:
		return
	objective_item.set_text(0, objective.as_text())


func _on_Objective_completed(objective: QuestObjective) -> void:
	var objective_item = _find_objective_tree_item(objective)
	if objective_item == null:
		return
	objective_item.set_icon(0, objective_completed)
	objective_item.set_text(0, objective.as_text())


func _on_quest_completed(quest: Quest) -> void:
	var quest_item = _find_quest_tree_item(quest)
	if quest_item == null:
		return
	quest_item.set_icon(0, completed_icon)
	emit_signal("updated")


func _on_quest_delivered(quest: Quest) -> void:
	var quest_item = _find_quest_tree_item(quest)
	if quest_item == null:
		return
	quest_item.set_icon(0, inactive_icon)
	emit_signal("updated")


func _find_quest_tree_item(quest: Quest) -> TreeItem:
	var quest_item = tree_root.get_children()
	while quest_item != null:
		if quest_item.get_metadata(0) == quest:
			return quest_item
		quest_item = quest_item.get_next()
	return null


func _find_objective_tree_item(objective: QuestObjective) -> TreeItem:
	var quest_item = tree_root.get_children()
	while quest_item != null:
		var objective_item = quest_item.get_children()
		while objective_item != null:
			if (
				objective_item.get_metadata(0) != null
				and objective_item.get_metadata(0) == objective
			):
				return objective_item
			objective_item = objective_item.get_next()
		quest_item = quest_item.get_next()
	return null
