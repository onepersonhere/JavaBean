extends Node
class_name QuestObjective

signal completed(objective)
#warning-ignore:unused_variable
signal updated(objective)

var completed: bool = false

func finish() -> void:
	completed = true
	emit_signal("completed", self)
	
func as_text() -> String:
	return "Objective %s as_text method should be overriden" % get_path()
