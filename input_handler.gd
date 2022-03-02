extends CanvasLayer

var pressed = false setget set_pressed

var nodes_with_points = []

onready var line = $Line2D


func _pressed(event: InputEvent, node: dot):
	if not GlobalVars.state == GlobalVars.states.player_turn:
		return
	var node_center = node.dotcollisions.global_position
	if (
		line.get_point_count() > 0
		and node.color == line.default_color
		and not node in nodes_with_points
	):
		print("points", line.get_point_count())
		line.add_point(node_center)
		nodes_with_points.append(node)
	elif event.is_action("click") and event.is_pressed() and pressed == false:  # on first click
		pressed = true
		line.clear_points()
		nodes_with_points.clear()
		nodes_with_points.append(node)
		line.add_point(node_center)
		line.add_point(line.get_global_mouse_position())
		line.default_color = node.color


func _physics_process(_delta):
	if line.get_point_count() > 0:
		if Input.is_action_pressed("click") and pressed == true:
			move_last_point_to_mouse()
		else:
			line.clear_points()
			nodes_with_points.clear()
			pressed = false


func set_pressed(new_pressed):
	pressed = new_pressed
	set_physics_process(pressed)


func move_last_point_to_mouse():
	# get_point count counts from one, remove point counts from 0
	line.remove_point(line.get_point_count() - 1)
	line.add_point(line.get_global_mouse_position())
