extends Area2D

var health := 3

@export var marker1: Marker2D
@export var marker2: Marker2D
@export var speed = 25
@onready var target = marker2
var forward := true
@onready var player = get_tree().get_first_node_in_group('Player')
@export var notice_radius := 80

func _ready():
	position = marker1.position

func _process(delta):
	check_death()
	get_target()
	position += (target.position - position).normalized() * speed * delta
	flip_logic()

func flip_logic():
	$AnimatedSprite2D.flip_h = not forward
	if position.distance_to(player.position) < notice_radius:
		$AnimatedSprite2D.flip_h = position.x > player.position.x

func get_target():
	if forward and position.distance_to(marker2.position) < 10 or\
	   not forward and position.distance_to(marker1.position) < 10:
		forward = not forward
	
	if position.distance_to(player.position) < notice_radius:
		target = player
	elif forward:
		target = marker2
	else:
		target = marker1

func _on_area_entered(area):
	health -= 1
	area.queue_free()
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	
func check_death():
	if health <= 0:
		queue_free()

func _on_body_entered(body):
	if 'get_damage' in body:
		body.get_damage(10)
