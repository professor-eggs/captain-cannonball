extends State

var _target : KinematicBody2D

func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	if "target" in msg:
		_target = msg["target"]
		owner.set_facing(sign(owner.global_position.direction_to(_target.global_position)))


func exit() -> void:
	_target = null


func do_state_transitions() -> void:
	return


func connect_signals() -> void:
	return
