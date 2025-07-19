extends Control

@export var minigames: Array[Control]

@onready var active_minigame: int = 0

func _ready():
	for mg in minigames:
		mg.completed.connect(enable_next_mg)
	minigames[active_minigame].enable()

func enable_next_mg():
	if active_minigame == minigames.size() - 1:
		finish_minigames()
	else:
		minigames[active_minigame].disable()
		active_minigame += 1
		minigames[active_minigame].enable()

func finish_minigames():
	print("done! yay!")
