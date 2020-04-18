extends Node

onready var _owner = get_parent() as KinematicBody2D

onready var jump_action : String = "%s_jump" % _owner.name.to_lower()


func _ready() -> void:
	InputMap.add_action(jump_action)


func _physics_process(delta: float) -> void:
	var a = InputEventAction.new()
	a.action = jump_action
	a.pressed = true
	Input.parse_input_event(a)
