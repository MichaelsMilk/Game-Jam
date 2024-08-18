extends StaticBody2D


@onready var sprite = $AnimatedSprite2D
@onready var buttonArea = $Area2D
@onready var player = %Player

signal press
signal unpress
var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body == player:
		sprite.play("pushed")
		press.emit()
		pressed = true
		

func _on_area_2d_body_exited(body):
	if body == player:
		sprite.play("rest")
		unpress.emit()
		#pressed = false
