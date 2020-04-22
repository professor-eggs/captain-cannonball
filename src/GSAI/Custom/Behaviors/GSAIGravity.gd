extends GSAISteeringBehavior

class_name GSAIGravity

var acceleration : GSAITargetAcceleration


func _init(agent: GSAISteeringAgent, gravity: float).(agent) -> void:
	self.acceleration = GSAITargetAcceleration.new()
	self.acceleration.linear.y = gravity


