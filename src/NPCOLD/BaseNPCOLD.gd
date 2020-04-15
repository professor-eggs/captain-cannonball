extends KinematicBody2D
class_name BaseNPCOLD

# Needed for entire BaseNPC class
enum Facing { FACING_LEFT = -1, FACING_RIGHT = 1 }
export (Facing) var default_facing := Facing.FACING_LEFT
var _facing : int = Facing.FACING_RIGHT

enum Behaviours {
	BEHAVIOUR_PATROL = 1,
	BEHAVIOUR_ATTENTION = 2,
	BEHAVIOUR_TEST1 = 4,
	BEHAVIOUR_TEST2 = 8
}
export (Behaviours, FLAGS) var behaviours_in_use

onready var _owner := owner as KinematicBody2D
onready var _animation_player : AnimationPlayer = $AnimationPlayer

var current_behaviour := "patrol"
var velocity = Vector2.ZERO

# Patrol Behaviour
export (float) var patrol_speed := 50.0
export (float) var patrol_distance := 100.0
export (float) var patrol_idle_duration := 2.0
export (bool) var is_patrolling_right = true

onready var behaviour_patrol := BehaviourPatrolOLD.new(
	self,
	patrol_distance,
	patrol_speed,
	patrol_idle_duration,
	is_patrolling_right
)

# Attention Behaviour
export (bool) var is_paying_attention := true
onready var _attention_area := $AttentionArea
onready var _dialogue := $Dialogue
var _curiosity_counter := 0
var behaviour_attention := BehaviourAttentionOLD.new(
	self
)

# Jump Behaviour
export (float) var jump_height := 100.0
var behaviour_jump := BehaviourJumpOLD.new(self)


func _ready() -> void:
	_attention_area.connect(
		"body_entered", self, "_on_Attention_Area_body_entered"
	)
	_attention_area.connect(
		"body_exited", self, "_on_Attention_Area_body_exited"
	)

#	print((behaviours_in_use & Behaviours.BEHAVIOUR_PATROL))
#	print((behaviours_in_use & Behaviours.BEHAVIOUR_ATTENTION))
#	print((behaviours_in_use & Behaviours.BEHAVIOUR_TEST1))
#	print((behaviours_in_use & Behaviours.BEHAVIOUR_TEST2))


func _physics_process(delta: float) -> void:
#	print(OS.get_ticks_msec(), " ", current_behaviour)
	match current_behaviour:
		"":
			current_behaviour = "patrol"
		
		"patrol":
			behaviour_patrol._physics_process(delta)
			velocity = behaviour_patrol.velocity
			_facing = behaviour_patrol.facing
	
			match behaviour_patrol.state:
				behaviour_patrol.States.PATROL_IDLE:
					_animation_player.play("idle")
				behaviour_patrol.States.PATROL_WALKING:
					_animation_player.play("run")
		
		"attention":
			if Input.is_action_just_pressed("jump"):
				current_behaviour = "jump"
				behaviour_jump.velocity = velocity
			else:
				behaviour_attention._physics_process(delta)
				velocity = behaviour_attention.velocity
				_facing = behaviour_attention.facing
		
		"jump":
			if behaviour_jump.is_landed():
				current_behaviour = ""
			else:
				behaviour_jump._physics_process(delta)
				velocity = behaviour_attention.velocity
				_facing = behaviour_attention.facing
	
	# Enables and disables the right AttentionArea CollisionShapes
	($AttentionArea.get_child(_facing + 1) as CollisionShape2D).disabled = false
	($AttentionArea.get_child(1 - _facing) as CollisionShape2D).disabled = true


func _on_Attention_Area_body_entered(body : Node2D):
	_curiosity_counter += 1
	if _curiosity_counter > 0:
		# Enter the attention behaviour
		current_behaviour = "attention"
		behaviour_attention.velocity = velocity
		behaviour_attention.target = body
		_animation_player.play("idle")
		_dialogue.show_dialogue("interrogation")


func _on_Attention_Area_body_exited(body : Node2D):
	_curiosity_counter -= 1
	if _curiosity_counter <= 0:
		current_behaviour = "patrol"
		_dialogue.hide_dialogue()
