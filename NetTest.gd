extends Control


var peer

var connected_peers = []
var connect_timer
# 服务器永远为false
var connected_to_server = false

# Called when the node enters the scene tree for the first time.
func _ready():
	peer = NetworkedMultiplayerENet.new()
	
	connect_net_signals()

func connect_net_signals():
	get_tree().connect("network_peer_connected", self, "_on_peer_connected")
	get_tree().connect("network_peer_disconnected", self,  "_on_peer_disconnected")
	get_tree().connect("connection_failed", self, "_on_connect_failed")
	get_tree().connect("connected_to_server", self, "_on_connect_server")

func update_peers_text():
	var s = "Connected Peers: ["
	for p in connected_peers:
		s += str(p) + ","
	$ConnectedPeers.text = s + "]"
	
func update_server_type_text(connected: bool, err):
	if err != null:
		$ServerTypeLabel.text = str(err)
		return
	if connected:
		$ServerTypeLabel.text = "Server?: %s" % [is_server()]
		
func get_peer_id():
	return get_tree().get_network_unique_id()

func update_peer_id_text(err):
	if err != null:
		$PeerIdLabel.text = str(err)
		return
	else:
		$PeerIdLabel.text = str(get_peer_id())

func is_server():
	return get_tree().is_network_server()

func _on_ServerInitButton_pressed():
	var err = peer.create_server(10233, 1)
	if err == OK:
		get_tree().network_peer = peer
		update_server_type_text(true, null)
		$DisconnectButton.visible = true
		$ClientInitButton.visible = false
		$ServerInitButton.visible = false
	else:
		update_server_type_text(false, err)
	update_peer_id_text(null)

func _on_ClientInitButton_pressed():
	var err = peer.create_client("127.0.0.1", 10233)
	if err == OK:
		get_tree().network_peer = peer
		update_peer_id_text("connect...")
		$ClientConnectTimer.start()
	else:
		update_server_type_text(false, err)
		update_peer_id_text("no connection")

func _on_peer_connected(id):
	print("%s con" % [id])
	connected_peers.append(id)
	update_peers_text()
	
func _on_peer_disconnected(id):
	print("%s dis" % [id])
	connected_peers.erase(id)
	update_peers_text()
	if not is_server() and id == get_tree().get_network_unique_id():
		$DisconnectButton.visible = false

func _on_DisconnectButton_pressed():
	var is_server = is_server()
	peer.close_connection()
	update_server_type_text(false, "null")
	$DisconnectButton.visible = false
	$ClientInitButton.visible = true
	$ServerInitButton.visible = true
	connected_peers = []
	update_peers_text()
	update_peer_id_text("null")
	
func _on_connect_failed():
	printerr("connect to server failed")
	connected_to_server = false
	update_server_type_text(false, "null")
	$DisconnectButton.visible = false
	$ClientInitButton.visible = true
	$ServerInitButton.visible = true
	
func _on_connect_server():
	print("connected to server")
	connected_to_server = true
	$DisconnectButton.visible = true
	$ClientInitButton.visible = false
	$ServerInitButton.visible = false
	update_server_type_text(true, null)
	$ClientConnectTimer.stop()
	update_peer_id_text(null)
	update_peers_text()


func _on_ClientConnectTimer_timeout():
	if not connected_to_server:
		peer.close_connection()
		update_server_type_text(false, "null")
		$DisconnectButton.visible = false
		$ClientInitButton.visible = true
		$ServerInitButton.visible = true
		connected_peers = []
		update_peers_text()
		update_peer_id_text("no connection")
