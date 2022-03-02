extends Node2D
class_name dot

onready var dotcollider : CollisionShape2D = $dot_collisions/dotcollider
onready var dotcollisions : Area2D = $dot_collisions
onready var ray : RayCast2D = $dot_collisions/dotray
onready var dotsprite : Sprite = $dotsprite

var tween = Tween.new()

export(GlobalVars.type) var dot_type

func _ready():
	add_child(tween)

func move():
	ray.force_raycast_update()
	var go_to = Vector2(global_position.x, ray.get_collision_point().y - 35)
	dotcollisions.global_position = go_to

	tween.interpolate_property(dotsprite, "global_position",
			dotsprite.global_position, go_to, .25,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	Events.emit_signal("done_moving")

func turn_off_collision():
	dotcollider.disabled = true

# warning-ignore-all:unused_argument
func _on_dot_input(viewport, event : InputEvent, shape_idx):
	InputHandler._pressed(event, self)
