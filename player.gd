extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const sense_horizontal = 0.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var boom_force = Vector3(0,0,0)
var capture_mouse = true

@onready var anim_player = $AnimationPlayer
@onready var hitbox = $WeaponPivot/hammer_00/Hitbox
@onready var hammerplosion = $WeaponPivot/hammer_00/Hammerplosion
@onready var camera = $Pivot/SpringArm3D/Camera3D

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		camera.make_current()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		if capture_mouse: 
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		capture_mouse != capture_mouse
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sense_horizontal))

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	velocity = velocity + boom_force
	boom_force = Vector3(0,0,0)

	move_and_slide()

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		anim_player.play("Attack")
		print("Monitoring now true")
		hammerplosion.monitoring = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		anim_player.play("Idle")
		hammerplosion.monitoring = false

func _on_hitbox_area_entered(area):
	print(area.get_groups())
	if area.is_in_group("enemy"):
		print("Enemy hit")

func _on_hammerplosion_body_entered(body):
	if body.is_in_group("enemy"):
		print("Enemy hit from hammer plosion")
		body.hit_by_hammer(hammerplosion.global_transform.origin, 25)

func hit_by_hammer(source, force):
	print("Heres the loc : ", source)
	boom_force = (source - global_transform.origin).normalized() * force
