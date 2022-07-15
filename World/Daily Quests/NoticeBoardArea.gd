extends Area2D

var nearby = false;
var is_open = false;
var noticeboard = null;

func _on_NoticeBoard_body_entered(body):
	if body.name == "Player":
		nearby = true


func _on_NoticeBoard_body_exited(body):
	if body.name == "Player":
		nearby = false
		
func _input(event):
	if event.is_action_pressed("interact") && nearby && !is_open:
		is_open = true
		open_noticeboard()
	elif event.is_action_pressed("interact") && nearby && is_open:
		is_open = false
		close_noticeboard()

func open_noticeboard():
	get_tree().paused = true
	noticeboard = load("res://World/Daily Quests/NoticeBoard.tscn").instance()
	get_tree().get_root().add_child(noticeboard)

func close_noticeboard():
	get_tree().paused = false
	noticeboard.queue_free()
