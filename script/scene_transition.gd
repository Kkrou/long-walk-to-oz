extends Node

var transition_layer: CanvasLayer

func _ready() -> void:
	var transition_scene = preload("res://scenes/Transition.tscn")
	transition_layer = transition_scene.instantiate()
	get_tree().root.add_child.call_deferred(transition_layer)

func change_scene(path: String, fade_duration: float = 0.4) -> void:
	await transition_layer.fade_to_black(fade_duration)
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	await transition_layer.fade_from_black(fade_duration)

func change_scene_packed(scene: PackedScene, fade_duration: float = 0.4) -> void:
	await transition_layer.fade_to_black(fade_duration)
	get_tree().change_scene_to_packed(scene)
	await get_tree().process_frame
	await transition_layer.fade_from_black(fade_duration)
