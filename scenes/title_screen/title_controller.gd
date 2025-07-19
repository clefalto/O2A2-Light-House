extends Control

@export var main_scene: PackedScene = preload("res://scenes/main.tscn")

func _on_button_start_pressed() -> void:
	$AnimationPlayer.play("fadeToBlack")
	$AnimationPlayer.animation_finished.connect(func (anim_name: String): await get_tree().change_scene_to_packed(main_scene))


func _on_button_quit_pressed() -> void:
	get_tree().quit()
