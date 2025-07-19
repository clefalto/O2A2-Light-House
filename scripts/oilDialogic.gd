extends Control

@export var night: int = 1

func _ready() -> void:
	pass

func _input(event: InputEvent):
	if Dialogic.current_timeline != null:
		#var oilCount = get_node("/root/Dialogic").get_variable("NumOil")
		#oilCount-=1
		return
	
	if Input.is_action_just_pressed("dialogic_default_action"):
		print("wharg")
		var dialogueOil = Dialogic.start('oil')
		get_node("/root/OilMinigame").add_child(dialogueOil)
		# dialogueOil.get_child()
		
		# get_viewport().set_input_as_handled()
