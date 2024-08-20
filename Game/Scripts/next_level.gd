extends Area2D

@onready var player = %Player
@onready var sprite = $Sprite2D
@onready var scene = get_meta("ScenePath")
@onready var timer = $Timer

var hue = 0


func _on_body_entered(body):
	if body.is_in_group("Player"):
		player.position = position
		player.exit()
		timer.start()

func _process(delta):
	hue = fmod(hue + delta, 1)
	sprite.modulate = Color.from_hsv(hue, 1, 1)
	sprite.rotate(delta * 10)


func _on_timer_timeout():
	get_tree().change_scene_to_file(scene)
