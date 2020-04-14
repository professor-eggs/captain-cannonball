extends Node
class_name PixelFrogAnimationImporter

"""
This object takes as an input, a path to a directory that contains folders
containing images files for animations. Each folder should contain a different
animation. The name of the folder should be descriptive of the animation
and the original folder should be named after the Character being animated.

For example:
	var pf_anim_importer = PixelFrogAnimationImporter.new('res://assets/sprites/Crabby/')

Where Crabby is the name of the character and this folder contains folders for
animations like idle, attack, jump, etc.
Animation folder names are parsed to retrieve the actual animation name in
the _get_animation_directories function

Enable looping on selected animations by providing a second argument which is
an array containing animation names that need to be looped.

For example:
	var looped_animation_names := [
		'idle',
		'run'
	]
	var pf_anim := PixelFrogAnimationImporter.new(
		'res://assets/sprites/Crabby/',
		looped_animation_names
	)

You can choose whether to save animations as individual .tres files by providing
a third argument (defaults to yes)

The last argument changes the default output directory to one of your choosing.
It defaults to the content of the _output_base_directory variable

"""

var _output_base_directory := "res://src/Utility/PixelFrogAnimationImporterData/%s"


func _init(
	path : String,
	looped_animation_names : Array = [],
	save_animations_separately : bool = true,
	output_base_directory : String = _output_base_directory
) -> void:
	_output_base_directory = output_base_directory
	
	var animation_data := _get_animation_directories(path)
	var animation_player_data := {}
	var animations := []
	
	for animation_name in animation_data:
		var animation_directory := animation_data[animation_name] as String
		var animation_frames := _get_animation_frames(animation_directory)
		var is_looped_animation = animation_name in looped_animation_names
		var animation := _textures_to_animation(animation_frames, is_looped_animation)
		var animation_character_name := animation_directory.split("/")[-2]
		
		if save_animations_separately:
			var animation_save_dir_path := (
				_output_base_directory % [animation_character_name]
			)
			var dir := Directory.new()
			dir.make_dir_recursive(animation_save_dir_path)
			assert(
				ResourceSaver.save(
					animation_save_dir_path + "/%s.tres" % animation_name,
					animation
				) == OK
			)
		
		var animation_player_name := "%sAnimationPlayer" % animation_character_name
		
		if not animation_player_name in animation_player_data:
			animation_player_data[animation_player_name] = []
		
		animation_player_data[animation_player_name].append(
			{
				"name" : animation_name,
				"animation" : animation
			}
		)
	
	for animation_player_name in animation_player_data:
		var animation_player := _create_animation_player(animation_player_data[animation_player_name])
		var scene := PackedScene.new()
		var animation_player_save_path := str((_output_base_directory % animation_player_name) + ".tscn")
		print(animation_player_save_path)
		var result := scene.pack(animation_player)
		if result == OK:
			ResourceSaver.save(
				animation_player_save_path,
				scene,
				ResourceSaver.FLAG_BUNDLE_RESOURCES
			)


static func _get_animation_directories(path : String) -> Dictionary:
	var animation_data := {}
	var dir := Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name := dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				var animation_name := (
					file_name.substr(3).to_lower().replace(" ", "_")
				)
				var animation_directory := path + file_name
				animation_data[animation_name] = animation_directory
			file_name = dir.get_next()

	else:
		print("An error occurred when trying to access the path.")

	dir.list_dir_end()
	return animation_data


static func _get_animation_frames(path : String) -> Array:
	var data := []
	var dir := Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name := dir.get_next()
		while (file_name != ""):
			if (
				not dir.current_is_dir()
				and file_name.get_extension() != "import"
			):
				var texture = load(path + "/" + file_name)
				data.append(texture)
			file_name = dir.get_next()

	return data


static func _textures_to_animation(
	textures : Array,
	loop := false,
	step := 0.1
) -> Animation:

	var animation := Animation.new()
	animation.loop = loop
	animation.step = step
	animation.length = len(textures) * animation.step

	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "Sprite:texture")

	for i in len(textures):
		animation.track_insert_key(track_index, i * step, textures[i])

	return animation


static func _create_animation_player(animation_data : Array) -> AnimationPlayer:
	var animation_player = AnimationPlayer.new()
	for animation_record in animation_data:
		animation_player.add_animation(
			animation_record["name"], animation_record["animation"]
		)
	return animation_player
