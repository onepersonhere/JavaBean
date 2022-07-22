extends HBoxContainer

signal no_health

var MAX_HEALTH = 100
var CURRENT_HEALTH = 100

func _ready():
	$Count/Background/Number.text = str(int(CURRENT_HEALTH))
	$TextureProgress.value = CURRENT_HEALTH
	
func deal_damage(value):
	if value >= CURRENT_HEALTH:
		CURRENT_HEALTH = 0
	else :
		CURRENT_HEALTH -= value
	$TextureProgress.value = CURRENT_HEALTH
	$Count/Background/Number.text = str(int(CURRENT_HEALTH))
	if CURRENT_HEALTH <= 0:
		emit_signal("no_health")
		
	PlayerStats.CURR_HEALTH = CURRENT_HEALTH
	PlayerStats.update()
		
func heal(value):
	if value >= MAX_HEALTH - CURRENT_HEALTH:
		CURRENT_HEALTH = MAX_HEALTH
	else:
		CURRENT_HEALTH += value
	$TextureProgress.value = CURRENT_HEALTH
	$Count/Background/Number.text = str(int(CURRENT_HEALTH))
	
	PlayerStats.CURR_HEALTH = CURRENT_HEALTH
	PlayerStats.update()
	
	
func is_full_health():
	return CURRENT_HEALTH == MAX_HEALTH

