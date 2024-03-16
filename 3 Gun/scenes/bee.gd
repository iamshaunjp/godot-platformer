extends Area2D


func _on_area_entered(area):
	print('bee was hit')
	area.queue_free()
	
