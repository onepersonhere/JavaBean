extends HBoxContainer

const BASE_EXP = 10
const EXPONENT = 1.5
var CURRENT_EXP = 0
var LEVEL = 1
var MAX_EXP = BASE_EXP

func _ready():
	$Count/Background/Progress.text = str(CURRENT_EXP) + "/" + str(MAX_EXP)
	$Count/Background/Number.text = str(int(LEVEL))
	$TextureProgress.value = CURRENT_EXP
	$TextureProgress.max_value = MAX_EXP
	
func level_up(surplus):
	LEVEL += 1
	$Count/Background/Number.text = str(int(LEVEL))
	CURRENT_EXP = surplus
	MAX_EXP = floor(BASE_EXP * (pow(int(LEVEL), EXPONENT)))
	$TextureProgress.value = CURRENT_EXP
	$TextureProgress.max_value = MAX_EXP
	$Count/Background/Progress.text = str(CURRENT_EXP) + "/" + str(MAX_EXP)
	
func gain_exp(value):
	if value >= MAX_EXP - CURRENT_EXP:
		level_up(value - (MAX_EXP - CURRENT_EXP))
	else:
		CURRENT_EXP += value
		$TextureProgress.value = CURRENT_EXP
		$Count/Background/Progress.text = str(CURRENT_EXP) + "/" + str(MAX_EXP)
