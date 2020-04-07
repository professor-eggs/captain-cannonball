extends AnimationPlayer


func _ready() -> void:
	play("idle")


func set_animation(
	anim : String,
	allow_non_loop_finish : bool = true
) -> void:
	
	if current_animation == anim:
		return
	
	if not current_animation:
		queue(anim)
	else:
		if get_animation(current_animation).loop:
			stop()
	
	queue(anim)
