extends Node
@onready var main = $".."
var agressions = {"mantis" : 0, "roach" : 0, "beetle" : 0, "carverant" : 0, "dragonfly" : 20, "spider" : 0}
var minmov = {"mantis" : 2, "roach" : 3, "beetle" : 5, "carverant" : 2, "dragonfly" : 1, "spider" : 4}
var phasecount = {"mantis" : 1, "roach" : 2, "beetle" : 2,"carverant" : 1, "dragonfly" : 1, "spider" : 3}
@onready var timers = {"mantis" : $"Mantis timer", "roach" :  $"Roach timer", "beetle" : $"Beetle timer", "carverant" : $"Carverant timer","dragonfly" : $"Dragonfly timer","spider" : $"Spider timer"}
@onready var ground_bugs = {"mantis" : $mantis, "roach" : $roach, "beetle" : $"beetle", "carverant" : $"carverant"}
@onready var air_bugs = {"dragonfly" : $"dragonfly","spider" : $"spider"}
var ground = null
var groundphase = 1
var airphase = 1
var air = null
var groundqueue = []
var airqueue = []
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func set_enemy_level(night):
	if night == 1:
		agressions = {"mantis" : 4, "roach" : 3, "beetle" : 0, "carverant" : 0, "dragonfly" : 0, "spider" : 0}
	if night == 2:
		agressions = {"mantis" : 6, "roach" : 0, "beetle" : 3,"carverant" : 0, "dragonfly" : 0, "spider" : 0}
		print("it worked!!!!!!!!!!1!!!1!111one")
	if night == 3:
		agressions = {"mantis" : 0, "roach" : 4, "beetle" : 4,"carverant" : 0, "dragonfly" : 7, "spider" : 0}
	if night == 4:
		agressions = {"mantis" : 10, "roach" : 0, "beetle" : 0,"carverant" : 10, "dragonfly" : 5, "spider" : 0}
	if night == 5:
		agressions = {"mantis" : 8, "roach" : 0, "beetle" : 0,"carverant" : 13, "dragonfly" : 12, "spider" : 8}
		
func death() -> void:
	for i in timers:
		timers[i].stop()
func _process(delta: float) -> void:
	if air == "spider" and $"..".speaker == true and $"Spider leave".is_stopped() == true:
		$"Spider leave".start()
		print(".")
	else:
		if air != "spider" or $"..".speaker != true:
			$"Spider leave".stop()
	if dead == true:
		death()
		return
	for i in agressions:
		if agressions[i] == 0:
			continue
		if timers[i].is_stopped():
			if $"..".speaker == true or i == "spider":
				timers[i].start(randi_range(minmov[i], 20 + minmov[i] - agressions[i])/2)
			else:
				timers[i].start(randi_range(minmov[i], 20 + minmov[i] - agressions[i]))
		if ground == null:
			ground = groundqueue.pop_front()
		if air == null:
			air = airqueue.pop_front()
		for item in ground_bugs:
			ground_bugs[item].visible = ground == item and main.light_state == true
		for item in air_bugs:
			air_bugs[item].visible = air == item and main.light_state == true
		if air == "dragonfly" and $"../buzz".is_playing() == false:
			$"../buzz".play()
func queue(bug, type) -> void:
	
	if not bug in groundqueue and type == "ground":
		groundqueue.push_back(bug)
	if not bug in airqueue and type == "air":
		airqueue.push_back(bug)
func _on_roach_timer_timeout() -> void:
	if ground == "roach":
			attack("roach")
			if main.light_state == true:
				$roach.visible = true
			if groundphase == 1:
				$roach.position = Vector3(4.313, -0.788, 7.81)
			if groundphase == 2:
				$roach.position = Vector3(2.722, -0.6, 6.107)
	else:
		if ground == null:
			ground = "roach"
			if main.light_state == true:
				$roach.visible = true
		else:
			queue("roach", "ground")
			$roach.visible = false
	


func _on_mantis_timer_timeout() -> void:
	if ground == "mantis":
		attack("mantis")
	elif ground == null:
		ground = "mantis"
		if main.light_state == true:
			$mantis.visible = true
	else:
		queue("mantis", "ground")
		$mantis.visible = false
	


