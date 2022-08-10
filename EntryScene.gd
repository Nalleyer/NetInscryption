extends Node2D

func _ready():
    if OS.has_feature("client"):
        get_tree().change_scene("res://Desk.tscn")
    elif OS.has_feature("server"):
        get_tree().change_scene("res://Server.tscn")
