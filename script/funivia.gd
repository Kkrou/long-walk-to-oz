extends AnimatableBody3D

@export var prompt: Label
@export var fade_time := 0.25

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var area: Area3D = $Area3D

var player_on_platform := false
var at_destination := false
var fade_tween: Tween


func _ready() -> void:
	prompt.modulate.a = 0.0
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	anim.animation_finished.connect(_on_animation_finished)



func _fade_prompt(target_alpha: float) -> void:
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(prompt, "modulate:a", target_alpha, fade_time)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_on_platform = true
		_fade_prompt(1.0)  # fade in on entering


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_on_platform = false
		_fade_prompt(0.0)  # fade out if they leave without pressing E


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_on_platform and not anim.is_playing():
		_fade_prompt(0.0)  # fade out once E is pressed
		if at_destination:
			anim.play_backwards("move")
		else:
			anim.play("move")


func _on_animation_finished(_anim_name: StringName) -> void:
	at_destination = not at_destination
