extends Area2D

var health := 2
var direction_x := 1
@export var speed := 50

func _on_area_entered(area):
	health -= 1
	area.queue_free()
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)
	
func _process(delta):
	check_death()
	position.x += speed * direction_x * delta
	
func check_death():
	if health <= 0:
		queue_free()

func _on_body_entered(body):
	if 'get_damage' in body:
		body.get_damage(20)


func _on_border_area_body_entered(_body):
	direction_x *= -1
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

func _on_right_cliff_area_body_exited(_body):
	direction_x *= -1
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

func _on_left_cliff_area_body_exited(_body):
	direction_x *= -1
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
