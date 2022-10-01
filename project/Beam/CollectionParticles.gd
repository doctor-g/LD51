extends CPUParticles

onready var _sfx = $AudioStreamPlayer

func _ready():
	var random_generator = RandomNumberGenerator.new()
	_sfx.pitch_scale = random_generator.randfn(1, 0.15)
	_sfx.play()
