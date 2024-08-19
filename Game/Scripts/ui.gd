extends CanvasLayer

@onready var batteriesSprite = $Batteries
@onready var player = %Player

func _ready():
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var energy = clamp(player.energy, 0, 5)
	batteriesSprite.play(str(energy))
