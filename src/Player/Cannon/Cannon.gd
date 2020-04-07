extends Node2D
class_name Cannon


export var cannonball_force : float = 500.0
export var Cannonball = preload("res://src/Player/Cannon/Cannonball.tscn")

var facing_default := Vector2.RIGHT
var is_cannon_ready := true


func _ready() -> void:
	rotation += PI / 2
	$ReloadTimer.connect("timeout", self, "set", ["is_cannon_ready", true])


func _process(delta: float) -> void:
	var aim_direction = Vector2(
		(
			Input.get_action_strength("aim_right")
			- Input.get_action_strength("aim_left")
		),
		(
			Input.get_action_strength("aim_down")
			- Input.get_action_strength("aim_up")
		)
	)
	
	if aim_direction != Vector2.ZERO:
		rotation = facing_default.angle() + aim_direction.angle()


func fire() -> Vector2:
	is_cannon_ready = false
	$ReloadTimer.start()
	var cannonball = Cannonball.instance()
	var cannonball_impulse = facing_default.rotated(rotation) * cannonball_force
	cannonball.setup(cannonball_impulse, global_position)
	cannonball.set_as_toplevel(true)
	add_child(cannonball)
	return cannonball_impulse
