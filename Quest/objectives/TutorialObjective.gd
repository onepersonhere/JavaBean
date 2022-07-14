extends QuestObjective

var stage = "skipped"

func as_text() -> String:
	return "Location: " + stage

func set_stage(stage):
	self.stage = stage;
	emit_signal("updated", self)

func get_stage():
	return stage
