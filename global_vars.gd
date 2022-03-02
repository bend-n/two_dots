extends Node

const size = Vector2(70, 70)
enum type { normal, unnormal }
enum states { player_turn, level_turn }

var turns_used = 0
var state = states.level_turn

const height = 8
const width = 8
