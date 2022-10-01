extends Area

const _SHARD_PICKUP_HEIGHT = 3
const _SHARD_PICKUP_SPEED = 1.5
const _Particles := preload("res://Beam/CollectionParticles.tscn")

var _attracting_shards := []

func _on_Beam_body_entered(body:RigidBody):
	if body is Shard and _attracting_shards.find(body)==-1:
		_attracting_shards.append(body)
		body.mode = RigidBody.MODE_KINEMATIC


func _on_Beam_body_exited(body:RigidBody):
	var index = _attracting_shards.find(body)
	if body is Shard and index != -1:
		_attracting_shards.remove(index)
		body.mode = RigidBody.MODE_RIGID


func _physics_process(delta):
	for shard in _attracting_shards:
		shard.global_translate(Vector3.UP * _SHARD_PICKUP_SPEED * delta)
		if shard.global_translation.y >= _SHARD_PICKUP_HEIGHT:
			var particles = _Particles.instance()
			add_child(particles)
			particles.global_translation = shard.global_translation
			particles.one_shot = true
			shard.queue_free()
			Global.resources += 50
			yield(get_tree().create_timer(0.5), "timeout")
			particles.queue_free()

