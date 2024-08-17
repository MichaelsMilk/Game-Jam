extends TileMap

@onready var player = %Player

var size: float
func _ready():
	size = scale.x 
	
func _physics_process(delta):
	pass
	#scale = Vector2.ONE / player.size * size
