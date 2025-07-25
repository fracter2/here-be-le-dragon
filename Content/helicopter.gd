class_name Helicopter extends RigidBody3D

@export var player_id:int = 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

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
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = %InputSynchronizer
@onready var wings: CSGBox3D = $CollisionShape3D/Wings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player_id == multiplayer.get_unique_id():
		$Camera3D.make_current()


func _physics_process(_delta: float) -> void:
	if not multiplayer.is_server(): return
	
	var input_pitch:float = multiplayer_synchronizer.input_pitch
	var input_barrel:float = multiplayer_synchronizer.input_barrel
	var input_yaw:float = multiplayer_synchronizer.input_yaw
	var input_thrust:float = multiplayer_synchronizer.input_thrust
	
	var rot:Vector3 = Vector3(input_pitch * rotation_pitch, input_yaw * rotation_yaw, input_barrel * rotation_barrel)
	if multiply_by_mass: rot *= mass
	apply_torque(basis * rot)
	
	var thrust: Vector3 = (Vector3.UP * input_thrust * thrust_up)
	if multiply_by_mass: thrust *= mass
	apply_central_force(basis * thrust)
	
	input_display.text = "rot: " + str(rot) + "\thrust: " + str(thrust)
	



@rpc("any_peer", "call_local", "reliable")
func sync_colors(primary_c:Color, secondary_c:Color):
	$CollisionShape3D/Body.material.albedo_color = primary_c
	
	$CollisionShape3D/Body/SpotLight3D.light_color = secondary_c
	$CollisionShape3D/Body/SpotLight3D2.light_color = secondary_c
	$"CollisionShape3D/Body/Cockpit Light".light_color = secondary_c
	
	$"CollisionShape3D/TailJoint/Tail/Tail light".light_color = secondary_c
	$"CollisionShape3D/TailJoint/Tail/Tail light Specular".light_color = secondary_c
	$CollisionShape3D/TailJoint/TailEnd.material.albedo_color = secondary_c
	

@rpc("any_peer", "call_local", "reliable")
func sync_name(new_name:String):
	$VehicleLabel.text = new_name
