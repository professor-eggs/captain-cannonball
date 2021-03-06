extends KinematicBody2D
class_name Player

signal cannon_fired(cannon_jump_impulse)
signal dialogue_started
signal dialogue_ended

export var cannon_node_path : NodePath

onready var cannon : Cannon = get_node(cannon_node_path) as Cannon
onready var sprite : Sprite = $Sprite as Sprite

var facing : int = 1 setget set_facing

var _interaction_state := "can_interact"
export (float) var _interaction_range = 200.0
onready var _dialogue_box = $BaseDialogueBox
var _interaction_target : Node2D = null


func _ready() -> void:
	_dialogue_box.connect("dialogue_ended", self, "_on_dialogue_box_dialogue_ended")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_cannon"):
		if not cannon.is_cannon_ready:
			return
		var cannon_jump_impulse = -cannon.fire()
		emit_signal("cannon_fired", cannon_jump_impulse)
		get_tree().set_input_as_handled()
	
	
	if (
		event.is_action_pressed("dialogue_advance")
		and _interaction_state == "can_interact"
	):
		# Find the closest valid interaction target and interact with them
		var interactables = get_tree().get_nodes_in_group("interactables")
		var sorter = Node2DDistanceSorter.new(
			global_position,
			facing,
			_interaction_range
		)
		var valid_interaction_targets = (
			sorter.get_interactable_nodes_in_direction(interactables)
		)
		
		if len(valid_interaction_targets) > 0:
			_interaction_target = valid_interaction_targets[0]
			_dialogue_box.start_dialogue(_interaction_target, event)
			_interaction_state = "interacting"
			emit_signal("dialogue_started")


func _physics_process(delta: float) -> void:
	# If I go too far from the interaction target, then interrupt it
	if _interaction_state == "interacting":
		if (
			global_position.distance_to(_interaction_target.global_position)
			> _interaction_range
		):
			_dialogue_box.interrupt_dialogue()


func _on_dialogue_box_dialogue_ended():
	_interaction_state = "can_interact"
	_interaction_target = null
	emit_signal("dialogue_ended")


func set_facing(value : int):
	if value == 0:
		return
	
	if facing != value:
		sprite.scale.x *= -1
	
	facing = value
