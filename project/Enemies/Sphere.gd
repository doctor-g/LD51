extends Spatial

export var health := 100.0
export var points := 100
export var resources := 100

var _destroyed := false

func damage(amount:float)->void:
	health -= amount
	
	# This thing can be damaged more than once per frame,
	# so we have to separately keep track of whether it was
	# already destroyed.
	if health <= 0 and not _destroyed:
		PlayerStats.score += points
		PlayerStats.resources += resources
		_destroyed = true
		queue_free()
