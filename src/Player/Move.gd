extends State
class_name StateMove

export var gravity_default : float = 12.0
export var max_speed_default : float = 150.0
export var acceleration_default : float = 300.0
export var deceleration_default : float = 500.0
export var movement_threshold_default : float = 3.0

var _gravity := gravity_default
var _max_speed := max_speed_default
var _acceleration := acceleration_default
var _deceleration := deceleration_default
var _movement_threshold := movement_threshold_default

var _velocity := Vector2.ZERO


func unhandled_input(event: InputEvent) -> void:
	# process jump
	if event.is_action_pressed("%s_jump" % _owner.name.to_lower()):
		_state_machine.transition_to("Move/Air", {
			"jump" : true,
			"previous_state" : _state_machine.get_path_to(_state_machine.state)
		} )


func physics_process(delta: float) -> void:
	_owner.set_facing(sign(_velocity.x))
	
	if abs(_velocity.x) > max_speed_default and abs(_velocity.x) < _max_speed:
		_velocity = calculate_velocity(delta, _velocity, 0)
	else:
		_velocity = calculate_velocity(delta, _velocity)
	
	_velocity = _owner.move_and_slide(_velocity, Vector2.UP)
	
	# reset max speed to default
	if abs(_velocity.x) < max_speed_default:
		_max_speed = max_speed_default
	
	_state_machine.state.do_state_transitions()


func enter(msg: Dictionary = {}) -> void:
	if "previous_state" in msg:
		if msg["previous_state"] == "Move/Air":
			_animation_player.set_animation("ground")
	_animation_player.set_animation("run")


func exit() -> void:
	return


func connect_signals() -> void:
	if _owner.name != "Player":
		return
	if not _owner.is_connected("cannon_fired", self, "_on_Player_cannon_fired"):
		var _err = _owner.connect("cannon_fired", self, "_on_Player_cannon_fired")


func do_state_transitions():
	var new_state : String
	var msg = {
		"previous_state" : str(
			_state_machine.get_path_to(_state_machine.state)
		)
	}
	match [
		_owner.is_on_floor(),
		get_move_direction(_owner),
		abs(_velocity.x) > _movement_threshold
	]:
		[false, _, _]:
			new_state = "Move/Air"
		[true, 0.0, false]:
			new_state = "Move/Idle"
		[true, _, true]:
			new_state = "Move"
		[_,_, _]:
			new_state = "Invalid"
	
#	print(new_state, OS.get_system_time_msecs())
	_state_machine.transition_to(new_state, msg)


static func get_move_direction(_owner : Node) -> float:
	var left := Input.get_action_strength("%s_move_left" % _owner.name.to_lower())
	var right := Input.get_action_strength("%s_move_right" % _owner.name.to_lower())
	var move_dir = right - left
	
	return move_dir


func calculate_velocity(
	delta : float,
	velocity : Vector2 = _velocity,
	move_dir : float = get_move_direction(_owner),
	max_speed : float = _max_speed,
	acceleration : float = _acceleration,
	deceleration : float = _deceleration,
	gravity : float = _gravity,
	movement_threshold : float = _movement_threshold
) -> Vector2:
	
	velocity.y += gravity
	
	if move_dir == 0.0:
		if abs(velocity.x) < movement_threshold:
			velocity.x = 0
		else:
			var previous_dir = sign(velocity.x)
			velocity.x += deceleration * (- sign(velocity.x)) * delta
			var current_dir = sign(velocity.x)
			if not previous_dir == current_dir:
				velocity.x = 0.0
	
	else:
		velocity.x += acceleration * move_dir * delta
	
	# this makes the speed decelerate to max_speed if the current speed
	# is too fast for some reason
	# I'm actually not sure if this works!
	if abs(velocity.x) > max_speed:
		velocity.x -=  sign(velocity.x) * deceleration * delta

	# this causes the velocity to reduce to max instantly which is too abrupt
	# velocity.x = clamp(velocity.x, -max_speed, max_speed)
	return velocity


func _on_Player_cannon_fired(cannon_jump_impulse: Vector2) -> void:
	_state_machine.transition_to(
		"Move/CannonJump",
		{ "impulse" : cannon_jump_impulse }
	)
