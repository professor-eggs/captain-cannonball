extends KinematicBody2D

var velocity : Vector2
var gravity : float = 12.0
var bounce_force : float = 100.0
var angular_velocity : float = 10 * PI


func _ready() -> void:
	$InactiveTimer.connect("timeout", self, "_on_InactiveTimer_timeout")


func setup(impulse : Vector2, position : Vector2) -> void:
	self.velocity = impulse
	global_position = position


func _physics_process(delta: float) -> void:
	velocity.y += gravity
	var collision := move_and_collide(velocity * delta)
	$icon.rotation += angular_velocity * delta
	
	if collision and $InactiveTimer.is_stopped():
		$InactiveTimer.start()
		velocity = collision.normal * bounce_force
		angular_velocity = 4 * PI * delta


func _on_InactiveTimer_timeout():
	queue_free()
