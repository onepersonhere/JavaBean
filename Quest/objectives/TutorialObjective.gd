extends QuestObjective

var stage = "skipped"

func as_text() -> String:
	return "Stage: " + stage

func set_stage(_stage):
	self.stage = _stage;
	emit_signal("updated", self)
	
	if stage == "completed":
		finish()

func get_stage():
	return stage
