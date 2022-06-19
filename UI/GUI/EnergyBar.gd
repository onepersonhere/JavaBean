extends HBoxContainer

var RECHARGE = 10
var CURRENT_SP = 20
var MAX_SP = 20
onready var timer = $Timer
onready var timer2 = $Timer2

func _ready():
	timer.set_wait_time(0.1)
	timer2.set_wait_time(2)
	timer2.one_shot = true
	$Count/Background/Number.text = str(int(CURRENT_SP))
	$TextureProgress.value = CURRENT_SP
	$TextureProgress.max_value = MAX_SP

func sprint(value):
	timer.stop()
	timer2.stop()
	if value >= CURRENT_SP:
		CURRENT_SP = 0
	else:
		CURRENT_SP -= value
	$Count/Background/Number.text = str(int(CURRENT_SP))
	$TextureProgress.value = CURRENT_SP
	
func recharge(value):
	if value >= MAX_SP - CURRENT_SP:
		CURRENT_SP = MAX_SP
		timer.stop()
	else:
		CURRENT_SP += value
	$Count/Background/Number.text = str(int(CURRENT_SP))
	$TextureProgress.value = CURRENT_SP

func stopped():
	timer2.start()

func _on_Timer_timeout():
	recharge(RECHARGE / 10)

func _on_Timer2_timeout():
	recharge(RECHARGE / 10)
	timer.start()
