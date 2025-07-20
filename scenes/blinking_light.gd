extends Node2D

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:String):
	if argument == "blackout":
		print("Something was activated!")
		$AnimationPlayer.play("fadeToBlack")
	elif argument == "blackno":
		print("See the light")
		$AnimationPlayer.play("fadeToNormal")
	elif argument == "blinking":
		$AnimationPlayer.play("blinking")
