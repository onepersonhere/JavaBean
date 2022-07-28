extends Action
class_name CompleteQuestAction

export var quest_reference: PackedScene
var quest: Quest = null

func _ready() -> void:
	assert(quest_reference)
	if not is_quest_in_progress() && not is_quest_completed() && not is_quest_delivered():
		active = false
		quest = QuestSystem.find_available(quest_reference.instance())
		quest.connect("completed", self, "_on_Quest_completed")
	elif is_quest_in_progress():
		active = false
		quest = QuestSystem.find_active(quest_reference.instance())
		quest.connect("completed", self, "_on_Quest_completed")
	elif is_quest_completed():
		quest = QuestSystem.find_completed(quest_reference.instance())
		_on_Quest_completed()
	else:
		quest = QuestSystem.find_delivered(quest_reference.instance())
		_on_Quest_completed()

func _on_Quest_completed() -> void:
	active = true

func interact() -> void:
	if not active:
		emit_signal("finished")
		return
	QuestSystem.deliver(quest)
	active = false
	emit_signal("finished")

func is_quest_in_progress():
	return QuestSystem.is_active(quest_reference.instance())

func is_quest_completed():
	return QuestSystem.is_completed(quest_reference.instance())

func is_quest_delivered():
	return QuestSystem.is_delivered(quest_reference.instance())
