extends Control

@export var night: int = 1
@export var howManyClicks: int = 10
@export var currDialogue: bool = false

signal finished

func _ready() -> void:
	$"../GPUParticles2D".amount_ratio = 0.01
	if night == 1:
		howManyClicks = 10
	elif night == 2:
		howManyClicks = 20
	elif night == 3:
		howManyClicks = 30
	elif night == 4:
		howManyClicks = 1000000000
	if Dialogic.current_timeline != null:
		return
	currDialogue = true
	Dialogic.start('oil')
	Dialogic.VAR.set_variable("NumOil", howManyClicks)
	pass

func _on_button_pressed() -> void:
	if currDialogue != false:
		var oilCount = Dialogic.VAR.get_variable("NumOil")
		print(oilCount)
		oilCount -= 1
		Dialogic.VAR.set_variable("NumOil", oilCount)
		$"../GPUParticles2D".amount_ratio += 0.02
		if oilCount <= 0:
			finished.emit()
			get_parent().queue_free()
		if night == 4 && oilCount < (1000000000-20):
			finished.emit()
			get_parent().queue_free()
	pass # Replace with function body.
