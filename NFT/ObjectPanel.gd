extends Panel

onready var texture: Sprite = $Image
onready var description: RichTextLabel = $RichTextLabel
onready var buy_link
onready var view_link 

func _ready():
	pass

func _on_Buy_pressed():
	OS.shell_open(buy_link) # open buy_link


func _on_View_pressed():
	OS.shell_open(view_link) # open view_link

func enable():
	$Buy.disabled = false
	$View.disabled = false
