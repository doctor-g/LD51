extends Spatial
tool

const _Tile := preload("res://Level/Tile.tscn")

const _ENEMY_SPAWN_POINT := Vector2(-1,9)

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

var _path := Path.new()
var _preview_mesh : Spatial
var _defenses := []


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
				
			# warning-ignore:return_value_discarded
			tile.connect("mouse_entered", self, "_on_Tile_mouse_entered", [tile])
			# warning-ignore:return_value_discarded
			tile.connect("mouse_exited", self, "_on_Tile_mouse_exited", [tile])
			# warning-ignore:return_value_discarded			
			tile.connect("clicked", self, "_on_Tile_clicked", [tile])
			
				
	var base : Spatial = preload("res://Level/Base.tscn").instance()
	base.translation= Vector3(0, 0, min_z-1)
	add_child(base)
	

func _ready():
	# warning-ignore:return_value_discarded
	Global.connect("meteor_timer_timeout", self, "_on_MeteorTimer_timeout")	
	
	# Put the path node in the upper-left corner 
	# so that it will account from the _PATH coordinates.
	#
	# warning-ignore:integer_division
	# warning-ignore:integer_division	
	_path.translation = Vector3(-width/2, 0 ,-height/2)
	for point in _PATH:
		_path.curve.add_point(Vector3(point.x, 0, point.y))
	add_child(_path)


func _on_SpawnTimer_timeout():
	var path_follow := PathFollow.new()
	_path.add_child(path_follow)
	var sphere :Spatial = preload("res://Enemies/Sphere.tscn").instance()
	path_follow.add_child(sphere)

	var tween := get_tree().create_tween()
	# warning-ignore:return_value_discarded
	tween.tween_property(path_follow, 'unit_offset', 1.0, 5.0)


func _on_Tile_mouse_entered(tile:Spatial)->void:
	tile.hovered = true
	
	if _preview_mesh==null:
		_preview_mesh = preload("res://Defenses/TurretModel.tscn").instance()
		_preview_mesh.preview = true
	
	tile.add_preview(_preview_mesh)


func _on_Tile_mouse_exited(tile:Spatial)->void:
	if is_instance_valid(_preview_mesh) and _preview_mesh.get_parent():
		tile.remove_preview()
	tile.hovered = false


func _on_Tile_clicked(tile:Spatial)->void:
	var TURRET_COST := 300
	# TODO: Extract cost
	if not tile.has_defense() and Global.resources > TURRET_COST:
		var turret : Spatial = preload("res://Defenses/Turret.tscn").instance()
		turret.rotation = _preview_mesh.rotation
		tile.add_defense(turret)
		Global.resources -= TURRET_COST
		_preview_mesh.queue_free()
		_preview_mesh = null
		_defenses.append(turret)


func _on_MeteorTimer_timeout()->void:
	if _defenses.size()>0:
		var index := randi() % _defenses.size()
		var defense :Spatial = _defenses[index]
		
		var meteor : Spatial = preload("res://Meteor/Meteor.tscn").instance()
		meteor.translation = Vector3(0,20,0)
		add_child(meteor)
		
		# warning-ignore:return_value_discarded
		var tween := get_tree().create_tween()
		tween.tween_property(meteor, 'global_translation', defense.global_translation, 1)
		# warning-ignore:return_value_discarded
		tween.set_ease(Tween.EASE_OUT)
		# warning-ignore:return_value_discarded
		tween.tween_callback(self, '_on_Meteor_struck', [meteor,index])


func _on_Meteor_struck(meteor:Spatial, defense_index:int)->void:
	meteor.queue_free()
	var defense :Spatial = _defenses[defense_index]
	_defenses.remove(defense_index)
	defense.queue_free()
