extends Node3D


@export var respawn_pos: Node3D 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#MultiplayerManager.player_joined.connect(sync_players)
	assert(respawn_pos != null, "SET RESPAWN NODE IN PLAYER_ENTITY_MANAGER")
	(%RespawnButton as Button).pressed.connect(request_respawn)


func _player_colors_changed(_color:Color = Color.WHITE):
	var player: Helicopter = get_heli_of_id(multiplayer.get_unique_id())
	if player == null: 
		print("no vehicle found")
		return
	
	Settings.color_primary = %ColorPrimary.color
	Settings.color_secondary = %ColorSecondary.color
	player.sync_colors.rpc(Settings.color_primary, Settings.color_secondary)

func _player_custom_name_changed(_new_text:String = ""):
	var player: Helicopter = get_heli_of_id(multiplayer.get_unique_id())
	if player == null: 
		print("no vehicle found")
		return
	
	Settings.vehicle_name = %VehicleName.text
	player.sync_name.rpc(Settings.vehicle_name)


func get_heli_of_id(id:int) -> Helicopter:
	for child in get_children():
		if child is Helicopter:
			if child.player_id == id: return child
	
	return null


@rpc("any_peer", "call_local", "reliable")
func sync_players():
	print("Syncing between all players")
	_player_colors_changed()
	_player_custom_name_changed()


func _on_multiplayer_spawner_spawned(_node: Node) -> void:
	sync_players.rpc()

	

func request_respawn():
	if multiplayer.is_server():
		respawn_heli(multiplayer.get_unique_id())
	else:
		respawn_heli.rpc_id(1, multiplayer.get_unique_id())	# Server id


@rpc("any_peer", "call_remote", "reliable")
func respawn_heli(id: int):
	get_heli_of_id(id).global_position = respawn_pos.global_position
	
