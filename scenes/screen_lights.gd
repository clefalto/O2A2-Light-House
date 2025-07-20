extends Node2D

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:String):
	if argument == "screenBlack":
		print("Something was activated!")
		$AnimationPlayer.play("fadeToBlack")
	elif argument == "screenNorm":
		print("screen is chill")
		$AnimationPlayer.play("fadeToNormal")
