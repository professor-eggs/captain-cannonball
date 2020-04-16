extends State


onready var _move = get_parent() as StateMove

var velocity := Vector2.ZERO


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	_move.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	if "impulse" in msg:
		_move._max_speed += abs(msg["impulse"].x)
		_move._velocity = msg["impulse"]


func exit() -> void:
	return


func do_state_transitions() -> void:
	_move.do_state_transitions()


func connect_signals() -> void:
	return

