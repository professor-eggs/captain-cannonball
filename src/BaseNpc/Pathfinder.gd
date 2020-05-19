extends Node2D
signal arrived_at_final_destination

var _invalid_location : Vector2 = Vector2.INF

var destination_global_position : Vector2 = _invalid_location setget set_destination_global_position
var path : Array = []
var arrive_threshold : float = 3.0


func _physics_process(delta: float) -> void:
	if _has_arrived_at_target():
		path.remove(0)
		if len(path) > 0:
			destination_global_position = path[0]
		else:
			emit_signal("arrived_at_final_destination")


func set_destination_global_position(value):
	if not typeof(value) == TYPE_VECTOR2:
		value = _invalid_location
		return
	
	destination_global_position = value
	path = _calculate_path_to(destination_global_position)


func _has_arrived_at_target() -> bool :
	return global_position.distance_to(destination_global_position) <= arrive_threshold


static func _calculate_path_to(pos : Vector2) -> Array:
	var _path = []
	
	_path.append(pos)
	return _path
