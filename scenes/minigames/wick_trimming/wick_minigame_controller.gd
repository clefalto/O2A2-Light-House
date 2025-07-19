extends Control

@export var minigames: Array[Control]

@onready var active_minigame: int = 0

var mg_time_scale: float = 1.0

@export var max_overlay_transparency: float = 0.50
var overlay_transparency: float = 0.0

signal finished

func _ready():
	for mg in minigames:
		mg.completed.connect(enable_next_mg)
		mg.did_it_badly.connect(did_a_mg_badly)
	minigames[active_minigame].enable()

func _process(delta: float):
	if (mg_time_scale < 1.0):
		mg_time_scale += delta
	overlay_transparency = clampf(overlay_transparency - delta * 0.3, 0.0, max_overlay_transparency)
	$FailOverlay.color = Color($FailOverlay.color, overlay_transparency)

func enable_next_mg():
	if active_minigame == minigames.size() - 1:
		$ShakeableCamera.add_trauma(0.75)
		finish_minigames()
	else:
		$ShakeableCamera.add_trauma(0.75)
		minigames[active_minigame].disable()
		active_minigame += 1
		minigames[active_minigame].enable()

func did_a_mg_badly():
	$ShakeableCamera.add_trauma(1.0)
	overlay_transparency = clampf(overlay_transparency + 0.1, 0.0, max_overlay_transparency)
	mg_time_scale = clampf(mg_time_scale - 0.3, 0.0, 1.0)

func finish_minigames():
	print("done! yay!")
	var timer = get_tree().create_timer(2.0)
	await timer.timeout
	finished.emit()
	self.queue_free()
