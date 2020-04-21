extends Node
class_name State
"""
State interface to use in Hierarchical State Machines.
The lowest leaf tries to handle callbacks, and if it can't, it delegates the work to its parent.
It's up to the user to call the parent state's functions, e.g. `get_parent().physics_process(delta)`
Use State as a child of a StateMachine node.
"""


onready var _state_machine := _get_state_machine(self)
var _owner : KinematicBody2D
var _animation_player


func _ready() -> void:
	owner = _state_machine.owner
	_owner = owner
	_animation_player = _get_animation_player(owner)
	call_deferred("connect_signals")


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	return


func exit() -> void:
	return


func do_state_transitions() -> void:
	return


func connect_signals() -> void:
	return


func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node


func _get_animation_player(node: Node) -> AnimationPlayer:
	var anim_player := node.get_node("AnimationPlayer") as AnimationPlayer
	return anim_player

