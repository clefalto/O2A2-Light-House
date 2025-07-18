extends TextEdit

@export var howManyClicks: int = 10

func decreaseNum():
	howManyClicks -= 1
	displayNum()
	
func displayNum():
	self.set_text(str(howManyClicks))


func _on_button_pressed() -> void:
	decreaseNum()
