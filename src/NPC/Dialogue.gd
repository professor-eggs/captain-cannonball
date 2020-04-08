extends Node2D

onready var _owner : KinematicBody2D = owner as KinematicBody2D


func _process(delta: float) -> void:
	# so dialogue position moves when the NPC changes
	# direction but maintains the right orientation itself
	scale = _owner.scale
