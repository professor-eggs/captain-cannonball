extends KinematicBody2D
class_name Player

signal cannon_fired(cannon_jump_impulse)

export var cannon_node_path : NodePath

onready var cannon : Cannon = get_node(cannon_node_path) as Cannon
onready var sprite : Sprite = $Sprite as Sprite

onready var dialogue_box = $BaseDialogbox

var facing : int = 1 setget set_facing

# can_interact, interacting, cannot_interact
var _interaction_state : String = "can_interact"
var _interaction_target : Node2D
export var _max_interaction_distance : float = 200.0


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
		var interactables = get_tree().get_nodes_in_group("interactables")
		var sorter = Node2dDistanceSorter.new(
			global_position,
			facing,
			_max_interaction_distance
		)
		var foo = sorter.get_interactable_nodes_in_direction(interactables)
		if len(foo) > 0:
			_interaction_target = foo[0]
			_interaction_target.interact()
			_interaction_state = "interacting"


func set_facing(value : int):
	if value == 0:
		return
	
	if facing != value:
		sprite.scale.x *= -1
	
	facing = value


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


