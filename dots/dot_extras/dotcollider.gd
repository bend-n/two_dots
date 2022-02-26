extends CollisionShape2D

func move_ray(position):
	$dotray.global_position = position

func get_ray():
	return $dotray
