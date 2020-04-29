extends State


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	do_state_transitions()


func enter(msg: Dictionary = {}) -> void:
	owner.can_move = true
	owner.set_arrive_target_location(owner.spawn_position)
	_animation_player.play("run")


func exit() -> void:
	return


func do_state_transitions() -> void:
	if owner.get_target_if_visible():
		_state_machine.transition_to("Spot", {"target": owner.get_target_if_visible()})
	else:
		if owner.is_at_spawn_position():
			# turn around
			_state_machine.transition_to("Idle")


func connect_signals() -> void:
	return

