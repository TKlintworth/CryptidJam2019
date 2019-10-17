extends MarginContainer

export var new_game = "res://Level.tscn"
#export var profiles = preload()
#export var options = preload()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_NewGame_button_down() -> void:
	# Go to New Game
	GameManager.goto_scene(new_game)
	


func _on_Profiles_button_down() -> void:
	# Go to profiles
	pass # Replace with function body.


func _on_Options_button_down() -> void:
	# Go to options
	pass # Replace with function body.


func _on_Quit_button_down() -> void:
	# Quit to desktop
	pass # Replace with function body.
