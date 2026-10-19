extends RigidBody3D
@onready var prompt_label: Label3D = $Label3D
@onready var onScreenMsg: Label = $Label
var has_interacted = false

func _ready() -> void:
	onScreenMsg.modulate.a = 0.0   # start fully transparent

func interact(player):
	if has_interacted:
		return
	has_interacted = true
	print("interaggito")
	hide_prompt()
	show_msg()
	player.increment_counter()
	#qui poi faccio spawnare il particle effect, e rimuovo il shine dell'oggetto
	var particlesMain = $ParticleMagic/main
	var particlesSmoke = $ParticleMagic/Smoke
	var particlesSparks = $ParticleMagic/sparks
	particlesMain.emitting = true
	particlesSmoke.emitting = true
	particlesSparks.emitting = true
	particlesSmoke.restart()
	particlesSparks.restart()
	particlesMain.restart()

func show_prompt():
	if has_interacted:
		return
	prompt_label.visible = true

func hide_prompt():
	prompt_label.visible = false
	
func show_msg():
	onScreenMsg.visible = true
	var tween := create_tween()
	tween.tween_property(onScreenMsg, "modulate:a", 1.0, 0.3)   # fade in
	tween.tween_interval(3.0)                                    # stay visible
	tween.tween_property(onScreenMsg, "modulate:a", 0.0, 0.5)   # fade out
	tween.tween_callback(func(): onScreenMsg.visible = false)
