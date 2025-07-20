extends Control

var chapter_timelines: Array[String] = ["chapter-1", "chapter-2", "chapter-3", "chapter-4", "finale"] # man if only there was an easier way to do this -jason "thor" hall

var current_chapter := 0

@export var scn_wick_minigame: PackedScene
@export var scn_oil_minigame: PackedScene

func _ready():
	# just start chapter 1 as soon as this scene loads
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.signal_event.connect(_on_dialogic_signal)
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
	$blinkingLight.visible = false
	$CanvasModulate.visible = false
	var mg = scn_wick_minigame.instantiate() # hopefully it closes itself!
	self.add_child(mg)
	mg.finished.connect(cb_on_ended)

func load_oil_minigame():
	var mg = scn_oil_minigame.instantiate()
	mg.get_node("Control").night = current_chapter+1
	self.add_child(mg)
	mg.get_node("Control").finished.connect(_on_oil_minigame_ended)


func _on_oil_minigame_ended():
	# TODO: do the oil or do it the other way around
	start_new_timeline()


func start_new_timeline():
	# spaghetti time :)
	$blinkingLight.visible = true
	$CanvasModulate.visible = true
	#Dialogic.clear()
	$screenLights.fade_from_black()
	#$blinkingLight.do_light_up_thing()
	#$AudioStreamPlayer.play()
	#await $AudioStreamPlayer.finished
	#$blinkingLight/PointLight2D.visible = false
	#$screenLights.fade_to_black()
	#await $screenLights/AnimationPlayer.animation_finished
	# _on_timeline_ended is already connected to Dialogic.timeline_ended so we dont need to do taht
	current_chapter += 1
	if current_chapter < chapter_timelines.size():
		Dialogic.start(chapter_timelines[current_chapter])
		# fuckin idk
		#$blinkingLight/PointLight2D.visible = true
		#$blinkingLight/AnimationPlayer.play("RESET")
	else:
		# this should never be executed
		assert(false, "how the fuck did you get here")



func _on_dialogic_signal(argument:String):
	if argument == "blackout":
		print("Something was activated!")
		var tw = get_tree().create_tween()
		tw.tween_property($CanvasModulate, "color", Color.BLACK, 1.0)
	elif argument == "blackno":
		var tw = get_tree().create_tween()
		tw.tween_property($CanvasModulate, "color", Color("#8b8b8b"), 1.0)
