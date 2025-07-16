extends RigidBody3D

@export var player_id:int = 1:
	set(id):
		player_id = id

@export var flip_pitch : float = 1
@export var multiply_by_mass: bool = true

@export_group("Rotation", "rotation_")
@export var rotation_multiplier: float = 1
@export var rotation_pitch:float = 1
@export var rotation_barrel:float = 1
@export var rotation_yaw:float = 1

@export_group("Thrust", "thrust_")
@export var thrust_up:float = 4


@onready var debug_thrust_pointer: MeshInstance3D = $DebugThrustPointer
@onready var input_display: Label = $UI/InputDisplay

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
	
	var rot:Vector3 = Vector3(input_pitch * rotation_pitch, input_yaw * rotation_yaw, input_barrel * rotation_barrel)
	if multiply_by_mass: rot *= mass
	apply_torque(basis * rot)
	
	var thrust: Vector3 = (Vector3.UP * input_thrust * thrust_up)
	if multiply_by_mass: thrust *= mass
	apply_central_force(basis * thrust)
	
	input_display.text = "rot: " + str(rot) + "\thrust: " + str(thrust)
	
