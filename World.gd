extends Node2D

const dots_path = "res://dots/"

onready var dots_holder = $Dots

var counted_done = 0

var h = GlobalVars.height
var w = GlobalVars.width

func _ready():
	Events.connect("done_moving", self, "_on_dot_done_moving")
	Events.connect("dots_done_moving", self, "_dots_done_moving")
	Events.connect("turn_over", self, "_move_dots")
#	Events.connect("level_initialized", self, "_move_dots")
	spawn_dots()


func spawn_dots(library: Array = Leveldata.dots):
	var lib_size = library.size()
	for wi in w:
		for hi in h:
			var current_row_item
			var new_dot : dot = choose_random_dot(lib_size, library)
			if GlobalVars.turns_used != 0:  # if its the first turn, the arrays will be empty, and i dont want to pad them with 0
				current_row_item = EntityTracker.rows[hi][wi]
				if typeof(current_row_item) != TYPE_INT:
					continue
			else:
				EntityTracker.rows[hi].append(new_dot)
			dots_holder.add_child(new_dot)
			var offset = Vector2(GlobalVars.size.x * wi, GlobalVars.size.y * hi)
			var new_pos = ($Corners/Position2D.global_position + offset).snapped(GlobalVars.size)
			new_dot._initial_move(new_pos)
			EntityTracker.rows[hi][wi] = new_dot
	Events.emit_signal("level_initialized")

func choose_random_dot(lib_size, library) -> Node2D:
	randomize()
	var rand_number = randi() % lib_size
	var new_dot = library[rand_number].instance()
	return new_dot


func _on_dot_done_moving():
	counted_done += 1
	if counted_done >= (w * h):
		Events.emit_signal("dots_done_moving")
		GlobalVars.state = GlobalVars.states.player_turn
		print("dots done")


func _dots_done_moving():
	pass

func _move_dots():
	for item in EntityTracker.rows:
		print(item)
		yield(get_tree(), "idle_frame")
	counted_done = 0
	for row in EntityTracker._flip_rows(): # go through the tree from the bottom up
		for Dot in row:
			if Dot is dot:
				Dot.move(true) # move the collisions dow, and only the collisions
				yield(get_tree(), "idle_frame")
	spawn_dots() # spawn in the dots, once
	for row in EntityTracker._flip_rows(): # same as above, but this time move the sprites too
		for Dot in row:
			if Dot is dot:
				Dot.move()
	
	
