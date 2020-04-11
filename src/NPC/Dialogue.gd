extends Node2D

onready var _owner : KinematicBody2D = owner as KinematicBody2D
onready var _dead := $Dead
onready var _exclamation := $Exclamation
onready var _interrogation := $Interrogation

var _current_dialogue : AnimatedSprite


func _process(delta: float) -> void:
	# so dialogue position moves when the NPC changes
	# direction but maintains the right orientation itself
	scale = _owner.scale


func show_question_mark() -> void:
	print('foo')


func show_dialogue(dialogue_name) -> void:
	_current_dialogue = get("_%s" % dialogue_name)
	if not _current_dialogue:
		return
	
	_current_dialogue.show()
	_current_dialogue.play("in")
	yield(_current_dialogue, "animation_finished")
	_current_dialogue.play("showing")


func hide_dialogue() -> void:
	_current_dialogue.play("out")
	yield(_current_dialogue, "animation_finished")
	_current_dialogue.hide()
