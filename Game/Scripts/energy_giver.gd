extends Area2D

@onready var sprite = $Batteries
@onready var energy = get_meta("Energy")
@onready var initPos = position

var elapsedTime = 0

func _ready():
	sprite.play(str(energy))

func _on_body_entered(body):
	if body.is_in_group("Player") and body.energy < energy:
		body.energy = energy
		queue_free()
		
func _process(delta):
	elapsedTime += delta
	sprite.position = Vector2(0, sin(elapsedTime * 2) * 3)
