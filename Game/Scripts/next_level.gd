extends Area2D


@onready var sprite = $Sprite2D
@onready var scene = get_meta("ScenePath")
var hue = 0


func _on_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file(scene)

func _process(delta):
	hue = fmod(hue + delta, 1)
	sprite.modulate = Color.from_hsv(hue, 1, 1)
	sprite.rotate(delta * 10)
