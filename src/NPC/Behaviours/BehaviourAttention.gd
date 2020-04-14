extends Node
class_name BehaviourAttention

var _owner : KinematicBody2D

var _dialogue : Node2D
var _curiosity_counter := 0

var velocity := Vector2.ZERO
var facing : int
var look_at := Vector2.ZERO
var target : Node2D


func _init(
	character : KinematicBody2D
) -> void:
	_owner = character
#	_dialogue = _owner.get_node("Dialogue")
	velocity = _owner.velocity
	facing = _owner.default_facing
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	velocity.x = 0
	velocity.y += 12
	_owner.move_and_slide(velocity, Vector2.UP)
	
	look_at = (
		(target.position - _owner.position).normalized()
		if target
		else Vector2.ZERO
	)
