extends Spatial
tool

const _Sphere := preload("res://Enemies/Sphere.tscn")

enum Mode { BEAM, DEFENSE }

const _Tile := preload("res://Level/Tile.tscn")

const _ENEMY_SPAWN_POINT := Vector2(-1,9)
const _SHARD_FORCE := 100
const _METEOR_FALL_DURATION := 1.2

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
	
	Vector2(4,5),
	Vector2(3,5),
	Vector2(3,4),
	Vector2(3,3),
	Vector2(4,3),
	Vector2(5,3),
	
	Vector2(5,2),
	Vector2(5,1),
	Vector2(5,0),
	Vector2(5,-1)
]

const width := 11
const height := 11

var is_running := true

var _base : Spatial
var _path := Path.new()
var _preview_mesh : Spatial
var _defenses := []
var _enemies := []

# Single-selection model for the tile
var _tile : Spatial
var _mode = Mode.DEFENSE
var _mouse_pos : Vector3

onready var _shards := $Shards
onready var _beam := preload("res://Beam/Beam.tscn").instance()


func _enter_tree():
	# warning-ignore:integer_division
	var min_x := -width / 2
	# warning-ignore:integer_division
	var min_z := -height / 2
	
	var tiles_node := $Tiles
	
	for i in width:
		for j in height:
			var tile : Spatial = _Tile.instance()
			tiles_node.add_child(tile)
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
			# warning-ignore:return_value_discarded
			tile.connect("mouse_moved", self, "_on_Tile_mouse_moved")
			
				
	_base = preload("res://Level/Base.tscn").instance()
	_base.translation= Vector3(0, 0, min_z-1)
	add_child(_base)
	

func _ready():
	# warning-ignore:return_value_discarded
	_base.connect("destroyed", self, "_on_Base_destroyed")
	
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
	
	
func _process(_delta):
	if not Engine.is_editor_hint():
		if Input.is_action_just_released("switch_mode"):
			if _mode == Mode.BEAM:
				remove_child(_beam)
				_mode = Mode.DEFENSE
				if _tile and not _tile.has_preview() and not _tile.has_defense():
					_show_preview(_tile)
			else:
				if _tile:
					_stop_hover(_tile)
				add_child(_beam)
				_beam.global_translation = _mouse_pos
				_mode = Mode.BEAM
		
		elif Input.is_action_just_pressed("meteor"):
			if _defenses.size()>0:
				_launch_meteor()


func _on_Base_destroyed()->void:
	is_running = false
	var loss_control := preload("res://UI/LossControl.tscn").instance()
	add_child(loss_control)
	get_tree().paused = true


func _spawn_sphere(sphere:Spatial):
	var path_follow := PathFollow.new()
	_path.add_child(path_follow)
	path_follow.add_child(sphere)
	_enemies.append(sphere)
	# warning-ignore:return_value_discarded
	sphere.connect("destroyed", self, "_on_Sphere_destroyed", [sphere])
	# warning-ignore:return_value_discarded
	sphere.connect("tree_exiting", self, "_on_Sphere_tree_exiting", [sphere])

	var tween := get_tree().create_tween()
	var duration :float = _path.curve.get_baked_length() / sphere.speed
	# warning-ignore:return_value_discarded
	tween.tween_property(path_follow, 'unit_offset', 1.0, duration)


func _on_Tile_mouse_entered(tile:Spatial)->void:
	_tile = tile
	if _mode==Mode.DEFENSE:
		_show_preview(tile)


func _show_preview(tile:Spatial)->void:
	tile.hovered = true
		
	if _preview_mesh==null:
		_preview_mesh = preload("res://Defenses/TurretModel.tscn").instance()
		_preview_mesh.preview = true
		
	tile.add_preview(_preview_mesh)


func _on_Tile_mouse_exited(tile:Spatial)->void:
	_stop_hover(tile)
	_tile = null
	
	
func _stop_hover(tile:Spatial):
	if is_instance_valid(_preview_mesh) and _preview_mesh.get_parent():
		tile.remove_preview()
	tile.hovered = false


func _on_Tile_clicked(tile:Spatial)->void:
	if _mode != Mode.DEFENSE:
		return
	
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
		
		# warning-ignore:return_value_discarded
		turret.connect("fired", self, "_on_Turret_fired")
		

