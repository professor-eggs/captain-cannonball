extends Control
class_name PixelFrogFontImporter


func build_small_text_bitmap_font():
	var font_w := 6
	var font_h := 6
	
	var bitmap_font := BitmapFont.new()
	bitmap_font.height = font_h
	
	var font_path_1 : String = "res://assets/theme/fonts/font_data/pixel-frog/Small Text/color inverted/"
	
	var font_textures := _get_font_textures_from_path(font_path_1)
	
	var count : int = 0
	for font_texture in font_textures:
		# add 1px edge to the right side of the image
#		var img : Image = font_texture.get_data()
#		var new_img = Image.new()
#		new_img.create(font_w + 1, font_h, img.has_mipmaps(), img.get_format())
#		img.lock()
#		new_img.lock()
#		for i in font_w:
#			for j in font_h:
#				new_img.set_pixel(i, j, img.get_pixel(i, j))
#		new_img.save_png("res://assets/theme/fonts/font_data/pixel-frog/Small Text/border/%s.png" % str(count).pad_zeros(2))

		# invert font color (to white)
#		var img : Image = font_texture.get_data()
#		var new_img = Image.new()
#
#		new_img.create(
#			img.get_width(),
#			img.get_height(),
#			img.has_mipmaps(),
#			img.get_format()
#		)
#
#		new_img.lock()
#		img.lock()
#		for i in font_w:
#			for j in font_h:
#				new_img.set_pixel(i, j, img.get_pixel(i, j).inverted())
#
#		img.unlock()
#		new_img.unlock()
#		new_img.save_png("res://assets/theme/fonts/font_data/pixel-frog/Small Text/color inverted/%s.png" % str(count).pad_zeros(2))

		bitmap_font.add_texture(font_texture)
		count += 1

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
