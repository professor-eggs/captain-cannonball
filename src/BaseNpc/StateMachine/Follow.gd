extends State

var _target : KinematicBody2D
export (float) var _follow_distance_threshold : float = 350.0
export (float) var _attack_distance_threshold : float = 20.0


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	if owner.is_within_distance(_follow_distance_threshold):
		owner.set_arrive_target_location(_target.global_position)
	
	do_state_transitions()


func enter(msg: Dictionary = {}) -> void:
	if "target" in msg:
		_target = msg["target"]
		owner.turn_to_face_target()
	_animation_player.play("run")


func exit() -> void:
	_target = null


func do_state_transitions() -> void:
	if owner.is_within_distance(_attack_distance_threshold):
		_state_machine.transition_to(
			"Attack",
			{
				"target": _target,
				"attack_range": _attack_distance_threshold
			}
		)
	elif not owner.is_within_distance(_follow_distance_threshold):
		_state_machine.transition_to(
			"Roam",
			{
				"check_outside_roam_area": true
			}
		)


func connect_signals() -> void:
	return

