extends State

export(int) var _initial_roam_direction : int = 1
export(float) var _roam_target_threshold := 3.0

var _is_at_roam_target := false
var _roam_target : Vector2
var _roam_direction : int = _initial_roam_direction


func _ready() -> void:
	owner = owner.owner


func unhandled_input(event: InputEvent) -> void:
	_roam_target = owner.spawn_position + Vector2(_roam_direction * _roam_target_threshold, 0)


func physics_process(delta: float) -> void:
	# Arrive to...
	_roam_target
	_is_at_roam_target = (owner.position.x - _roam_target.x) <= _roam_target_threshold


func enter(msg: Dictionary = {}) -> void:
	_get_animation_player(owner).play("run")


func exit() -> void:
	return


func do_state_transitions() -> void:
	if owner.is_player_visible():
		_state_machine.transition_to("Spot")
	else:
		if _is_at_roam_target:
			# turn around with set_facing?
			_roam_direction *= -1
			_state_machine.transition_to("Idle")
		else:
			_state_machine.transition_to("Return")


func connect_signals() -> void:
	return
