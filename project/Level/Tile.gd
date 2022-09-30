extends Spatial

export(Material) var default_material : Material
export(Material) var hover_material : Material

onready var _box := $CSGBox

func _ready():
	_box.material = default_material


func _on_StaticBody_mouse_entered():
	_box.material = hover_material


func _on_StaticBody_mouse_exited():
	_box.material = default_material
