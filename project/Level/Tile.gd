extends Spatial

signal mouse_entered
signal mouse_exited
signal clicked

const TURRET_COST := 300

export var selectable := true
export(Material) var default_material : Material
export(Material) var hover_material : Material
export(Material) var unselectable_material : Material

var hovered := false setget _set_hovered

var _defense : Spatial

onready var _box := $CSGBox
onready var _defense_slot := $Defense
onready var _preview_slot := $Preview

func _ready():
	_box.material = default_material if selectable else unselectable_material


func add_defense(defense:Spatial)->void:
	assert(_defense_slot.get_child_count()==0)
	_defense_slot.add_child(defense)


func add_preview(preview:Spatial)->void:
	assert(_preview_slot.get_child_count()==0)
	assert(is_instance_valid(preview))
	_preview_slot.add_child(preview)


func remove_preview()->void:
	assert(_preview_slot.get_child_count()==1)
	_preview_slot.remove_child(_preview_slot.get_child(0))


func has_defense()->bool:
	return _defense_slot.get_child_count() > 0


func _on_StaticBody_mouse_entered():
	if selectable and not has_defense():
		emit_signal("mouse_entered")


func _on_StaticBody_mouse_exited():
	if selectable:
		emit_signal("mouse_exited")


func _set_hovered(value:bool)->void:
	hovered = value
	_box.material = hover_material if hovered else default_material


func _on_StaticBody_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton \
		and event.pressed \
		and selectable:
		
		emit_signal('clicked')
		

func _remove_children_from(node:Node)->void:
	while node.get_child_count()>0:
		node.remove_child(node.get_child(0))
