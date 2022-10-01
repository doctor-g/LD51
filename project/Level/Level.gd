extends Spatial
tool

const _Tile := preload("res://Level/Tile.tscn")
const _PATH := [
	Vector2(0,9),
	Vector2(1,9),
	Vector2(2,9),
	Vector2(3,9),
	Vector2(4,9),
	Vector2(5,9),
	Vector2(6,9),
	Vector2(7,9),
	Vector2(8,9),
	Vector2(9,9),
	Vector2(9,8),	
	Vector2(9,7),
	Vector2(9,6),
	Vector2(9,5),
	Vector2(8,5),
	Vector2(7,5),
	Vector2(6,5),
	Vector2(5,5),
	Vector2(5,4),
	Vector2(5,3),
	Vector2(5,2),
	Vector2(5,1),
	Vector2(5,0),
	Vector2(5,-1)
]

const width := 11
const height := 11

func _enter_tree():
	# warning-ignore:integer_division
	var min_x := -width / 2
	# warning-ignore:integer_division
	var min_z := -height / 2
	
	for i in width:
		for j in height:
			var tile : Spatial = _Tile.instance()
			add_child(tile)
			tile.translation = Vector3(min_x+i, 0, min_z+j)
	#		print(tile.translation)
			if _PATH.find(Vector2(i,j)) >= 0:
				tile.selectable = false
				
	var base : Spatial = preload("res://Level/Base.tscn").instance()
	base.translation= Vector3(0, 0, min_z-1)
	add_child(base)
	

func _ready():
	var path := Path.new()
	
	# Put the path node in the upper-left corner 
	# so that it will account from the _PATH coordinates.
	#
	# warning-ignore:integer_division
	# warning-ignore:integer_division	
	path.translation = Vector3(-width/2, 0 ,-height/2)
	for point in _PATH:
		path.curve.add_point(Vector3(point.x, 0, point.y))
	add_child(path)
	var path_follow := PathFollow.new()
	path.add_child(path_follow)
	var sphere :Spatial = preload("res://Enemies/Sphere.tscn").instance()
	path_follow.add_child(sphere)
	
	var tween := get_tree().create_tween()
	# warning-ignore:return_value_discarded
	tween.tween_property(path_follow, 'unit_offset', 1.0, 5.0)
	
	
