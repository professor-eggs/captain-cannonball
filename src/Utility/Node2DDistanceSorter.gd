extends Node
class_name Node2DDistanceSorter

var _global_position : Vector2
var _facing : int
var _interact_distance


func _init(
	g_pos : Vector2,
	dir : int,
	interact_distance : float
) -> void:
	_global_position = g_pos
	_facing = dir
	_interact_distance = interact_distance


func sort_ascending(a : Node2D, b: Node2D):
	if (
		_global_position.distance_to(a.global_position)
		< _global_position.distance_to(b.global_position)
	):
		return true
	return false


func get_interactable_nodes_in_direction(nodes : Array) -> Array:
	var arr : Array = []
	for node in nodes:
		if (
			sign(_global_position.direction_to(node.global_position).x)
			== _facing
			
			and _global_position.distance_to(node.global_position)
			< _interact_distance
		):
			arr.append(node)
	arr.sort_custom(self, "sort_ascending")
	return arr
