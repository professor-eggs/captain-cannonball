extends Node2D

onready var _original_displacement_x : float = position.x
onready var _owner : KinematicBody2D = owner as KinematicBody2D
onready var _dead := $Dead
onready var _exclamation := $Exclamation
onready var _interrogation := $Interrogation

var _current_dialogue : AnimatedSprite


func _process(delta: float) -> void:
	position.x = owner.facing * _original_displacement_x


func show_expression(expression_name) -> void:
	_current_dialogue = get("_%s" % expression_name)
	if not _current_dialogue:
		return
	
	_current_dialogue.play("in")
	yield(_current_dialogue, "animation_finished")
	_current_dialogue.play("showing")


func hide_expression() -> void:
	_current_dialogue.play("out")
#	yield(_current_dialogue, "animation_finished")
