extends Resource

class_name Mark
export var is_visible: bool
export var name: String

func on_to_hand(owner: Card):
    print("base")
