extends Node3D
var target_x_rot = 0
var target_y_rot = 90
var target_z_rot = 0
var target_x_pos = 0.0
var target_y_pos = 2.0
var target_z_pos = 0.0
var lapseR = 0.0
var	lapseP = 0.0
var hunger = 100
var POV = "Chair"
@onready var camera = $Camera3D
@onready var hud = $HUD
signal clicked(object)
func _point(x, y, z):
	target_x_rot = x
	target_y_rot = y
	target_z_rot = z
	lapseR = 0
func _move(x, y, z):
	target_x_pos = x
	target_y_pos = y
	target_z_pos = z
	lapseP = 0
func _interactable():
	var mousepos = get_viewport().get_mouse_position()
	var space_state = get_world_3d().direct_space_state
	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * 1000
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	clicked.emit(result)
	print(result)
	if result == null:
		pass
	else:
		hunger -= 1




	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation.x = lerp_angle(deg_to_rad(rotation_degrees.x), deg_to_rad(target_x_rot), (lapseR))
	rotation.y = lerp_angle(deg_to_rad(rotation_degrees.y), deg_to_rad(target_y_rot), (lapseR))
	rotation.z = lerp_angle(deg_to_rad(rotation_degrees.z), deg_to_rad(target_z_rot), (lapseR))
	position.x = lerp((position.x), float(target_x_pos), (lapseP))
	position.y = lerp((position.y), float(target_y_pos), (lapseP))
	position.z = lerp((position.z), float(target_z_pos), (lapseP))
	#self.pos = Vector3(0, 0, 0)
	#camera.FOV = 75
	if hunger > 0:
		lapseR += delta * hunger/100
		lapseP += delta * hunger/100
	if lapseR >= 1:
		lapseR = 1
	if lapseP >= 1:
		lapseP = 1
	if Input.is_action_just_pressed("Chair"):
		POV = "Chair"
		hunger -= 1
		_point(0, 90, 0)
		_move(0, 2, 0)
	if Input.is_action_just_pressed("Window") and POV == "Chair":
		POV = "Window"
		hunger -= 1
		_point(0, 90, 0)
		_move(-3, 2, 0)
	if Input.is_action_just_pressed("Roof") and (POV == "Chair" or POV == "Table"):
		POV = "Roof"
		hunger -= 1
		_point(90, 90, 0)
		_move(0, 2, 0)
	if Input.is_action_just_pressed("Table") and (POV == "Chair" or POV == "Roof" or POV == "Fridge"):
		POV = "Table"
		hunger -= 1
		_point(-75, 90, 0)
		_move(0, 2, 0)
	if Input.is_action_just_pressed("Fridge") and (POV == "Chair" or POV == "Table"):
		POV = "Fridge"
		hunger -= 1
		_point(0, 0, 0)
		_move(0, 2, -1)
	if Input.is_action_just_pressed("Interact"):
		_interactable()
	
	$HUD/ColorRect.color.a = min(.9,(100-hunger)*.01)
func restart() -> void:
	target_x_rot = 0
	target_y_rot = 90
	target_z_rot = 0
	target_x_pos = 0.0
	target_y_pos = 2.0
	target_z_pos = 0.0
	lapseR = 0.0
	lapseP = 0.0
	POV = "Chair"
