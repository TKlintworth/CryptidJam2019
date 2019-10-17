extends Control




func _on_Text_pressed() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	GameManager.goto_scene("res://MainMenu.tscn")
