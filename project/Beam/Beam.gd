extends Area

const _SHARD_PICKUP_HEIGHT = 3
const _SHARD_PICKUP_SPEED = 1.5
const _Particles := preload("res://Beam/CollectionParticles.tscn")

var _attracting_shards := {}

onready var _sound := $BeamSound

func _on_Beam_body_entered(body:RigidBody):
	if body is Shard and not _attracting_shards.has(body):
		_attracting_shards[body] = _random_vector()
		body.mode = RigidBody.MODE_KINEMATIC
		_sound.play()


func _random_vector()->Vector3:
	return Vector3(randf(), randf(), randf()).normalized()


func _on_Beam_body_exited(body:RigidBody):
	if body is Shard and _attracting_shards.has(body):
		# warning-ignore:return_value_discarded
		_attracting_shards.erase(body)
		body.mode = RigidBody.MODE_RIGID
	
	if _attracting_shards.size()==0:
		_sound.stop()


func _physics_process(delta):
	for shard in _attracting_shards:
		shard.global_translate(Vector3.UP * _SHARD_PICKUP_SPEED * delta)
		shard.rotate(_attracting_shards[shard], PI*delta)
		
		if shard.global_translation.y >= _SHARD_PICKUP_HEIGHT:
			var particles = _Particles.instance()
			add_child(particles)
			particles.global_translation = shard.global_translation
			particles.one_shot = true
			shard.queue_free()
			Global.resources += 50
			yield(get_tree().create_timer(0.5), "timeout")
			particles.queue_free()

