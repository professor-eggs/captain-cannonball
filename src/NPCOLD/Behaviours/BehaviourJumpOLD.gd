extends Node
class_name BehaviourJumpOLD

var velocity : Vector2
var jump_height : float
var _owner : KinematicBody2D
var _has_jump_started := false

func _init(
	character : KinematicBody2D
) -> void:
	_owner = character
	jump_height = _owner.jump_height
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	velocity.y += 12
	velocity.y -= jump_height
	velocity = _owner.move_and_slide(velocity, Vector2.UP)
	if not _has_jump_started:
		_has_jump_started = true


func is_landed() -> bool:
	if _has_jump_started and _owner.is_on_floor():
		_has_jump_started = false
		return true
	else:
		return false
