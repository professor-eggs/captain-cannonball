extends State

onready var _move = get_parent() as StateMove


func unhandled_input(event: InputEvent) -> void:
	_move.unhandled_input(event)


func physics_process(delta: float) -> void:
	_move.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	if "previous_state" in msg:
		if msg["previous_state"] == "Move/Air":
			_animation_player.set_animation("ground")
	_animation_player.set_animation("idle")


func exit() -> void:
	return


func connect_signals() -> void:
	_move.connect_signals()


func do_state_transitions() -> void:
	_move.do_state_transitions()

