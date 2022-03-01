extends Node

export(PoolColorArray) var dot_colors
export(Color) var background_color

func _ready():
	randomize()
	VisualServer.set_default_clear_color(background_color)

export(Array, PackedScene) var dots
