extends Node
class_name PixelFrogAnimationImporter


func _init(
	path : String
) -> void:
	var animation_data = get_animation_directories(path)
	var attack_frames = get_animation_frames(animation_data["attack"])
	var attack_animation = textures_to_animation(attack_frames)
	ResourceSaver.save("res://test/attack_animation.tres", attack_animation)


func get_animation_directories(path : String) -> Dictionary:
	var animation_data := {}
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				var animation_name = file_name.substr(3).to_lower().replace(" ", "_")
				var animation_directory = path + file_name
				animation_data[animation_name] = animation_directory
			file_name = dir.get_next()
	
	else:
		print("An error occurred when trying to access the path.")
	
	dir.list_dir_end()
	return animation_data


func get_animation_frames(path : String):
	var data := []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		while (file_name != ""):
			if not dir.current_is_dir() and file_name.get_extension() != "import":
				var texture = load(path + "/" + file_name)
				data.append(texture)
			file_name = dir.get_next()
	
	return data


func textures_to_animation(
	textures : Array,
	loop := false,
	step := 0.1
) -> Animation:
	
	var animation = Animation.new()
	animation.loop = loop
	animation.step = step
	animation.length = len(textures) * animation.step
	
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "Sprite:texture")
	
	for i in len(textures):
		animation.track_insert_key(track_index, i * step, textures[i])
	
	return animation
