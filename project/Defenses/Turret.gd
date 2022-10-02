extends Spatial

signal fired(bullet)

export var dps := 20.0

# Bullets per second
export var firing_rate := 3.0

var _tracked_enemy : Spatial
var _random_generator := RandomNumberGenerator.new()
var _shooting := false


onready var _shoot_sound := $ShootSound
onready var _bullet_spawn_point := $BulletSpawnPoint
onready var _shot_timer := $ShotTimer


func _physics_process(_delta):
	if _tracked_enemy:
		_turn_toward_tracked_enemy()
		

func _turn_toward_tracked_enemy()->void:
	var target := _tracked_enemy.global_translation
	var source := global_translation
	# This will turn to face the target, only turning on the y axis.
	global_rotation.y = lerp_angle(global_rotation.y, atan2(source.x - target.x, source.z - target.z), 1)


func _on_Area_body_entered(body):
	_tracked_enemy = body
	_turn_toward_tracked_enemy()
	_shooting = true
	_shoot()
	

func _shoot()->void:
	var bullet :Spatial= preload("res://Defenses/Bullet.tscn").instance()
	add_child(bullet)
	bullet.global_translation = _bullet_spawn_point.global_translation
	bullet.global_rotation = _bullet_spawn_point.global_rotation
	bullet.set_as_toplevel(true)
	_play_shooting_sound()
	_shot_timer.start(1.0/firing_rate)
	emit_signal("fired", bullet)


func _on_Area_body_exited(body):
	if body==_tracked_enemy:
		_tracked_enemy = null
		_shooting = false


func _on_ShootSoundTimer_timeout():
	_play_shooting_sound()


func _play_shooting_sound():
	_shoot_sound.pitch_scale = _random_generator.randfn(1, 0.1)
	_shoot_sound.play()


func _on_ShotTimer_timeout():
	if _shooting:
		_shoot()
