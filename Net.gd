extends Node

var peer
# 其他所有端
var connected_peers = []
# 工作开始前记录是不是服务器
var is_server: bool = false
#  Server.gd or Desk.gd。干活全靠它。
var main_script

func init(is_server, main_script):
    peer = NetworkedMultiplayerENet.new()
    print('peer created')
    self.is_server = is_server
    self.main_script = main_script
    connect_net_signals()

func connect_net_signals():
    get_tree().connect("network_peer_connected", self, "_on_peer_connected")
    get_tree().connect("network_peer_disconnected", self,  "_on_peer_disconnected")
    get_tree().connect("connection_failed", self, "_on_connect_failed")
    if not is_server:
        get_tree().connect("connected_to_server", self, "_on_connect_server")

func _on_peer_connected(id):
    print("%s con" % [id])
    connected_peers.append(id)

func _on_peer_disconnected(id):
    print("%s dis" % [id])
    connected_peers.erase(id)
    if is_server:
        reset()
    else:
        if id == 1: # server
            main_script.on_disconnected_with_server()
        else:
            main_script.win()
            
# 客户端专属
func _on_connect_server():
    main_script.on_connect_server()

func reset():
    # 重置游戏和服务器状态
    pass

