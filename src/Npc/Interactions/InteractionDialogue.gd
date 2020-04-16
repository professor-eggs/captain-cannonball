extends Interaction
class_name InteractionDialogue

"""
This object needs to handle all the interaction. It needs to know what nodes it
can interact with, how close they have to be, etc.
"""

export var dialogue : String = "Hi there %s! I am %s"
export var interact_distance : float = 50.0
export var dialogue_bubble_path : NodePath

onready var _dialogue_bubble : Label = get_node(dialogue_bubble_path)

var _targets : Array = []


func _ready() -> void:
	for node_path in interact_with_node_paths:
		var node := get_node(node_path)
		if node:
			_targets.append(node)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		var player : Node2D
		for node in _targets:
			if node.name == "Player":
				player = node
		
		if player:
			if player.global_position.distance_to(_owner.global_position) <= interact_distance:
				_interact(player)


func _interact(target : Node2D) -> void:
	var behaviour_patrol = (get_behaviour("BehaviourPatrol") as Behaviour)
	behaviour_patrol.set_behaviour_active(false)
	_dialogue_bubble.text = dialogue % [target.name, _owner.name]
	_dialogue_bubble.show()
	yield(get_tree().create_timer(2.5), "timeout")
	_dialogue_bubble.hide()
	_dialogue_bubble.text = ""
	behaviour_patrol.set_behaviour_active(true)

