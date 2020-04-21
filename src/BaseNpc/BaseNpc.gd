extends KinematicBody2D
class_name BaseNpc

export (float) var roam_area_threshold := 100.0
export (float) var spawn_position_threshold := 3.0

var facing : int = -1 setget set_facing

onready var sprite : Sprite = $Sprite as Sprite
onready var spawn_position := global_position
onready var raycast : RayCast2D = $RayCast2D
onready var detection_area : Area2D = $DetectionArea

# GSAI stuff
export (float, 0, 500, 10) var speed_max := 120.0
export (float, 0, 1000, 10) var acceleration_max := 250.0
export (float, 0, 1, 0.05) var linear_drag := 0.1

var velocity := Vector2.ZERO
var acceleration := GSAITargetAcceleration.new()
onready var agent := GSAISteeringAgent.new()

onready var arrive_target_location := GSAIAgentLocation.new()

onready var arrive_blend := GSAIBlend.new(agent)
onready var priority := GSAIPriority.new(agent)


func _ready() -> void:
	_setup_GSAI_agent()


func _setup_GSAI_agent() -> void:
	agent.linear_speed_max = speed_max
	agent.linear_acceleration_max = acceleration_max
	agent.bounding_radius = max($CollisionShape2D.shape.extents.x, $CollisionShape2D.shape.extents.y)
	update_agent()
	
	var arrive := GSAIArrive.new(agent, arrive_target_location)
	arrive_blend.add(arrive, 1.0)
	priority.add(arrive_blend)


func _physics_process(delta: float) -> void:
	var player_position = get_tree().get_nodes_in_group("Player")[0].global_position
	
	arrive_target_location.position = Vector3(player_position.x, player_position.y, 0)
	update_agent()
	priority.calculate_steering(acceleration)
	
	velocity = (velocity + Vector2(acceleration.linear.x, acceleration.linear.y) * delta).clamped(
		agent.linear_speed_max
	)
	velocity = velocity.linear_interpolate(Vector2.ZERO, linear_drag)
	velocity = move_and_slide(velocity)


func update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.linear_velocity.x = velocity.x
	agent.linear_velocity.y = velocity.y


func set_facing(value : int):
	if value == 0:
		return
	
	if facing != value:
		sprite.scale.x *= -1
	
	facing = value


func is_player_visible() -> bool:
	if len(detection_area.get_overlapping_bodies()) == 0:
		return false
	
	var player : Node2D = detection_area.get_overlapping_bodies()[0]
	var direction_to_player := player.global_position - global_position
	raycast.cast_to = direction_to_player
	raycast.force_raycast_update()
	
	return raycast.get_collider() == player


func is_in_roam_area() -> bool:
	return abs(global_position.x - spawn_position.x) <= roam_area_threshold


func is_at_spawn_position() -> bool:
	return abs(global_position.x - spawn_position.x) <= spawn_position_threshold
