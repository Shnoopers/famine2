class_name Enemy

enum BugType {GROUND, AIR}

var agressions : int
var minmov : float
var phase_count : int
var timer : Timer
var type : BugType

func _init(enemy_agressions, enemy_minmov, enemy_phase_count, enemy_timer, enemy_type) -> void:
    agressions = enemy_agressions
    minmov = enemy_minmov
    phase_count = enemy_phase_count
    timer = enemy_timer
    type = enemy_type