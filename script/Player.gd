extends CharacterBody3D
#hold constants
const MAX_HOLD_DISTANCE = 1.5 
#movement constants
const SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
#bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var hand = $Head/Camera3D/Hand
var held_object: RigidBody3D = null
var current_interactable = null
var interact_counter = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# Controlla se è stato premuto il tasto ESC
	if event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.keycode == KEY_ESCAPE):
		if event.pressed:
			# Se era bloccato, lo libera. Se era libero, lo blocca di nuovo (opzionale)
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		activate()
	if Input.is_action_just_pressed("pickup"):
		if held_object == null:
			if raycast.is_colliding():
				var object = raycast.get_collider()
				if object.is_in_group("pickable"):
					pick_up(object)
		else:
			drop()

func check_hover_collision():
	if raycast.is_colliding():
		var hover_collider = raycast.get_collider()
		if hover_collider and hover_collider != held_object and is_instance_valid(hover_collider) and hover_collider.has_method("interact"):
			if current_interactable != hover_collider:
				if current_interactable:
					current_interactable.hide_prompt()
				current_interactable = hover_collider
				current_interactable.show_prompt()
		else:
			hide_current_prompt()
	else:
		hide_current_prompt()

func hide_current_prompt():
	if current_interactable:
		current_interactable.hide_prompt()
		current_interactable = null

func activate():
	var hit = raycast.get_collider()
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and raycast.is_colliding():
		if hit and hit != held_object and hit.has_method("interact"):
			hit.interact(self)

func increment_counter():
	interact_counter += 1
	print("Counter: ", interact_counter) 
	 # sostituiscilo con l'update della tua UI
	var Memories_Counter = $"../Memories Counter"
	Memories_Counter.text = "Memories: " + str(interact_counter)


func pick_up(object):
	held_object = object
	held_object.collision_layer = 2
	held_object.gravity_scale = 0
	held_object.angular_damp = 10.0  # helps stop it spinning wildly, tweak to taste
	hide_current_prompt()  # in case it was also an interactable, clear any prompt

func drop():
	held_object.gravity_scale = 1
	held_object.collision_layer = 1  # adjust to whatever your default layer is
	held_object.angular_damp = 1
	held_object.angular_velocity = Vector3.ZERO
	held_object = null

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	# Hold logic: move the held object toward the hand every physics tick
	if held_object:
		var to_hand = hand.global_position - held_object.global_position
		if to_hand.length() > MAX_HOLD_DISTANCE:
			drop()
		else:
			held_object.linear_velocity = to_hand / delta
			var target_basis = hand.global_transform.basis
			held_object.angular_velocity = (target_basis * held_object.global_transform.basis.inverse()).get_euler() / delta
#bob code
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	move_and_slide()

	check_hover_collision()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
