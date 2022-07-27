extends Control
class_name Card

var card_resource: CardResource
# 是否携带额外的标记，印过的卡，或者奖励的多标记卡，将无法再次印卡
var has_extra_mark: bool
    
func setup(base_card: String):
    card_resource = load("res://cards/%s.tres" % [base_card]).duplicate()
    print(card_resource.name)
    
func update_display():
    $VBoxContainer/Top/Name.text = card_resource.name
    $VBoxContainer/Top/Cost.text = str(card_resource.cost)
    $VBoxContainer/Bottom/Attack.text = str(card_resource.attack)
    $VBoxContainer/Bottom/Hp.text = str(card_resource.hp)
    var marks = $VBoxContainer/Marks
    assert(len(card_resource.marks) <= marks.get_child_count())
    for i in range(len(card_resource.marks)):
        var mark = marks.get_child(i)
        var mark_resource = card_resource.marks[i]
        mark.visible = true
        mark.text = mark_resource.name
        
# 印卡other_card到自己身上
# other_card将损失hidden_marks
func trasfer_mark(other_card: Card):
    assert(not other_card.has_extra_mark)
    assert(not self.has_extra_mark)
    self.card_resource.marks.append_array(other_card.card_resource.marks)
