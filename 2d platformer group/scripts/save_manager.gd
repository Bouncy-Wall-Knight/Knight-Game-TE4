extends Node
class_name SaveManager

const FILE_PATH := "user://main.ksave"
var player
var player_pos
#get_tree().get_current_scene()

func _ready():
	player = get_tree().get_root().get_node("World").get_node("player")
	print(get_tree().get_root().get_node("World").get_node("player"))
	player_pos = player.position
	if FileAccess.file_exists(FILE_PATH):
		print("file_exists")
		var content = load_r_save()
		var var_str = var_to_str(content)
		if var_str == null:
			save(var_to_str(player_pos))
			return
		player.set_position(str_to_var(content))
	else:
		print("file_non_existant")
		load_save()
		save(var_to_str(player_pos))

func _notification(what): 
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("eogame")
		player_pos = player.position
		save(var_to_str(player_pos))
		get_tree().quit()

func save(content):
	print("save_to_file")
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_string(content)

func load_r_save():
	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	print("laod_save")
	return content

func load_save():
	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
