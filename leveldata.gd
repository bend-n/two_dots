extends Node

export(PoolColorArray) var dot_colors
export(Color) var background_color

func _ready():
	VisualServer.set_default_clear_color(background_color)
