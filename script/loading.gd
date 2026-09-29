extends Control
@onready var progress_bar = %ProgressBar
@onready var next_scene_path: String = "res://scenes/world.tscn"
var progress: Array[float] = []
var loading_finished := false

func _ready():
	ResourceLoader.load_threaded_request(next_scene_path)

func _process(delta):
	if loading_finished:
		return

	var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)

	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100
		ResourceLoader.THREAD_LOAD_LOADED:
			loading_finished = true
			progress_bar.value = 100
			var scene = ResourceLoader.load_threaded_get(next_scene_path)
			SceneTransition.change_scene_packed(scene)
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			loading_finished = true
			push_error("Failed to load scene: " + next_scene_path)
