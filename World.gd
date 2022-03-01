extends Node2D

const dots_path = "res://dots/"

onready var dots_holder = $Dots

var counted_done = 0

var h = GlobalVars.height
var w = GlobalVars.width

func _ready():
	spawn_dots(Leveldata.dots)
	Events.connect("done_moving", self, "_on_dot_done_moving")
	Events.connect("dots_done_moving", self, "_dots_done_moving")

func spawn_dots(library : Array):
	var lib_size = library.size()
	for wi in w:
		for hi in h:
			var current_row_item
			if GlobalVars.turns_used != 0: # if its the first turn, the arrays will be empty, and i dont want to pad them with " "
				current_row_item = EntityTracker.rows[hi][wi]
				if current_row_item != 0:
					continue
			var new_dot = choose_random_dot(lib_size, library)
			EntityTracker.rows[hi].append(new_dot)
			dots_holder.add_child(new_dot)
			var offset = Vector2(GlobalVars.size.x * wi, GlobalVars.size.y * hi) 
			var new_pos = ($Corners/Position2D.global_position + offset).snapped(GlobalVars.size)
			new_dot.global_position = new_pos
	Events.emit_signal("level_initialized")

func choose_random_dot(lib_size, library) -> Array:
	randomize()
	var rand_number = randi() % lib_size
	var new_dot = library[rand_number].instance()
	return new_dot

func _on_dot_done_moving():
	counted_done += 1
	if counted_done >= (w * h):
		Events.emit_signal("dots_done_moving")
		GlobalVars.state = GlobalVars.states.player_turn

func _dots_done_moving():
	pass
