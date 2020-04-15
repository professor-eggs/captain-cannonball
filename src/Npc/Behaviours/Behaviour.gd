extends Node
class_name Behaviour

const UP := Vector2.UP
export var start_enabled := false

onready var _owner := get_parent() as KinematicBody2D


func _ready() -> void:
	set_physics_process(start_enabled)
