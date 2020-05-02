extends Node2D

onready var _original_displacement_x : float = position.x
onready var _owner : KinematicBody2D = owner as KinematicBody2D
#onready var _dead := $Dead
#onready var _exclamation := $Exclamation
onready var _interrogation := $Interrogation

var _current_expression : AnimatedSprite


func _process(delta: float) -> void:
	position.x = owner.facing * _original_displacement_x


func show_expression(expression_name) -> void:
	_current_expression = get("_%s" % expression_name)
	if not _current_expression:
		return
	
	_current_expression.show()
	_current_expression.play("in")
	yield(_current_expression, "animation_finished")
	_current_expression.play("showing")


func hide_expression() -> void:
	_current_expression.play("out")
	yield(_current_expression, "animation_finished")
	_current_expression.hide()