func _on_Turret_fired(bullet:Spatial)->void:
	# warning-ignore:return_value_discarded
	bullet.connect("struck_enemy", self, "_on_Bullet_struck_enemy")


func _on_Bullet_struck_enemy(position:Vector3)->void:
	var particles :CPUParticles = preload("res://Defenses/BulletImpactParticles.tscn").instance()
	add_child(particles)
	particles.one_shot = true
	particles.global_translation = position
	yield(get_tree().create_timer(1), "timeout")
	particles.queue_free()


func _on_MeteorTimer_timeout()->void:
	if _defenses.size()>0:
		_launch_meteor()
		

func _launch_meteor()->void:
	var index := randi() % _defenses.size()
	var defense :Spatial = _defenses[index]
	
	var meteor : Spatial = preload("res://Meteor/Meteor.tscn").instance()
	meteor.translation = Vector3(0,7,0)
	add_child(meteor)
	
	var tween := get_tree().create_tween()
	# warning-ignore:return_value_discarded
	tween.tween_property(meteor, 'global_translation', defense.global_translation, _METEOR_FALL_DURATION)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
	# warning-ignore:return_value_discarded
	tween.tween_callback(self, '_on_Meteor_struck', [meteor,index])


func _on_Meteor_struck(meteor:Spatial, defense_index:int)->void:
	var defense :Spatial = _defenses[defense_index]
	
	var explosion :CPUParticles= preload("res://Meteor/DefenseExplosion.tscn").instance()
	add_child(explosion)
	explosion.global_translation = defense.global_translation
	explosion.one_shot = true
	meteor.queue_free()
	_defenses.remove(defense_index)
	defense.queue_free()
	_spawn_shards(3, defense.global_translation)
	
	yield(get_tree().create_timer(1.0), "timeout")
	explosion.queue_free()


func _on_Sphere_destroyed(sphere:Spatial)->void:
	_spawn_shards(sphere.shards, sphere.global_translation)
	var explosion :CPUParticles = preload("res://Enemies/EnemyExplosion.tscn").instance()
	explosion.one_shot = true
	add_child(explosion)
	explosion.global_translation = sphere.global_translation
	yield(get_tree().create_timer(1), "timeout")
	explosion.queue_free()
	

func _spawn_shards(count:int, location:Vector3)->void:
	for i in count:
		var shard : RigidBody = preload("res://Common/Shard.tscn").instance()
		shard.name = "Shard"
		_shards.add_child(shard)
		shard.global_translation = location + Vector3(0,0.5,0)
		shard.rotation = Vector3(randf(),randf(),randf()) * TAU
		shard.add_force(Vector3(1,1,0).rotated(Vector3.UP, randf()*TAU) * _SHARD_FORCE, Vector3.ZERO)



func _on_Sphere_tree_exiting(sphere:Spatial)->void:
	_enemies.remove(_enemies.find(sphere))


func _on_LiveShardArea_body_exited(body:PhysicsBody):
	if body is Shard:
		body.queue_free()


func _on_Tile_mouse_moved(position:Vector3)->void:
	_mouse_pos = position
	if _mode==Mode.BEAM:
		_beam.translation = position


func _on_SpeedySphereTimer_timeout():
	var sphere := _Sphere.instance()
	sphere.color = Color.red
	sphere.speed = 5
	sphere.max_health = 30
	sphere.shards = 1
	sphere.points = 30
	_spawn_sphere(sphere)
	_speed_up($SpeedySphereTimer)


func _speed_up(timer:Timer)->void:
	# Make the timer about 5% faster
	timer.wait_time = max(1.0, 0.95 * timer.wait_time)
	timer.start()


func _on_BigSlowTimer_timeout():
	var sphere := _Sphere.instance()
	sphere.color = Color.rebeccapurple
	sphere.speed = 2.5
	sphere.max_health = 100
	sphere.shards = 2
	sphere.points = 100
	_spawn_sphere(sphere)
	_speed_up($BigSlowTimer)


func _on_BehemothTimer_timeout():
	var sphere := _Sphere.instance()
	sphere.color = Color.peru
	sphere.speed = 1.5
	sphere.max_health = 500
	sphere.shards = 5
	sphere.points = 500
	_spawn_sphere(sphere)
	_speed_up($BehemothTimer)
