extends Node

var savefile = File.new()
var savepath = "user://savegame.save"
var savedata = {
		"level1": 0,
		"level2": -1,
		"level3": -1,
		"level4": -1,
		"level5": -1,
		"level6": -1
	}

var curLevel = 1
var stars = 0

func _ready():
	if not savefile.file_exists(savepath):
		save()
	read()

func save():
	savefile.open(savepath, File.WRITE)
	savefile.store_var(savedata)
	savefile.close()

func read():
	savefile.open(savepath, File.READ)
	savedata = savefile.get_var()
	savefile.close()

func save_level(level, stars):
	if level > 6:
		return 
	savedata["level" + str(level)] = stars