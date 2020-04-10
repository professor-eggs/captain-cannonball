extends KinematicBody2D
class_name NPC

export (float) var jump_height := 100.0
export (bool) var is_paying_attention := true
export (float) var patrol_speed := 50.0
export (float) var patrol_distance := 100.0
export (float) var patrol_idle_duration := 2.0
export (bool) var is_patrolling_right = true

onready var _owner := owner as KinematicBody2D
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var starting_position := position
onready var behaviour_patrol := BehaviourPatrol.new(
	self,
	patrol_distance,
	patrol_speed,
	patrol_idle_duration,
	is_patrolling_right
)

var velocity = Vector2.ZERO


func _physics_process(delta: float) -> void:
	behaviour_patrol._physics_process(delta)

