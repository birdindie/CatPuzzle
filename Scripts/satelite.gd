extends Spatial

func _ready():
	pass
	
func _process(delta):
	$Satelite.rotate(Vector3(0,0,1), PI * 0.05 * delta)
	#$CataventoMotor.rotate(Vector3(0,0,1), PI * 1 * delta)
	pass
