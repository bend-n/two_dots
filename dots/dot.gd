extends Node2D
class_name dot

onready var dotcollider : CollisionShape2D = $dot_collisions/dotcollider
onready var dotcollisions : Area2D = $dot_collisions
onready var ray : RayCast2D = $dot_collisions/dotray
onready var dotsprite : Sprite = $dotsprite

var tween = Tween.new()
var initial = true

var prev_go_to

export(GlobalVars.type) var dot_type

func _ready():
	add_child(tween)

func move(collision_only = false):
	ray.force_raycast_update()
	var go_to = Vector2(global_position.x, ray.get_collision_point().y - 35)
	if collision_only:
		dotcollisions.global_position = go_to
		prev_go_to = go_to
		return
	else: # cuz the ray moves too you see
		go_to = prev_go_to
	tween_item_position(dotsprite, dotsprite.global_position, go_to, .25)
	# log motion into entity tracker
	for rows in EntityTracker.rows:
		var i = rows.find(self)
		if i != -1:
			rows[i] = 0
	yield(tween, "tween_all_completed")
	Events.emit_signal("done_moving")

func tween_item_position(node, old, new, length):
	tween.interpolate_property(node, "global_position",
			old, new, length,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _initial_move(position):
	var parameters = [self, Vector2(position.x, -200), position, 2]
#	global_position = parameters[1]
	tween_item_position(parameters[0], parameters[1], parameters[2], parameters[3])
	yield(tween, "tween_all_completed")
	Events.emit_signal("done_moving")

func turn_off_collision():
	dotcollider.disabled = true

# warning-ignore-all:unused_argument
func _on_dot_input(viewport, event : InputEvent, shape_idx):
	InputHandler._pressed(event, self)
