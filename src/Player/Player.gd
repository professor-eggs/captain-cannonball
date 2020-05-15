extends KinematicBody2D
class_name Player

signal cannon_fired(cannon_jump_impulse)

export var cannon_node_path : NodePath

onready var cannon : Cannon = get_node(cannon_node_path) as Cannon
onready var sprite : Sprite = $Sprite as Sprite

var facing : int = 1 setget set_facing

var _interaction_state := "can_interact"
export (float) var _interaction_range = 200.0
onready var _dialogue_box = $BaseDialogueBox



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
			_dialogue_box.start_dialogue(valid_interaction_targets[0], event)
			_interaction_state = "interacting"


func _on_dialogue_box_dialogue_ended():
	_interaction_state = "can_interact"


func set_facing(value : int):
	if value == 0:
		return
	
	if facing != value:
		sprite.scale.x *= -1
	
	facing = value
