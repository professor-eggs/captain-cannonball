extends Node
class_name Interaction

"""
Basic interface for interacting with NPCs.
It registers to some signal emitted by the parent
Or should the parent directly call the interact() function?
"""

export var interact_with_node_paths : Array = [] # Consider doing a regex match here
onready var _owner := get_parent() as KinematicBody2D


func _interact(target : Node2D) -> void:
	return


func get_behaviour(behaviour_name : String) -> Node:
	return _owner.get_node(behaviour_name)


func set_interaction_active(is_active):
	set_physics_process(is_active)
	set_process_unhandled_input(is_active)
