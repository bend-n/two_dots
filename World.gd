extends Node2D

const dots_path = "res://dots/"

onready var dots_holder = $Dots

var counted_done = 0

var h = GlobalVars.height
var w = GlobalVars.width

var dots = {
	"dot" : load(dots_path + "plain_dot.tscn"),
}

func _ready():
	spawn_dots(dots)
	Events.connect("done_moving", self, "_on_dot_done_moving")
	Events.connect("dots_done_moving", self, "_dots_done_moving")

func spawn_dots(library : Dictionary):
	var lib_size = library.keys().size()
	var lib_keys = library.keys()
	for wi in w:
		for hi in h:
			var current_row_item
			if GlobalVars.turns_used != 0: # if its the first turn, the arrays will be empty, and i dont want to pad them with " "
				current_row_item = EntityTracker.rows[hi][wi]
				if current_row_item != 0:
					continue
			var new_dot = choose_random_dot(lib_size, lib_keys, library)
			EntityTracker.rows[hi].append(new_dot)
			dots_holder.add_child(new_dot)
			var offset = Vector2(GlobalVars.size.x * wi, GlobalVars.size.y * hi) 
			var new_pos = ($Corners/Position2D.global_position + offset).snapped(GlobalVars.size)
			new_dot.global_position = new_pos
	Events.emit_signal("level_initialized")

func choose_random_dot(lib_size, lib_keys, library) -> Array:
	randomize()
	var rand_number = randi() % lib_size
	var lib_key = lib_keys[rand_number]
	var new_dot = library[lib_key].instance()
	return new_dot

func _on_dot_done_moving():
	counted_done += 1
	if counted_done >= (w * h):
		Events.emit_signal("dots_done_moving")
		GlobalVars.state = GlobalVars.states.player_turn

func _dots_done_moving():
	pass
