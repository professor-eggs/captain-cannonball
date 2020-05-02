extends Control


func _ready() -> void:
	build_small_text_bitmap_font()
	build_big_text_bitmap_font()


func build_small_text_bitmap_font():
	var font_w := 5
	var font_h := 6
	
	var bitmap_font := BitmapFont.new()
	bitmap_font.height = font_h
	
	var font_path_1 : String = "res://assets/theme/fonts/font_data/pixel-frog/Small Text/Small Text/"
	var font_path_2 : String = "res://assets/theme/fonts/font_data/pixel-frog/Small Text/Small Icons/"
	
	var font_textures := _get_font_textures_from_path(font_path_1)
	
	for font_texture in font_textures:
		bitmap_font.add_texture(font_texture)
	
	var space_image = Image.new()
	space_image.create(font_w, font_h, false, Image.FORMAT_RGBA8)
	space_image.lock()
	for i in space_image.get_width():
		for j in space_image.get_height():
			space_image.set_pixel(i, j, Color(0,0,0,0))
	space_image.unlock()
	
	var space_texture = ImageTexture.new()
	space_texture.set_data(space_image)
	font_textures.append(space_texture) # blank texture for space?
	
	var default_font_rect := Rect2(0,0,font_w, font_h)
	
	# 48-57 latin numbers
	# 65-90 latin uppercase
	# 97-122 latin lowercase
	var font_mapping = {
		48 : 36,
		49 : 27,
		50 : 28,
		51 : 29,
		52 : 30,
		53 : 31,
		54 : 32,
		55 : 33,
		56 : 34,
		57 : 35,
		65 : 01,
		66 : 02,
		67 : 03,
		68 : 04,
		69 : 05,
		70 : 06,
		71 : 07,
		72 : 08,
		73 : 09,
		74 : 10,
		75 : 11,
		76 : 12,
		77 : 13,
		78 : 14,
		79 : 15,
		80 : 16,
		81 : 17,
		82 : 18,
		83 : 19,
		84 : 20,
		85 : 21,
		86 : 22,
		87 : 23,
		88 : 39, # uppercase X = multiplication sign
		89 : 25,
		90 : 26,
		97 : 01,
		98 : 02,
		99 : 03,
		100 : 04,
		101 : 05,
		102 : 06,
		103 : 07,
		104 : 08,
		105 : 09,
		106 : 10,
		107 : 11,
		108 : 12,
		109 : 13,
		110 : 14,
		111 : 15,
		112 : 16,
		113 : 17,
		114 : 18,
		115 : 19,
		116 : 20,
		117 : 21,
		118 : 22,
		119 : 23,
		120 : 24,
		121 : 25,
		122 : 26,
		45 : 37,
		43 : 38,
		215 : 39,
		47 : 40,
		61 : 41,
		40 : 42,
		41 : 43,
		35 : 44,
		64 : 45,
		33 : 46,
		63 : 47,
		46 : 48,
		44 : 49,
		58 : 50,
		39 : 51,
		36 : 52,
		32 : 53 # space?
	}
	
	for character_code in font_mapping.keys():
		bitmap_font.add_char(
			character_code,
			font_mapping[character_code] - 1,
			default_font_rect
		)
	
	assert(
		ResourceSaver.save(
			"res://assets/theme/fonts/font_data/pixel-frog/small-text.font",
			bitmap_font
		) == OK
	)


func build_big_text_bitmap_font():
	var big_text := BitmapFont.new()
	var font_path : String = "res://assets/theme/fonts/font_data/pixel-frog/Big Text/"
	var font_textures = _get_font_textures_from_path(font_path)
	for font_texture in font_textures:
		big_text.add_texture(font_texture)
	
	var space_image = Image.new()
	space_image.create(10, 11, false, Image.FORMAT_RGBA8)
	space_image.lock()
	for i in space_image.get_width():
		for j in space_image.get_height():
			space_image.set_pixel(i, j, Color(0,0,0,0))
	space_image.unlock()
	
	var space_texture = ImageTexture.new()
	space_texture.set_data(space_image)
#	font_textures.append(space_texture) # blank texture for space?
	
	var default_font_rect : Rect2
	default_font_rect.size = Vector2(10,11)
	default_font_rect.position = Vector2.ZERO
	
	# 48-57 latin numbers
	# 65-90 latin uppercase
	# 97-122 latin lowercase
	var font_mapping = {
		32 : 37, # space
		48 : 36,
		49 : 27,
		50 : 28,
		51 : 29,
		52 : 30,
		53 : 31,
		54 : 32,
		55 : 33,
		56 : 34,
		57 : 35,
		65 : 01,
		66 : 02,
		67 : 03,
		68 : 04,
		69 : 05,
		70 : 06,
		71 : 07,
		72 : 08,
		73 : 09,
		74 : 10,
		75 : 11,
		76 : 12,
		77 : 13,
		78 : 14,
		79 : 15,
		80 : 16,
		81 : 17,
		82 : 18,
		83 : 19,
		84 : 20,
		85 : 21,
		86 : 22,
		87 : 23,
		88 : 24,
		89 : 25,
		90 : 26,
		97 : 01,
		98 : 02,
		99 : 03,
		100 : 04,
		101 : 05,
		102 : 06,
		103 : 07,
		104 : 08,
		105 : 09,
		106 : 10,
		107 : 11,
		108 : 12,
		109 : 13,
		110 : 14,
		111 : 15,
		112 : 16,
		113 : 17,
		114 : 18,
		115 : 19,
		116 : 20,
		117 : 21,
		118 : 22,
		119 : 23,
		120 : 24,
		121 : 25,
		122 : 26
	}
	
	for character_code in font_mapping.keys():
		big_text.add_char(
			character_code,
			font_mapping[character_code] - 1,
			default_font_rect
		)
	
	assert(
		ResourceSaver.save(
			"res://assets/theme/fonts/font_data/pixel-frog/big-text.font",
			big_text
		) == OK
	)


func _get_font_textures_from_path(path : String) -> Array:
	var contents := []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.get_extension() == "png":
				var texture : Texture = load(path + file_name)
				contents.append(texture)
			file_name = dir.get_next()
	return contents
