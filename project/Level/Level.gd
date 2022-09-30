extends Spatial
tool

const _Tile := preload("res://Level/Tile.tscn")

export var width := 10
export var height := 10

func _enter_tree():
	# warning-ignore:integer_division
	var min_x := -width / 2
	# warning-ignore:integer_division	
	var max_x := width / 2
	# warning-ignore:integer_division	
	var min_z := -height / 2
	# warning-ignore:integer_division	
	var max_z := height / 2
	
	for i in width:
		for j in height:
			var box : Spatial = _Tile.instance()
			add_child(box)
			box.translation = Vector3(lerp(min_x, max_x, float(i)/width), 0, lerp(min_z, max_z, float(j)/height))
			if j == 5:
				box.selectable = false
	
	
	
