extends KinematicBody2D
class_name BaseNpc

export(float) var roam_area_threshold := 100.0

var facing : int = -1 setget set_facing

onready var sprite : Sprite = $Sprite as Sprite
onready var spawn_point := global_position


func set_facing(value : int):
	if value == 0:
		return
	
	if facing != value:
		sprite.scale.x *= -1
	
	facing = value


func is_player_visible() -> bool:
	return false


func is_in_roam_area() -> bool:
	return abs(global_position.x - spawn_point.x) <= roam_area_threshold
