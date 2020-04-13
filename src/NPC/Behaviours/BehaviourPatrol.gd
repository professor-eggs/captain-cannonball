extends Node
class_name BehaviourPatrol

enum States { PATROL_WALKING, PATROL_IDLE }
var state : int = States.PATROL_IDLE

var _patrol_start_position : Vector2
var _patrol_end_position : Vector2
var _patrol_speed : float
var _patrol_target_position : Vector2
var _patrol_idle_duration := 1.5
var _patrol_arrival_threshold := 3

var _owner : KinematicBody2D
var _animation_player : AnimationPlayer
var _target : Vector2
var _previous_target : Vector2
var _has_arrived_at_target : bool = false
var _pause_timer : SceneTreeTimer

var velocity := Vector2.ZERO
var facing : int


func _init(
	character : KinematicBody2D,
	patrol_distance : float,
	patrol_speed : float = 20.0,
	patrol_idle_duration := 1.5,
	patrol_right : bool = true
) -> void:
	
	var patrol_direction = 1 if patrol_right else -1
	
	_owner = character
	_animation_player = _owner.get_node("AnimationPlayer") as AnimationPlayer
	_patrol_speed = patrol_speed
	_patrol_idle_duration = patrol_idle_duration
	_patrol_start_position = _owner.position
	_patrol_end_position = _owner.position + Vector2(patrol_distance, 0)
	_target = _patrol_end_position
	_previous_target = _patrol_start_position
	facing = _owner.default_facing
	# clean up to avoid an error due to the timer lingering
	_owner.connect("tree_exiting", self, "free")
	
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	velocity.y += 12
	if not _owner.is_on_floor():
		velocity = _owner.move_and_slide(velocity, Vector2.UP)
		return
	
	_has_arrived_at_target = (
		abs(_owner.position.x - _target.x) < _patrol_arrival_threshold
	)
	
	if _has_arrived_at_target:
		state = States.PATROL_IDLE
		velocity.x = 0
		if not _pause_timer:
			# I've just entered IDLE for the first time this cycle
			# Look the other way
			facing *= -1
			# Start the timer
			_pause_timer = _owner.get_tree().create_timer(_patrol_idle_duration)
			_pause_timer.connect("timeout", self, "_on_pause_timer_timeout")
	
	else:
		state = States.PATROL_WALKING
		velocity = calculate_patrol_velocity(
			delta,
			_target,
			_owner.position,
			_patrol_speed
		)
		
		
	facing = sign(velocity.x) if velocity.x != 0 else facing
	velocity = _owner.move_and_slide(velocity, Vector2.UP)


func _on_pause_timer_timeout() -> void:
	if (
		abs(_owner.position.x - _patrol_start_position.x)
		< _patrol_arrival_threshold
	):
		# I'm at my starting position
		_previous_target = _patrol_start_position
		_target = _patrol_end_position
	elif (
		abs(_owner.position.x - _patrol_end_position.x)
		< _patrol_arrival_threshold
	):
		# I'm at the end position
		_previous_target = _patrol_end_position
		_target = _patrol_start_position
	else:
		# If I was interrupted then carry on
		_target = _previous_target
	
	_pause_timer.disconnect("timeout", self, "_on_pause_timer_timeout")
	_pause_timer = null


static func calculate_patrol_velocity(
	delta : float,
	position : Vector2,
	target : Vector2,
	patrol_speed : float
) -> Vector2:
	var direction := sign(position.x - target.x)
	var velocity :=  direction * Vector2(patrol_speed, 0)

	return velocity
