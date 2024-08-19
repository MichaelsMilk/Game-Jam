extends StaticBody2D

@onready var button = get_node(get_meta("button"))
@onready var toggle = get_meta("toggle")
@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var initPos = position 
@onready var targetPos = position + Vector2(0, -48)

var active = false

func _ready():
	if toggle:
		position.y = position.y - 48


func _physics_process(delta):
	if button.pressed:
		position.y = move_toward(position.y, targetPos.y, 16 * delta)
		z_index = -200
	

