extends State

export (float) var roam_area_threshold := 100.0
export(int) var _initial_roam_direction : int = 1
export(float) var _roam_target_threshold := 3.0

var _is_at_roam_target := false
var _roam_target : Vector2
var _roam_direction : int = _initial_roam_direction
var _check_outside_roam_area : bool = false


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	do_state_transitions()


func enter(msg: Dictionary = {}) -> void:
	owner.can_move = true
	_roam_target = owner.spawn_position + Vector2(_roam_direction * roam_area_threshold, 0)
	owner.turn_to_face(_roam_target)
	
	owner.arrive_target_location.position.x = _roam_target.x
	owner.arrive_target_location.position.y = owner.global_position.y	
	owner.play_animation("roam")
	
	if "check_outside_roam_area" in msg:
		_check_outside_roam_area = msg["check_outside_roam_area"]


func exit() -> void:
	_check_outside_roam_area = false


func do_state_transitions() -> void:
	var target = owner.get_target_if_visible()
	if target:
		_state_machine.transition_to("Spot", { "target": target })
	elif _check_outside_roam_area:
		if not owner.is_within_distance(roam_area_threshold, owner.spawn_position):
			_state_machine.transition_to("Return")
	elif owner.is_within_distance(_roam_target_threshold, _roam_target):
		_roam_direction *= -1
		_state_machine.transition_to("Idle")


func connect_signals() -> void:
	return
