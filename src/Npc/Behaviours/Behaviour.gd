extends Node
class_name Behaviour

const UP := Vector2.UP
export var start_enabled := false

onready var _owner := get_parent() as KinematicBody2D


func _ready() -> void:
	set_physics_process(start_enabled)


func set_behaviour_active(is_active):
	set_physics_process(is_active)
	set_process_unhandled_input(is_active)
