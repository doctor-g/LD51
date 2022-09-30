extends Spatial

export var selectable := true
export(Material) var default_material : Material
export(Material) var hover_material : Material
export(Material) var unselectable_material : Material

onready var _box := $CSGBox

func _ready():
	_box.material = default_material if selectable else unselectable_material


func _on_StaticBody_mouse_entered():
	if selectable:
		_box.material = hover_material


func _on_StaticBody_mouse_exited():
	if selectable:
		_box.material = default_material
