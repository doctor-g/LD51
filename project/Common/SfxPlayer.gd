extends Node

onready var _plink_sound := $PlinkSound
onready var _random_generator := RandomNumberGenerator.new()

func play_plink():
	_plink_sound.pitch_scale = _random_generator.randfn(1.0, 0.15)
	_plink_sound.play()
