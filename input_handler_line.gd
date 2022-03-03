extends Node2D

var parent
var line

func _ready():
	set_process(false)

func _draw():
	if parent.pressed:
		draw_line(parent.current_point, get_global_mouse_position(), get_parent().current_color, line.width, true)

func _setup(_parent, _line):
	line = _line
	parent = _parent
	set_process(true)

func _process(_delta):
	update()
