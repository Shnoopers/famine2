extends Node
var foodobj = load("res://food.tscn")
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func spawn_food() -> void:
	var food = foodobj.instantiate()
	food.position = Vector3(-2.6,2.5,2.4)
	add_child(food)
	
