extends KinematicBody2D
class_name Player

signal cannon_fired(cannon_jump_impulse)

export var cannon_node_path : NodePath

onready var cannon : Cannon = get_node(cannon_node_path) as Cannon
onready var sprite : Sprite = $Sprite as Sprite

var facing : int = 1 setget set_facing

# can_interact, interacting, cannot_interact
var _interaction_state : String = "can_interact"
var _interaction_target : Node2D
var _current_interactor : Interactor
export (String) var interactor_id : String = "1"
export var _interaction_range : float = 100.0
onready var interactors : Node = $Interactors


func _ready() -> void:
	for interactor in interactors.get_children():
		(interactor as Interactor).connect("interaction_complete", self, "_on_interactor_interaction_complete")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_cannon"):
		if not cannon.is_cannon_ready:
			return
		var cannon_jump_impulse = -cannon.fire()
		emit_signal("cannon_fired", cannon_jump_impulse)
	
	if (
		event.is_action_pressed("ui_select")
		and _interaction_state == "can_interact"
	):
		# Find the closest valid interaction target and interact with them
		var interactables = get_tree().get_nodes_in_group("interactables")
		var sorter = Node2dDistanceSorter.new(
			global_position,
			facing,
			_interaction_range
		)
		var valid_interaction_targets = (
			sorter.get_interactable_nodes_in_direction(interactables)
		)
		
		if len(valid_interaction_targets) > 0:
			_initiate_interaction_with(valid_interaction_targets[0])


func set_facing(value : int):
	if value == 0:
		return
	
	if facing != value:
		sprite.scale.x *= -1
	
	facing = value


func _initiate_interaction_with(interaction_target : Node2D) -> void:
	if _interaction_state == "can_interact":
		var interaction : Interaction = interaction_target.get_interaction(interactor_id)
		for interactor in interactors.get_children():
			if (interactor as Interactor).interaction_type == interaction.interaction_type:
				_current_interactor = interactor
		
		if _current_interactor:
			_interaction_state = "interacting"
			_current_interactor.handle_interaction(interaction)
			set_process_unhandled_input(false)
		
		_interaction_target = interaction_target


func _on_interactor_interaction_complete(type : String):
	print('here')
	if _interaction_state == "interacting" and _current_interactor:
		print('there')
		_current_interactor.emit_signal("cancelled_interaction")
		_current_interactor = null
		_interaction_state = "can_interact"
		_interaction_target = null
	
	match type:
		"dialogue":
			print('everywhere')
			set_process_unhandled_input(true)


class Node2dDistanceSorter:
	var _global_position : Vector2
	var _facing : int
	var _interact_distance
	
	func _init(
		g_pos : Vector2,
		dir : int,
		interact_distance : float
	) -> void:
		_global_position = g_pos
		_facing = dir
		_interact_distance = interact_distance
	
	
	func sort_ascending(a : Node2D, b: Node2D):
		if (
			_global_position.distance_to(a.global_position)
			< _global_position.distance_to(b.global_position)
		):
			return true
		return false
	
	
	func get_interactable_nodes_in_direction(nodes : Array) -> Array:
		var arr : Array = []
		for node in nodes:
			if (
				sign(_global_position.direction_to(node.global_position).x)
				== _facing
				
				and _global_position.distance_to(node.global_position)
				< _interact_distance
			):
				arr.append(node)
		arr.sort_custom(self, "sort_ascending")
		return arr

