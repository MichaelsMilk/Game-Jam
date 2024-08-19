extends Area2D

@onready var sprite = $Batteries
@onready var energy = get_meta("Energy")
func _ready():
	sprite.play(str(energy))

func _on_body_entered(body):
	if body.is_in_group("Player") and body.energy < energy:
		body.energy = energy
		queue_free()
		
