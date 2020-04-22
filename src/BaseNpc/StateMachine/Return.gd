extends State


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	do_state_transitions()


func enter(msg: Dictionary = {}) -> void:
	owner.arrive_target_location.position.x = owner.spawn_position.x
	owner.arrive_target_location.position.y = owner.spawn_position.y
	_animation_player.play("run")


func exit() -> void:
	return


func do_state_transitions() -> void:
	if owner.is_player_visible():
		_state_machine.transition_to("Spot")
	else:
		if owner.is_at_spawn_position():
			# turn around
			_state_machine.transition_to("Idle")


func connect_signals() -> void:
	return

