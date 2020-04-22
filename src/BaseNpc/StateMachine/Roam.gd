extends State

export (float) var roam_area_threshold := 100.0
export(int) var _initial_roam_direction : int = 1
export(float) var _roam_target_threshold := 3.0

var _is_at_roam_target := false
var _roam_target : Vector2
var _roam_direction : int = _initial_roam_direction


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	do_state_transitions()


func enter(msg: Dictionary = {}) -> void:
	_roam_target = owner.spawn_position + Vector2(_roam_direction * roam_area_threshold, 0)
	owner.turn_to_face(_roam_target)
	
	owner.arrive_blend.is_enabled = true
	owner.arrive_target_location.position.x = _roam_target.x
	owner.arrive_target_location.position.y = owner.global_position.y
	
	_animation_player.play("run")


func exit() -> void:
	return


func do_state_transitions() -> void:
	if owner.get_player_if_visible():
		_state_machine.transition_to(
			"Spot",
			{
				"player": owner.get_player_if_visible(),
				"is_in_roam_area" : true
			}
		)
	else:
		if abs(owner.global_position.x - _roam_target.x) < _roam_target_threshold:
			_roam_direction *= -1
			_state_machine.transition_to("Idle", { "is_in_roam_area" : true })


func connect_signals() -> void:
	return


func is_in_roam_area() -> bool:
	return abs(owner.global_position.x - owner.spawn_position.x) <= roam_area_threshold