func _on_beetle_timer_timeout() -> void:
	if ground == "beetle":
		attack("beetle")
		if groundphase == 1:
			$beetle.position = Vector3(5.676, -0.192, 6.424)
		if groundphase == 2:
			$beetle.position = Vector3(2.264, .15, 4.75)
	elif ground == null:
		ground = "beetle"
		$beetle.visible = true
	else:
		queue("beetle", "ground")
		$beetle.visible = false
func _on_carverant_timer_timeout() -> void:
	if ground == "carverant":
		if $"Carverant attack".is_stopped() == true:
			print(".")
			attack("carverant")
	elif main.door_health > 0:
		if ground == null:
			ground = "carverant"
			if main.light_state == true:
				$carverant.visible = true
		else:
			queue("carverant", "ground")
			$carverant.visible = false
	
func _on_dragonfly_timer_timeout() -> void:
	if air == "dragonfly":
		attack("dragonfly")
	elif air == null:
		air = "dragonfly"
		if main.light_state == false:
			$dragonfly.visible = false
		else:
			$dragonfly.visible = true
	else:
		queue("dragonfly", "air")
		$dragonfly.visible = false
func attack(bug) -> void:
	print(bug)
	if groundphase < phasecount[bug]:
		groundphase += 1
		return
	else:
		if bug == "mantis":
			if main.door_state == true:
				ground = null
				groundphase = 1
				$"../thump".play()
				$mantis.visible = false
			else:
				gameover_text()
		if bug == "beetle":
			if main.door_state == true:
				pass
				ground = null
				groundphase = 1
				print("60")
				main.door_hit(60)
				$"../thump".play()
				$beetle.visible = false
			else:
				if main.light_state == false:
					groundphase = 1
					ground = null
					$"../screen/Label".visible = false
					$"../screen/Button".visible = false
				else:
					$"../screen".visible = true
					dead = true
		if bug == "roach":
			if main.door_state == true:
				main.door_hit(30)
				$"../thump".play()
				
			else:
				if main.light_state == false:
					groundphase = 1
					ground = null
					$"../screen/Label".visible = false
					$"../screen/Button".visible = false
				else:
					gameover_text()
		if bug == "carverant":
			if main.light_state == true:
				$carverant.visible = true
			if main.door_state == true:
				$"Carverant attack".start()
			else:
				ground = null
				$carverant.visible = false
		if bug == "dragonfly":
			if main.light_state == false:
				air = null
				$dragonfly.visible = false
				$"../buzz".stop()
			else:
				if main.window <= 0:
					gameover_text()
				elif main.door_state == true:
					main.window_hit()
					$"../glass".play()
					air = null
					$dragonfly.visible = false
					$"../buzz".stop()
				else:
					gameover_text()
		if bug == "spider":
			if $"..".speaker == true:
				pass
			else:
				airphase += 1
			if airphase == 4:
				if $"..".window == 0:
					gameover_text()
				else:
					$"..".window_hit()
					airphase = 1
					$spider.visible = false
					air = null
					$"../glass".play()
func restart() -> void:
	dead = false
	ground = null
	air = null
	groundqueue = []
	airqueue = []
	$"../screen/Label".visible = false
	$"../screen/Button".visible = false
func gameover_text() -> void:
	$"../screen/Button".visible = true
	$"../screen/Label".visible = true
	dead = true


		


func _on_carverant_attack_timeout() -> void:
	if main.door_state == false:
		ground = null
		$carverant.visible = false
	if  ground == "carverant":
		$"Carverant attack".start()
		main.door_hit(1)
		$"../thump".play()
		print("1")
		


func _on_spider_timer_timeout() -> void:
	if air == "spider":
		attack("spider")
		if airphase == 1:
			$spider.position = Vector3(2.525, 4.5, 4.517)
		if airphase == 2:
			$spider.position = Vector3(2.525, 4.3, 4.517)
		if airphase == 3:
			$spider.position = Vector3(2.525, 3.5, 4.517)
	elif air == null:
		air = "spider"
		airphase = 1
		$spider.position = Vector3(2.525, 4.5, 4.517)
		$spider.visible = true
	else:
		queue("spider", "air")
		$spider.visible = false
			
		


func _on_spider_leave_timeout() -> void:
	airphase = 1
	print("timeout")
	$spider.visible = false
	air = null
	
