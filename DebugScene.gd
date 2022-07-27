extends Node2D

func _ready():
    var card_scene = preload("res://Card.tscn")
    var card1 = card_scene.instance()
    card1.setup("Squirrel")
    card1.update_display()
    $HBoxContainer.add_child(card1)
    var card2 = card_scene.instance()
    card2.setup("RingWorm")
    card2.update_display()
    $HBoxContainer.add_child(card2)
    var card3 = card_scene.instance()
    card3.setup("Raven")
    card3.update_display()
    $HBoxContainer.add_child(card3)
