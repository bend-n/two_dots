extends Area2D
class_name dot

onready var dotcollider : CollisionShape2D = $dotcollider
onready var ray : RayCast2D = $dotray

var tween = Tween.new()

export(GlobalVars.type) var dot_type

func _ready():
	Events.connect("level_initialized", self, "move")
	Events.connect("turn_over", self, "move")
	add_child(tween)

func move():
	var go_to = get_collision_point()
	print(go_to)
	tween.interpolate_property(self, "global_position",
			global_position, go_to, 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	Events.emit_signal("done_moving")

func get_collision_point() -> Vector2:
	ray.enabled = true
	ray.force_raycast_update()
	ray.enabled = false
	return ray.get_collision_point()

func turn_off_collision():
	dotcollider.disabled = true

# warning-ignore-all:unused_argument
func _on_dot_input(viewport, event : InputEvent, shape_idx):
	InputHandler._pressed(event, self)
