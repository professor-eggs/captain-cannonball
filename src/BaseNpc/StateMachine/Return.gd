extends State

export(float) var _is_at_spawn_point_threshold : float = 3.0
var _is_at_spawn_point := false


func _ready() -> void:
	owner = owner.owner


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	# Arrive to...
	owner.spawn_point
	_is_at_spawn_point = (
		abs(owner.spawn_point.x - owner.position.x)
		<= _is_at_spawn_point_threshold
	)


func enter(msg: Dictionary = {}) -> void:
	_get_animation_player(owner).set_animation("run")


func exit() -> void:
	return


func do_state_transitions() -> void:
	if owner.is_player_visible():
		_state_machine.transition_to("Spot")
	else:
		if _is_at_spawn_point:
			# turn around
			_state_machine.transition_to("Idle")


func connect_signals() -> void:
	return

