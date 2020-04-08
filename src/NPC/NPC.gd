extends KinematicBody2D
class_name NPC

enum Behaviours { WANDER }
export (Behaviours) var behaviour = Behaviours.WANDER
export (int, -1, 1) var wander_direction = 1
export (float) var wander_pause_duration = 1.5
export (float) var wander_speed = 80.0

export (bool) var is_paying_attention := true


func _physics_process(delta: float) -> void:
	return


func move():
	return


func interact():
	return
