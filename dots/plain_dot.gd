extends dot


func _ready():
	randomize()
	var i = randi() % Leveldata.dot_colors.size()
	$dotsprite.change_color(Leveldata.dot_colors[i])
