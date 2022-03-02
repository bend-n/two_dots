extends Node

var rows = []


func _ready():
	for h in GlobalVars.height:
		rows.append([])


func _flip_rows() -> Array:
	var new_rows = rows
	new_rows.invert()
	return new_rows
