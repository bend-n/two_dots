extends CanvasLayer

var pressed = false setget set_pressed

var nodes_with_points = []

onready var line = $Line2D

func _pressed(event : InputEvent, node : dot):
	if not GlobalVars.state == GlobalVars.states.player_turn:
		return
	print("aloh")
	if line.get_point_count() > 0:
		if node.color == line.default_color:
			if not node in nodes_with_points:
#					line.remove_point(line.get_point_count() - 1) # remove the last points
				set_physics_process(false)
				yield(get_tree(), "idle_frame")
				line.add_point(node.position + GlobalVars.size / 2)
				nodes_with_points.append(node)
				set_physics_process(true)
	elif event.is_action("click") and event.is_pressed():
		pressed = true
		line.clear_points()
		nodes_with_points.clear()
		nodes_with_points.append(node)
		line.add_point(node.position + GlobalVars.size / 2) # add a point in the center of the dot
		line.add_point(line.get_global_mouse_position())
		line.default_color = node.color
	
func _physics_process(_delta):
	if line.get_point_count() > 0:
		if Input.is_action_pressed("click") and pressed == true:
			line.remove_point(line.get_point_count() - 1)
			line.add_point(line.get_global_mouse_position())
		elif line.get_point_count() > 2:
			line.clear_points()
		else:
			line.clear_points()
			nodes_with_points.clear()
			pressed = false

func set_pressed(new_pressed):
	pressed = new_pressed
	set_physics_process(pressed)
