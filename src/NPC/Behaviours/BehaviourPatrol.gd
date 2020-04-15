extends Behaviour
class_name BehaviourPatrol

"""
Move left and right, pausing for a bit before turning around.
Randomness?
Change look direction after pausing
"""

enum States { PATROL_WALKING, PATROL_IDLE }
var state : int = States.PATROL_IDLE

export var _patrol_distance : float = 100.0
export var _patrol_speed : float = 20.0
export var _idle_duration : float = 1.5
export var _start_facing_right := true
export var _patrol_arrival_threshold := 3.0

var facing : int = 1
var velocity := Vector2.ZERO

var _has_arrived_at_target : bool = false
var _target : Vector2
var _previous_target : Vector2
var _patrol_start_position : Vector2
var _patrol_end_position : Vector2

onready var _pause_timer : Timer = $PauseTimer


func _ready() -> void:
	facing = 1 if _start_facing_right else -1
	_pause_timer.wait_time = _idle_duration
	
	_patrol_start_position = _owner.position
	_patrol_end_position = _owner.position + Vector2(_patrol_distance, 0)
	_target = _patrol_end_position
	_previous_target = _patrol_start_position
	_pause_timer.connect("timeout", self, "_on_pause_timer_timeout")


func _physics_process(delta: float) -> void:
	_has_arrived_at_target = (
		abs(_owner.position.x - _target.x) < _patrol_arrival_threshold
	)
	
	if _has_arrived_at_target:
		state = States.PATROL_IDLE
		velocity.x = 0
		if _pause_timer.is_stopped():
			# I've just entered IDLE for the first time this cycle
			# Look the other way
			facing *= -1
			# Start the timer
			_pause_timer.start()
			
	
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
	

static func calculate_patrol_velocity(
	delta : float,
	position : Vector2,
	target : Vector2,
	patrol_speed : float
) -> Vector2:
	var direction := sign(position.x - target.x)
	var velocity :=  direction * Vector2(patrol_speed, 0)

	return velocity
