extends Node3D
func _ready():
	%Play.pressed.connect(play)
	%Quit.pressed.connect(quit)
func play():
	SceneTransition.change_scene("res://scenes/loading.tscn")
func quit():
	get_tree().quit()
