extends Area2D
class_name dot

var dotCollider = preload("res://dots/dot_extras/dotcollider.tscn"	)

onready var dotcollider : CollisionShape2D
onready var ray : RayCast2D

var tween = Tween.new()

export(GlobalVars.type) var dot_type

func _ready():
	Events.connect("level_initialized", self, "move")
	Events.connect("turn_over", self, "move")
	add_collider()
	add_child(tween)

func add_collider():
	var new_dotcollider = dotCollider.instance()
	add_child(new_dotcollider)
	dotcollider = new_dotcollider
	ray = dotcollider.get_ray()
	dotcollider.move_ray($dotsprite/pos.global_position)

func move():
	if ! GlobalVars.state == GlobalVars.states.level_turn:
		return
	var go_to = extend_ray_until_collides()
	tween.interpolate_property(self, "global_position",
			global_position, go_to, 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	Events.emit_signal("done_moving")

func extend_ray_until_collides() -> Vector2:
	for i in get_viewport_rect().size.y:
		if not ray.is_colliding(): 
			ray.cast_to.y += 1
			ray.force_raycast_update()
	var size = ray.cast_to.y
	ray.cast_to = Vector2.ZERO
	print(ray.get_collider())
	print(global_position.x, global_position.y + size)
	return Vector2(global_position.x, global_position.y + size)

func turn_off_collision():
	dotcollider.disabled = true

func _on_dot_input(viewport, event : InputEvent, shape_idx):
	InputHandler._pressed(event, self)
