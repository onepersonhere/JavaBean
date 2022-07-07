extends Action
class_name CompleteQuestAction

export var quest_reference: PackedScene
var quest: Quest = null

func _ready() -> void:
	assert(quest_reference)
	if not is_quest_in_progress():
		quest = QuestSystem.find_available(quest_reference.instance())
	else:
		quest = QuestSystem.find_active(quest_reference.instance())
	
	active = false
	quest.connect("completed", self, "_on_Quest_completed")

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
