extends KinematicBody2D
class_name NPC

enum Behaviours { WANDER }
enum States { WANDER_WALKING, WANDER_IDLE }
export (Behaviours) var behaviour := Behaviours.WANDER

# Wander behaviour
export (int, -1, 1) var wander_direction := 1
export (float) var wander_pause_duration := 1.5
export (float) var wander_speed := 20.0
export (float) var wander_distance := 150.0
onready var wander_target_position := (
	position
	+ Vector2(wander_distance * sign(wander_direction), 0)
)
export var wander_arrival_threshold := 3
onready var wander_pause_timer : Timer = $WanderPauseTimer

export (float) var jump_height := 100.0
export (bool) var is_paying_attention := true

onready var _owner := owner as KinematicBody2D
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var starting_position := position

var velocity = Vector2.ZERO
var state : int = States.WANDER_IDLE


func _ready() -> void:
	wander_pause_timer.wait_time = wander_pause_duration


func _physics_process(delta: float) -> void:
	velocity.y += 12
	
	if behaviour == Behaviours.WANDER:
		velocity = calculate_wander_velocity(
			delta,
			position,
			wander_speed,
			wander_direction,
			wander_target_position,
			wander_arrival_threshold
		)
	
	if abs(velocity.x) > 0:
		state = States.WANDER_WALKING
	else:
		state = States.WANDER_IDLE
		if wander_pause_timer.is_stopped():
			wander_pause_timer.start()
	
	
	match state:
		States.WANDER_IDLE:
			animation_player.play("idle")
			print(wander_pause_timer.time_left)
			if wander_pause_timer.time_left == 0:
				wander_direction *= -1
				wander_target_position = Vector2(
					position
					+ Vector2(wander_distance * sign(wander_direction), 0)
				)
		States.WANDER_WALKING:
			animation_player.play("run")
	
	
	velocity = move_and_slide(velocity)


func move():
	return


func interact():
	return


func calculate_wander_velocity(
	delta : float,
	position : Vector2,
	wander_speed : float,
	wander_direction : int,
	wander_target_position : Vector2,
	wander_arrival_threshold : float
) -> Vector2:
	var velocity : Vector2
	
	if abs(position.x - wander_target_position.x) < wander_arrival_threshold:
		velocity = Vector2.ZERO
	else:
		velocity = wander_direction * Vector2(wander_speed, 0)
	
	return velocity
