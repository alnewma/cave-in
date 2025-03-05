extends Sprite2D

@onready var follower = $"../Path2D/PathFollow2D"

func _process(delta: float) -> void:
	follower.progress += delta*25
	li.energy = lerp(li.energy,intended_energy,delta*10)

func _ready() -> void:
	follower.progress_ratio = randf_range(0,1)

var intended_energy = 1.0
@onready var tm = $light_timer
@onready var li = $PointLight2D
func _on_light_timer_timeout() -> void:
	tm.start(randfn(.1,1))
	intended_energy = randf_range(.9,1.1)

@onready var ftmr = $flame/flame_timer
@onready var fl = $flame
func _on_flame_timer_timeout() -> void:
	ftmr.start(1.0/8)
	fl.frame = randi()%6
