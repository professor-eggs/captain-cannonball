extends State

export (float) var _cooldown_duration : float = 2.0


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	_animation_player.play("anticipation")
	yield(get_tree().create_timer(_cooldown_duration), "timeout")
	_state_machine.transition_to("Attack")


func exit() -> void:
	return


func do_state_transitions() -> void:
	return


func connect_signals() -> void:
	return
