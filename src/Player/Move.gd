extends State
class_name StateMove

export var gravity_default : float = 12.0
export var max_speed_default : float = 150.0
export var acceleration_default : float = 300.0
export var deceleration_default : float = 500.0
export var movement_threshold_default : float = 3.0

var gravity := gravity_default
var max_speed := max_speed_default
var acceleration := acceleration_default
var deceleration := deceleration_default
var movement_threshold := movement_threshold_default

var velocity := Vector2.ZERO


func unhandled_input(event: InputEvent) -> void:
	# process jump
	if Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Move/Air", {
			"jump" : true,
			"previous_state" : _state_machine.get_path_to(_state_machine.state)
		} )


func physics_process(delta: float) -> void:
	_owner.set_facing(sign(velocity.x))
	
	if abs(velocity.x) > max_speed_default and abs(velocity.x) < max_speed:
		velocity = calculate_velocity(delta, velocity, 0)
	else:
		velocity = calculate_velocity(delta, velocity)
	
	velocity = _owner.move_and_slide(velocity, Vector2.UP)
	
	# reset max speed to default
	if abs(velocity.x) < max_speed_default:
		max_speed = max_speed_default
	
	_state_machine.state.do_state_transitions()


func enter(msg: Dictionary = {}) -> void:
	if "previous_state" in msg:
		if msg["previous_state"] == "Move/Air":
			_animation_player.set_animation("ground")
	_animation_player.set_animation("run")


func exit() -> void:
	return


func connect_signals() -> void:
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
		get_move_direction(),
		abs(velocity.x) > movement_threshold
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


static func get_move_direction() -> float:
	var left := Input.get_action_strength("move_left")
	var right := Input.get_action_strength("move_right")
	var move_dir = right - left
	
	return move_dir


func calculate_velocity(
	delta : float,
	velocity : Vector2 = self.velocity,
	move_dir : float = get_move_direction(),
	max_speed : float = self.max_speed,
	acceleration : float = self.acceleration,
	deceleration : float = self.deceleration,
	gravity : float = self.gravity,
	movement_threshold : float = self.movement_threshold
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
