extends Node

var night = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()
func set_night(number) -> void:
	night = number
	print(night)
func get_night() -> int:
	return night
func save_game() -> void:
	var savefile = FileAccess.open("user://savegame.save",FileAccess.WRITE)
	var savedata = {"night":night}
	var jsonstring = JSON.stringify(savedata)
	savefile.store_line(jsonstring)
func load_game() -> void:
	var savefile = FileAccess.open("user://savegame.save",FileAccess.READ)
	var jsonstring = savefile.get_line()
	var json = JSON.new()
	var data = json.parse(jsonstring)
	var save = json.data
	night = save["night"]
	print(save)
