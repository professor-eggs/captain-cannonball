extends KinematicBody2D
class_name BaseNpc

var facing : int = -1 setget set_facing
onready var sprite : Sprite = $Sprite as Sprite


func set_facing(value : int):
	if value == 0:
		return
	
	if facing != value:
		sprite.scale.x *= -1
	
	facing = value
