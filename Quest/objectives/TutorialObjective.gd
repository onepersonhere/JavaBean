extends QuestObjective

var stage = "skipped"

func as_text() -> String:
	return "Stage: " + stage

func set_stage(stage):
	self.stage = stage;
	emit_signal("updated", self)
	
	if stage == "completed":
		finish()
		QuestSystem.deliver(get_parent().get_parent())

func get_stage():
	return stage
