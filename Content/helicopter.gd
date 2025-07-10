extends RigidBody3D

@export var speed_pitch:float = 10
@export var speed_barrel:float = 10
@export var speed_yaw:float = 10
@export var speed_thrust:float = 10

@export var flip_pitch : float = 1


@onready var debug_thrust_pointer: MeshInstance3D = $DebugThrustPointer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	
	## check if this client is the multiplayer authority? skip if not?
	
	if Input.is_action_just_pressed(&"flip_pitch"): flip_pitch = flip_pitch * -1
	
	var input_pitch:float = Input.get_axis(&"pitch_down", &"pitch_up") * flip_pitch
	var input_barrel:float = Input.get_axis(&"barrel_right", &"barrel_left")
	var input_yaw:float = Input.get_axis(&"yaw_right", &"yaw_left")
	var input_thrust:float = Input.get_axis(&"thrust_down", &"thrust_up")
	
	var rot:Vector3 = Vector3(input_pitch * speed_pitch, input_yaw * speed_yaw, input_barrel * speed_barrel)
	
	# Rotate the "rotation force" by the actual rotation (hopefully making it into local-rotation)
	#var rot_matrix: Basis = 
	
	#var qua: Quaternion = global_basis.get_rotation_quaternion().normalized()
	#var rot_matrix: Transform3D
	#var rotaded_rot: Vector3 = rot * basis.orthonormalized()
	#transform.basis.get_rotation_quaternion()
	#transform.rotated_local().basis.get_rotation_quaternion()
	# rotate "rot" by local-space rotation
	
	
	var new_tr: Transform3D = Transform3D(transform)
	new_tr = new_tr.rotated_local(Vector3.RIGHT, rot.x * delta)
	new_tr = new_tr.rotated_local(Vector3.UP, rot.y * delta)
	new_tr = new_tr.rotated_local(Vector3.FORWARD, rot.z * delta)
	
	#transform.basis = new_tr.basis.orthonormalized()
	apply_torque(basis * rot)
	
	#var rotaded_thrust: Vector3 = (Vector3.UP * input_thrust * speed_thrust) * global_basis
	var rotaded_thrust: Vector3 = (Vector3.UP * input_thrust * speed_thrust) * basis.orthonormalized()
	#apply_central_force(Vector3.UP * input_thrust * speed_thrust)
	apply_central_force(rotaded_thrust)
	debug_thrust_pointer.position = basis.orthonormalized() * (4 * Vector3.UP)
	
