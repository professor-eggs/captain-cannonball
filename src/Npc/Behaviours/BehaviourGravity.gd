extends Behaviour
class_name BehaviourGravity
signal owner_velocity_changed(_velocity)

"""
Applies a constant downwards force to the owner
"""

export var gravity : float = 12
var _velocity = Vector2.ZERO


func _physics_process(delta: float) -> void:
	_velocity.y += gravity
	_velocity = _owner.move_and_slide(_velocity, UP)
	emit_signal("owner_velocity_changed", _velocity)
