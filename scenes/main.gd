extends Control

var chapter_timelines: Array[String] = ["chapter-1", "chapter-2", "chapter-3", "chapter-4", "finale"] # man if only there was an easier way to do this -jason "thor" hall

var current_chapter := 0

@export var scn_wick_minigame: PackedScene
@export var scn_oil_minigame: PackedScene
@export var scn_fucked_up_oil_minigame: PackedScene

func _ready():
	# just start chapter 1 as soon as this scene loads
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start(chapter_timelines[current_chapter])

func _on_timeline_ended():
	# if we're on the (second to) last chapter, fucking quit the game or something!
	if current_chapter >= chapter_timelines.size() - 2:
		if current_chapter == chapter_timelines.size() - 1:
			get_tree().quit()
		load_oil_minigame()
		print("good job!")
	else:
		# load minigame scene
		load_wick_minigame(load_oil_minigame)

func load_wick_minigame(cb_on_ended: Callable):
	var mg = scn_wick_minigame.instantiate() # hopefully it closes itself!
	self.add_child(mg)
	mg.finished.connect(cb_on_ended)

func load_oil_minigame():
	var mg = scn_oil_minigame.instantiate()
	mg.get_node("Control").night = current_chapter+1
	self.add_child(mg)
	mg.get_node("Control").finished.connect(_on_oil_minigame_ended)

# for the oil minigame that Is Fucked Up
func load_fucked_up_oil_minigame():
	pass

func _on_oil_minigame_ended():
	# TODO: do the oil or do it the other way around
	start_new_timeline()


func start_new_timeline():
	# _on_timeline_ended is already connected to Dialogic.timeline_ended so we dont need to do taht
	current_chapter += 1
	if current_chapter < chapter_timelines.size():
		Dialogic.start(chapter_timelines[current_chapter])
	else:
		# this should never be executed
		assert(false, "how the fuck did you get here")
