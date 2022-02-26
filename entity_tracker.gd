extends Node

var rows = []

func _ready():
	for w in GlobalVars.width:
		rows.append([])
