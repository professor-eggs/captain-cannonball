extends State

onready var _move = get_parent() as StateMove

export var jump_impulse = 300.0
export var cannon_jump_impulse = 700.0

var is_cannon_ready := true
var can_jump := true


func unhandled_input(event: InputEvent) -> void:
	_move.unhandled_input(event)


func physics_process(delta: float) -> void:
	_move.physics_process(delta)
	if sign(_move.velocity.y) == 1:
		_animation_player.set_animation("fall")


func enter(msg: Dictionary = {}) -> void:
	if "previous_state" in msg:
		if not msg["previous_state"] == "Move/Air":
			can_jump = true
	
	if "jump" in msg and can_jump:
		_move.velocity.y -= jump_impulse
		_animation_player.set_animation("jump")
		can_jump = false


func exit() -> void:
	return


func connect_signals() -> void:
	_move.connect_signals()


func do_state_transitions() -> void:
	_move.do_state_transitions()
