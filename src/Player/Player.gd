extends KinematicBody2D
class_name Player

signal cannon_fired(cannon_jump_impulse)

export var cannon_node_path : NodePath

onready var cannon : Cannon = get_node(cannon_node_path) as Cannon
onready var sprite : Sprite = $Sprite as Sprite

var facing : int = 1 setget set_facing


func set_facing(value : int):
	if value == 0:
		return
	
	if facing != value:
		sprite.scale.x *= -1
	
	facing = value


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_cannon"):
		if not cannon.is_cannon_ready:
			return
		var cannon_jump_impulse = -cannon.fire()
		emit_signal("cannon_fired", cannon_jump_impulse)


func _ready() -> void:
	print(get_class())

