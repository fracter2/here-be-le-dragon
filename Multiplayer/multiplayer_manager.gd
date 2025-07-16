extends Node

## "Default" as in used by the tutorial i refrence'd, "Add Multiplayer to your Godot Game!" by BatteryAcidDev
const DEFAULT_PORT = 8080
const LOCALHOST_IP = "127.0.0.1"
const PORT_MAX = 65535

var helicopter_preload = preload("res://Content/Helicopter.tscn")
var _players_spawn_node : Node3D

signal player_joined(id: int)
signal player_left(id: int)


func become_host(port:int = 8080):
	print("Starting host!")
	print("Port: " + str(port))
	
	if not is_valid_port(port, true): return
	_players_spawn_node = get_tree().current_scene.get_node("Players")
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(port)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	_remove_single_player()
	_add_player_to_game(1)	# Since connect signal doesn't fire for server... and server id is always 1


func join(ip: String, port: int):
	print("Joining!")
	print("IP: %s" %ip)
	print("Port: %s" %port)
	
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(ip, port)
	
	multiplayer.multiplayer_peer = client_peer
	
	_remove_single_player()


func _add_player_to_game(id: int):
	print("Player %s joined the game!" % id)
	
	var player_to_add = helicopter_preload.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	_players_spawn_node.add_child(player_to_add)
	
	player_joined.emit(id)


func _del_player(id: int):
	print("Player %s left the game!" % id)
	
	if not _players_spawn_node.has_node(str(id)): return
	_players_spawn_node.get_node(str(id)).queue_free()
	
	player_left.emit(id)


func _remove_single_player():
	print("Remove single player")
	var player_to_remove = get_tree().current_scene.get_node("Singleplayer Helicopter")
	player_to_remove.queue_free()


func is_valid_port(n:int, print_error: bool = false):
	if n > PORT_MAX:
		if (print_error): push_error("Port above int16 limit! Port in question: " + str(n))
		return false
	if n < 0: 
		if (print_error): push_error("Port is less than 0! Bad! Port in question: " + str(n))
		return false
	
	return true
