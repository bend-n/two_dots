extends CanvasLayer

var pressed = false

var nodes_with_points = []
var current_color : Color
var current_point = Vector2()

onready var line = $Line2D

func _ready():
	$to_mouse_line._setup(self, line)

func _pressed(event: InputEvent, node: dot):
	if not GlobalVars.state == GlobalVars.states.player_turn:
		return
	if not event is InputEventMouse:
		return
	var node_center = node.dotcollisions.global_position
	if (
		line.get_point_count() > 0
		and node.color == current_color
		and not node in nodes_with_points
		and node.global_position.distance_to(current_point) == 70
	):
		print(node.global_position.distance_to(current_point))
		line.add_point(node_center)
		
		nodes_with_points.append(node)
	elif event.is_action("click") and event.is_pressed() and pressed == false:  # on first click
		pressed = true
		line.clear_points()
		nodes_with_points.clear()
		nodes_with_points.append(node)
		line.add_point(node_center)
		line.default_color = node.color
		current_color = node.color


func _physics_process(_delta):
	if line.get_point_count() > 0:
		current_point = line.get_point_position(line.get_point_count() - 1)
		if not Input.is_action_pressed("click"):
			# clear up the entity tracker
			if line.get_point_count() > 2:
				for node in nodes_with_points:
					for height in EntityTracker.rows:
						var i = height.find(node) # look for node in rows
						if i != -1:
							height[i] = 0
							node.queue_free()
							break
				Events.emit_signal("turn_over")
				GlobalVars.state = GlobalVars.states.level_turn
				GlobalVars.turns_used += 1
			line.clear_points()
			nodes_with_points.clear()
			pressed = false
