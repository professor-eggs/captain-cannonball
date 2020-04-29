extends State

export(float) var _default_spot_time := 2.0

var _spot_timer_timed_out := false
var _spot_timer : Timer

var spot_time_remaining : float

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
	spot_time_remaining = _spot_timer.time_left
	owner.turn_to_face_target()
	do_state_transitions()


func enter(msg: Dictionary = {}) -> void:
	owner.can_move = false
	_spot_timer.start()
	_animation_player.play("anticipation")


func exit() -> void:
	_spot_timer.wait_time = _default_spot_time
	_spot_timer_timed_out = false


func do_state_transitions() -> void:
	var target = owner.get_target_if_visible()
	if not target:
		_state_machine.transition_to("Roam")
	elif _spot_timer_timed_out:
		_state_machine.transition_to("Follow", { "target": target })


func connect_signals() -> void:
	return


func _on_spot_timer_timeout() -> void:
	_spot_timer_timed_out = true
