extends Control
class_name Card

# 引用到cards/xx.tres作为自己的基础信息
export var base_card: String
var card_resource: CardResource

func _ready():
    card_resource = load("res://cards/%s.tres" % [base_card]).duplicate()
    print(card_resource.name)
    update_display()
    
func update_display():
    $VBoxContainer/Top/Name.text = card_resource.name
    $VBoxContainer/Top/Cost.text = str(card_resource.cost)
    $VBoxContainer/Bottom/Attack.text = str(card_resource.attack)
    $VBoxContainer/Bottom/Hp.text = str(card_resource.hp)
    var marks = $VBoxContainer/Marks
    assert(len(card_resource.marks) <= marks.get_child_count())
    var ui_index = 0
    for i in range(len(card_resource.marks)):
        var mark = marks.get_child(ui_index)
        var mark_resource = card_resource.marks[i]
        if mark_resource.is_visible:
            mark.visible = true
            mark.text = mark_resource.name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
