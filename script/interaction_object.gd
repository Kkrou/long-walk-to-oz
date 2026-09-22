extends RigidBody3D
@onready var prompt_label: Label3D = $Label3D
var has_interacted = false

func interact(player):
	if has_interacted:
		return
	has_interacted = true
	print("interaggito")
	hide_prompt()
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
