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
	
func gain_exp(value):
	if value >= MAX_EXP - CURRENT_EXP:
		var surplus = value - (MAX_EXP - CURRENT_EXP)
		LEVEL += 1
		$Count/Background/Number.text = str(int(LEVEL))
		CURRENT_EXP = 0
		MAX_EXP = floor(BASE_EXP * (pow(int(LEVEL), EXPONENT)))
		$TextureProgress.value = CURRENT_EXP
		$TextureProgress.max_value = MAX_EXP
		$Count/Background/Progress.text = str(CURRENT_EXP) + "/" + str(MAX_EXP)
		gain_exp(surplus)
		gain_stats()
	else:
		CURRENT_EXP += value
		$TextureProgress.value = CURRENT_EXP
		$Count/Background/Progress.text = str(CURRENT_EXP) + "/" + str(MAX_EXP)
		
	#update the PlayerStats
	PlayerStats.CURR_EXP = CURRENT_EXP
	PlayerStats.LEVEL = LEVEL
	PlayerStats.MAX_EXP = MAX_EXP

func gain_stats():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var i = rand.randi_range(0,2);
	
	var audio = AudioStreamPlayer.new()
	audio.set_stream(GlobalVar.get_as_AudioStreamOGG("res://Assets/Sounds/Voiceover/Male/level_up.ogg"))
	add_child(audio)
	audio.play()
	
	var audio2 = AudioStreamPlayer.new()
	match i:
		0:
			PlayerStats.STRENGTH += 1;
			audio2.set_stream(GlobalVar.get_as_AudioStreamMp3("res://Assets/Sounds/Voiceover/Strength-up_.mp3"))
		1:
			PlayerStats.DEXTERITY += 1;
			audio2.set_stream(GlobalVar.get_as_AudioStreamMp3("res://Assets/Sounds/Voiceover/Dexterity-up_.mp3"))
		2:
			PlayerStats.INTELLIGENCE += 1;
			audio2.set_stream(GlobalVar.get_as_AudioStreamMp3("res://Assets/Sounds/Voiceover/Intelligence-up__1.mp3"))
	add_child(audio2)
	PlayerStats.refresh_base_stats();
	
	# clean up
	yield(audio, "finished")
	audio.queue_free()
	audio2.play()
	yield(audio2, "finished")
	audio2.queue_free()
