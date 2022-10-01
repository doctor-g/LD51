extends Spatial

export var selectable := true
export(Material) var default_material : Material
export(Material) var hover_material : Material
export(Material) var unselectable_material : Material

var _defense : Spatial

onready var _box := $CSGBox

func _ready():
	_box.material = default_material if selectable else unselectable_material


func _on_StaticBody_mouse_entered():
	if selectable:
		_box.material = hover_material


func _on_StaticBody_mouse_exited():
	if selectable:
		_box.material = default_material


func _on_StaticBody_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed and _defense==null:
		var turret : Spatial = preload("res://Defenses/Turret.tscn").instance()
		turret.translate(Vector3(0,0.5,0))
		add_child(turret)
		_defense = turret
