extends State

export(float) var _default_spot_time := 2.0

var _spot_timer_timed_out := false
var _spot_timer : Timer
var _target : Node2D
var _is_in_roam_area := false


func _ready() -> void:
	_spot_timer = Timer.new()
	_spot_timer.wait_time = _default_spot_time
	_spot_timer.one_shot = true
	_spot_timer.autostart = false
	_spot_timer.connect("timeout", self, "_on_spot_timer_timeout")
	add_child(_spot_timer)


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	owner.turn_to_face(_target.global_position)
	do_state_transitions()


func enter(msg: Dictionary = {}) -> void:
	if "player" in msg:
		_target = msg["player"]
	
	if "is_in_roam_area" in msg:
		_is_in_roam_area = msg["is_in_roam_area"]
	
	_spot_timer.start()


func exit() -> void:
	_spot_timer.wait_time = _default_spot_time
	_spot_timer_timed_out = false
	_target = null
	_is_in_roam_area = false


func do_state_transitions() -> void:
	if owner.get_player_if_visible():
		if _spot_timer_timed_out:
			_state_machine.transition_to("Follow")
	else:
		#Player is not visible so go to idle/whatever
		return


func connect_signals() -> void:
	return


func _on_spot_timer_timeout() -> void:
	_spot_timer_timed_out = true
