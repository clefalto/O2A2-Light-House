extends Control

func _input(event: InputEvent):
	if Dialogic.current_timeline != null:
		return
	
	if event is InputEventKey and event.keycode == KEY_ENTER and event.is_pressed():
		Dialogic.start('test')
		get_viewport().set_input_as_handled()
