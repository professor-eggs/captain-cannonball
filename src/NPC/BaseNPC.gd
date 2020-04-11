extends KinematicBody2D
class_name BaseNPC

export (float) var jump_height := 100.0
export (bool) var is_paying_attention := true
export (float) var patrol_speed := 50.0
export (float) var patrol_distance := 100.0
export (float) var patrol_idle_duration := 2.0
export (bool) var is_patrolling_right = true

enum Facing { FACING_LEFT = -1, FACING_RIGHT = 1 }
export (Facing) var default_facing := Facing.FACING_LEFT
var _facing : int = Facing.FACING_RIGHT

onready var _owner := owner as KinematicBody2D
onready var _animation_player : AnimationPlayer = $AnimationPlayer
onready var behaviour_patrol := BehaviourPatrol.new(
	self,
	patrol_distance,
	patrol_speed,
	patrol_idle_duration,
	is_patrolling_right
)
onready var _dialogue := $Dialogue
onready var _attention_area := $AttentionArea

var _curiosity_counter := 0
var velocity = Vector2.ZERO


func _ready() -> void:
	_attention_area.connect(
		"body_entered", self, "_on_Attention_Area_body_entered"
	)
	_attention_area.connect(
		"body_exited", self, "_on_Attention_Area_body_exited"
	)


func _physics_process(delta: float) -> void:
	behaviour_patrol._physics_process(delta)
	velocity = behaviour_patrol.velocity
	_facing = behaviour_patrol.facing
	
	match behaviour_patrol.state:
		behaviour_patrol.States.PATROL_IDLE:
			_animation_player.play("idle")
		behaviour_patrol.States.PATROL_WALKING:
			_animation_player.play("run")
	
	($AttentionArea.get_child(_facing + 1) as CollisionShape2D).disabled = false
	($AttentionArea.get_child(1 - _facing) as CollisionShape2D).disabled = true


func _on_Attention_Area_body_entered(body : Node):
	if not is_paying_attention:
		return
	_curiosity_counter += 1
	if _curiosity_counter > 0:
		_animation_player.play("idle")
		_dialogue.show_dialogue("interrogation")
		set_physics_process(false)


func _on_Attention_Area_body_exited(body : Node):
	if not is_paying_attention:
		return
	_curiosity_counter -= 1
	if _curiosity_counter <= 0:
		set_physics_process(true)
		_dialogue.hide_dialogue()
