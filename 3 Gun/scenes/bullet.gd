extends Area2D

var direction := 1
@export var speed := 300

func _ready():
	$Sprite2D.flip_h = direction < 0

func _process(delta):
	position.x += speed * direction * delta
