extends Area2D

var health := 3

func _on_area_entered(area):
	health -= 1
	area.queue_free()
	var tween = create_tween()
	tween.tween_property($Sprite2D, "material:shader_parameter/amount", 1.0, 0.0)
	tween.tween_property($Sprite2D, "material:shader_parameter/amount", 0.0, 0.1).set_delay(0.2)

	
func _process(_delta):
	check_death()
	
func check_death():
	if health <= 0:
		queue_free()


func _on_body_entered(body):
	if 'get_damage' in body:
		body.get_damage(10)
