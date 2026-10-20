extends AnimatableBody3D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var area: Area3D = $Area3D


var player_on_platform := false
var at_destination := false


func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	anim.animation_finished.connect(_on_animation_finished)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_on_platform = true
		$Label.visible = true   # in _on_body_entered


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_on_platform = false
		$Label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_on_platform and not anim.is_playing():
		if at_destination:
			anim.play_backwards("move")
		else:
			anim.play("move")


func _on_animation_finished(_anim_name: StringName) -> void:
	at_destination = not at_destination
