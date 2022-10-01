extends Spatial

export var health := 100.0
export var points := 100

func damage(amount:float)->void:
	health -= amount
	if health <= 0:
		PlayerStats.score += points
		queue_free()
