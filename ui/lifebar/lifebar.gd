extends Control

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

func _on_sword_fighter_hp_changed(new_value):
	if $Tween.get_runtime() > 0:
		$Tween.remove_all()
		$Container/ProgressBar.value = $Container/ProgressBar2.value
		
	$Container/ProgressBar2.value = new_value
	$Timer.start()

func _on_Timer_timeout():
	$Tween.interpolate_property(
		$Container/ProgressBar, "value",
		$Container/ProgressBar.value, $Container/ProgressBar2.value, 1,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
