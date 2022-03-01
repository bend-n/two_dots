extends dot

func _ready():
	randomize()
	var i = randi() % Leveldata.dot_colors.size()
	$dotsprite.set_self_modulate(Leveldata.dot_colors[i])
