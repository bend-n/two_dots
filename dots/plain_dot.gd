extends dot

var color : Color

func _ready():
	randomize()
	var i = randi() % Leveldata.dot_colors.size()
	var n_color = Leveldata.dot_colors[i]
	$dotsprite.set_self_modulate(n_color)
	color = n_color
