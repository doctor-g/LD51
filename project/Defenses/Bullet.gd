extends KinematicBody

signal struck_enemy

export var damage := 10

const _SPEED := 10


func _physics_process(delta):
	var velocity = (Vector3.FORWARD * _SPEED).rotated(Vector3.UP, global_rotation.y)
	var collision := move_and_collide(velocity*delta)
	if collision:
		collision.collider.damage(damage)
		emit_signal("struck_enemy", collision.position)
		queue_free()


func _on_LifetimeTimer_timeout():
	queue_free()
