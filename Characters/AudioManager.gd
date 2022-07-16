extends Node

# load audio
onready var walking_on_grass = get_as_AudioStream("res://Assets/Sounds/Impact/footstep_grass_004.ogg")
onready var climbing = get_as_AudioStream("res://Assets/Sounds/RPG/footstep05.ogg")

# audio
func play_footsteps(state):
	var parent = get_parent();
	
	# match state:
		# parent.WALK:
		#	set_stream(walking_on_grass)
		#	set_pitch_scale(1)
		# parent.RUN:
		#	set_stream(walking_on_grass)
		#	set_pitch_scale(2)
		# parent.CLIMB:
		#	set_stream(climbing)
		#	set_pitch_scale(1)
	#play()
	#yield(get_tree().create_timer(1.5), "timeout")
	#stop()

func play_attack():
	# should be enemy hurt sound? res://Assets/Sounds/Impact/impactPunch_medium_000.ogg
	setup_audioPlayer("res://Assets/Sounds/RPG/knifeSlice.ogg", 1)
	
func play_death():
	setup_audioPlayer("res://Assets/Sounds/Voiceover/Fighter/game_over.ogg", 1)

func play_no_stamina():
	setup_audioPlayer("res://Assets/Sounds/Interface/error_001.ogg", 1)

func play_heal():
	setup_audioPlayer("res://Assets/Sounds/Heal-Sound-Effect.ogg", 1)

func play_hurt():
	setup_audioPlayer("res://Assets/Sounds/hurtSound.ogg", 1)

func setup_audioPlayer(path, pitch):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.set_pitch_scale(pitch)
	audioPlayer.set_stream(get_as_AudioStream(path))
	audioPlayer.play()
	audioPlayer.connect("finished", self, "_free", [audioPlayer])
	add_child(audioPlayer)
	
func get_as_AudioStream(path):
	var file = File.new()
	if file.file_exists(path):
		file.open(path, file.READ)
		var buffer = file.get_buffer(file.get_len())
		var stream = AudioStreamOGGVorbis.new()
		stream.data = buffer
		return stream;
	else:
		return null;

func _free(audioPlayer):
	remove_child(audioPlayer)
