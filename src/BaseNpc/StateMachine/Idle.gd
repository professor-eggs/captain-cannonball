extends State

export(float) var _default_idle_time := 2.0

var _idle_timer_timed_out := false
var _idle_timer : Timer


func _ready() -> void:
	owner = owner.owner
	_idle_timer = Timer.new()
	_idle_timer.wait_time = _default_idle_time
	_idle_timer.one_shot = true
	_idle_timer.autostart = false
	_idle_timer.connect("timeout", self, "_on_idle_timer_timeout")
	add_child(_idle_timer)


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	do_state_transitions()


func enter(msg: Dictionary = {}) -> void:
	_get_animation_player(owner).play("idle")
	
	if "idle_time" in msg:
		_idle_timer.wait_time = msg["idle_time"]
	
	_idle_timer.start()


func exit() -> void:
	_idle_timer.wait_time = _default_idle_time
	_idle_timer_timed_out = false


func do_state_transitions() -> void:
	if owner.is_player_visible():
		_state_machine.transition_to("Spot")
	else:
		if owner.is_in_roam_area():
			if _idle_timer_timed_out:
				_state_machine.transition_to("Roam")
			else:
				# stay in idle until the timeout happens
				pass
		else:
			_state_machine.transition_to("Return")


func connect_signals() -> void:
	return


func _on_idle_timer_timeout() -> void:
	_idle_timer_timed_out = true
