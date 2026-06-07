extends Node3D
var night = 0
var target_rot_D = 0
var lapsedoor = 0.0
var light_state = true
var door_state = true
var door_health = 100
var window = 2
var speaker = false
@onready var player = $Player
@onready var notscript = get_node("/root/variables")
@onready var light = $OmniLight3D
@onready var door = $door
func _ready() -> void:
	night = notscript.get_night()
	$"spawning handler".set_enemy_level(night)
func _process(delta: float) -> void:	
	door.rotation.y = lerp_angle(deg_to_rad(door.rotation_degrees.y), deg_to_rad(target_rot_D), (lapsedoor))
	lapsedoor += delta
	if lapsedoor >= 1:
		lapsedoor = 1
	if speaker == true and $static/static.is_playing() == false:
		$static/static.play()
	if speaker == false:
		$static/static.stop()
func _on_player_clicked(object: Variant) -> void:
	if object.has("collider"):
		if object["collider"] == $CSGBox3D6/Area3D:
			_light_switch_click()
		if object["collider"] == $doorhitbox:
			door_click()
		if object["collider"] == $phone/phonehb:
			phone_click()
		if object["collider"] == $CSGCylinder3D2/dronecb:
			drone_click()
		if object["collider"] == $speaker/speakerhb:
			speaker_click()
		if object["collider"].has_method("food"):
			player.hunger += 10
			object["collider"].delete()
	else:
		pass
func _light_switch_click() -> void:
	if light_state == true:
		light.light_energy = 0.0
		light_state = false
	else:
		light_state = true
		light.light_energy = 5.0

func door_click() -> void:
	if door_health <= 0:
		return
	lapsedoor = 0
	if door_state == true:
		door_state = false
		target_rot_D = 90
	else:
		door_state = true
		target_rot_D = 0
func door_hit(dmg) -> void:
	door_health -= dmg
	if door_health <= 0:
		door_state = false
		$door.visible = false
		$CSGCylinder3D.visible = false
func phone_click()	->	void:
	$"phone timer".start()
func window_hit() -> void:
	window -= 1
	if window <= 0:
		$window.visible = false
func speaker_click() -> void:
	speaker = speaker == false
		
		
	

func _on_button_pressed() -> void:
	target_rot_D = 0
	lapsedoor = 0.0
	light_state = true
	door_state = true
	door_health = 100
	window = 2
	$window.visible = true
	$door.visible = true
	$CSGCylinder3D.visible = true
	$"spawning handler".restart()
	light.light_energy = 5.0
	$Player.restart()
	


func _on_phone_timer_timeout() -> void:
	pass
func drone_click() -> void:
	$CSGCylinder3D2.begone_drone_scum()


func _on_timer_timeout() -> void:
	$screen/Label2.visible = true
	notscript.set_night(night + 1)
	notscript.save_game()
