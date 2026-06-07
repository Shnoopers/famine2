extends CSGCylinder3D
var state = "idle"
var speed = 3
var angle = Vector3(0.21109, 0.0, -0.977467)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector3(-6.866, 2.518, 3.923)
	print(Vector3(3, 0, -.1).normalized())
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "idle":
		return
	visible = true
	if $"..".light_state == false:
		visible = false
	position += speed * angle * delta
	if $"../spawning handler".air == "dragonfly" and state == "in air":
		position = Vector3(-6.866, 2.518, 3.923)
		state = "idle"
func _on_phone_timer_timeout() -> void:
	if state != "idle":
		return
	state = "in air"
	position = Vector3(-6.866, 2.518, 3.923)
	angle = Vector3(0.21109, 0.0, -0.977467)

func _on_dronehb_area_entered(area: Area3D) -> void:
	if area == $dronecb:
		return
	if state == "in air":
		state = "entering"
		angle = Vector3(0.999445, 0.0, -0.033315)
	elif state == "entering":
		if $"..".door_state == true:
			$"..".door_hit(50)
			$"../thump".play()
			print("hit!")
			angle = Vector3(0.21109, 0.0, -0.977467)
			position = Vector3(-6.866, 2.518, 3.923)
			state = "idle"
		else:
			state = "in house"
	elif state == "leaving":
		if $"..".door_state == true:
			$"..".door_hit(50)
			$"../thump".play()
			print("hit!")
			visible = false
			state = "idle"
			angle = Vector3(0.21109, 0.0, -0.977467)
			position = Vector3(-6.866, 2.518, 3.923)
		else:
			state = "idle"
			angle = Vector3(0.21109, 0.0, -0.977467)
			position = Vector3(-6.866, 2.518, 3.923)
	elif state == "in house":
		angle = Vector3.ZERO 		
		state = "deliver"
func begone_drone_scum() -> void:
	if state != "deliver":
		print(state)
		return
	angle = Vector3(-0.999445, -0.0, 0.033315)
	state = "leaving"
	$"../Food handler".spawn_food()
	
