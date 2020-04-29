extends KinematicBody2D
class_name BaseNpc

export (float) var spawn_position_threshold := 3.0
export (float, 0, 50, 0.5) var gravity := 12.0
var facing : int = -1 setget set_facing

onready var sprite : Sprite = $Sprite as Sprite
onready var spawn_position := global_position
onready var raycast : RayCast2D = $RayCast2D
onready var detection_area : Area2D = $DetectionArea

onready var dialogue_box = $BaseDialogbox

var _target : Node2D

# GSAI stuff
export (float, 0, 500, 10) var speed_max := 120.0
export (float, 0, 1000, 10) var acceleration_max := 250.0
export (float, 0, 1, 0.05) var linear_drag := 0.1

var velocity := Vector2.ZERO
var acceleration := GSAITargetAcceleration.new()
var can_move : bool = true setget set_can_move
onready var agent := GSAISteeringAgent.new()

onready var arrive_target_location := GSAIAgentLocation.new()
onready var arrive_blend := GSAIBlend.new(agent)
onready var priority := GSAIPriority.new(agent)


func _ready() -> void:
	detection_area.connect("body_entered", self, "_on_detection_area_body_entered")
	detection_area.connect("body_exited", self, "_on_detection_area_body_exited")
	_setup_GSAI_agent()


func _setup_GSAI_agent() -> void:
	agent.linear_speed_max = speed_max
	agent.linear_acceleration_max = acceleration_max
	agent.bounding_radius = max($CollisionShape2D.shape.extents.x, $CollisionShape2D.shape.extents.y)
	update_agent()
	
	arrive_target_location.position = GSAIUtils.to_vector3(global_position)
	var arrive := GSAIArrive.new(agent, arrive_target_location)
	arrive_blend.add(arrive, 1.0)
	priority.add(arrive_blend)


func _physics_process(delta: float) -> void:
	$ArriveMarker.global_position = GSAIUtils.to_vector2(arrive_target_location.position)
	update_agent()
	priority.calculate_steering(acceleration)

	velocity = (
		velocity
		+ Vector2(
			clamp(acceleration.linear.x, -acceleration_max, acceleration_max),
			acceleration.linear.y
		) * delta)

	velocity.y += gravity
	velocity.x = lerp(velocity.x, 0, linear_drag)
	velocity = move_and_slide(velocity, Vector2.UP)


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
	
	if facing == 1:
		detection_area.get_child(0).disabled = true
		detection_area.get_child(1).disabled = false
	elif facing == -1:
		detection_area.get_child(0).disabled = false
		detection_area.get_child(1).disabled = true


func get_target_if_visible() -> Node2D:
	if not _target:
		return null
	
	var direction_to_player := _target.global_position - global_position
	raycast.cast_to = direction_to_player
	raycast.force_raycast_update()
	
	if raycast.get_collider() == _target:
		return _target
	else:
		return null


func is_at_spawn_position() -> bool:
	return abs(global_position.x - spawn_position.x) <= spawn_position_threshold


func turn_to_face_target() -> void:
	var target := get_target_if_visible()
	if not target:
		return

	set_facing(int(sign(global_position.direction_to(target.global_position).x)))


func turn_to_face(pos : Vector2) -> void:
	set_facing(int(sign(global_position.direction_to(pos).x)))


func is_within_distance(threshold : float, target_location = null) -> bool:
	if target_location == null:
		var target := get_target_if_visible()
		if not target:
			return false
	
		return global_position.distance_to(target.global_position) < threshold
	else:
		return abs(global_position.x - target_location.x) < threshold


func get_target_position() -> Vector2:
	var target := get_target_if_visible()
	if not target:
		return Vector2.ZERO
	
	return target.global_position


func set_arrive_target_location(pos) -> void:
	arrive_target_location.position = GSAIUtils.to_vector3(pos)


func set_can_move(state : bool) -> void:
	priority.is_enabled = state


func _on_detection_area_body_entered(body : Node):
	_target = body


func _on_detection_area_body_exited(body : Node):
	_target = null
