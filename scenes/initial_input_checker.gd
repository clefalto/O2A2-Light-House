extends Control

func _input(event: InputEvent):
	if Dialogic.current_timeline != null:
		return
	
	if Input.is_action_just_pressed("dialogic_default_action"):
		Dialogic.start('test')
		get_viewport().set_input_as_handled()
