extends Control

var is_pitch_randomized = false

func _on_Button_toggled(button_pressed):
	if button_pressed:
		is_pitch_randomized = true
		$Button.text = "Pitch Randomized"
	else:
		is_pitch_randomized = false
		$Button.text = "Non Pitch Randomized"

func _on_Player_jumped():
	if is_pitch_randomized:
		$RandomizedAudio.play()
	else:
		$AudioStreamPlayer.play()
