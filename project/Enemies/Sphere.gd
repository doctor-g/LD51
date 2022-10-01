extends Spatial

export var health := 100.0

func damage(amount:float)->void:
	health -= amount
	if health <= 0:
		queue_free()
