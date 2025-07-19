extends Control

@export var night: int = 1
@export var howManyClicks: int = 10
var currDialogue

func _ready() -> void:
	if night == 1:
		howManyClicks = 10
	elif night == 2:
		howManyClicks = 20
	elif night == 3:
		howManyClicks = 40
	elif night == 4:
		howManyClicks = 1000000000
	if Dialogic.current_timeline != null:
		return
	currDialogue = Dialogic.start('oil')
	get_node("/root/OilMinigame").add_child(currDialogue)
	Dialogic.VAR.set_variable("NumOil", howManyClicks)
	pass

func _input(event: InputEvent):
	pass
	#if Dialogic.current_timeline != null:
		##var oilCount = get_node("/root/Dialogic").get_variable("NumOil")
		##oilCount-=1
		#return
	#
	#if Input.is_action_just_pressed("dialogic_default_action"):
		#print("wharg")
		#currDialogue = Dialogic.start('oil')
		#get_node("/root/OilMinigame").add_child(currDialogue)
		## dialogueOil.get_child()
		#
		## get_viewport().set_input_as_handled()


func _on_button_pressed() -> void:
	if currDialogue != null:
		var oilCount = Dialogic.VAR.get_variable("NumOil")
		print(oilCount)
		oilCount -= 1
		Dialogic.VAR.set_variable("NumOil", oilCount)
	pass # Replace with function body.
