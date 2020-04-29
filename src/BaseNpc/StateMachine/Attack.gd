extends State

var _attack_range : float = 0
var _target : Node2D
var _attack_complete : bool = false
var _cleanup : bool = true


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	owner.can_move = false
	if "target" in msg:
		_target = msg["target"]
	
	if "attack_range" in msg:
		_attack_range = msg["attack_range"]
	
	if owner.is_within_distance(_attack_range):
		_animation_player.play("attack")
		yield(_animation_player, "animation_finished")
		
		_cleanup = false
		_state_machine.transition_to("Cooldown")
	
	else:
		_state_machine.transition_to("Follow", { "target": _target })


func exit() -> void:
	if not _cleanup:
		_cleanup = true
		return
	_target = null
	_attack_range = 0.0


func do_state_transitions() -> void:
	return


func connect_signals() -> void:
	return

