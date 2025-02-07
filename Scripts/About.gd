extends Spatial

var water_height := 1.5

func _ready():
	var ratio = get_viewport().size.x / get_viewport().size.y
	var shader = $CanvasLayer/fade.material
	shader.set_shader_param("aspec_rato", ratio)	
	$Water.visible = true
	$CanvasLayer/fade.visible = true
	$CanvasLayer/fade/Anim.play("to_zero")	
	
func _process(_delta):
	$Water.translation.y = lerp($Water.translation.y, water_height, 0.15)
	$Cam/Camera.rotation_degrees.z = lerp($Cam/Camera.rotation_degrees.z, 0.0, 0.15)

func _on_Timer_timeout():
	randomize()
	water_height = rand_range(2.0, 2.5)
	$Timer.wait_time = rand_range(0.1, 0.6)

#BTN INFO
func _on_btn_about_pressed():
	var _err = get_tree().change_scene("res://Scenes/Menu.tscn")
	pass # Replace with function body.
