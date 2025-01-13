extends Control

@onready var volume_slider = %HSlider

func _ready() -> void:
	change_volume(linear_to_db(volume_slider.value))

func _on_button_pressed() -> void:
	pass # Replace with function body.
	$".".get_parent().visible = false
	GameStates.current_state = GameStates.state.PLAYING

func change_volume(value):
	var index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(index, value)


func _on_h_slider_value_changed(value: float) -> void:
	change_volume(linear_to_db(value))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		$".".get_parent().visible = !$".".get_parent().visible
		if $".".get_parent().visible:
			GameStates.current_state = GameStates.state.PAUSED
		else:
			GameStates.current_state = GameStates.state.PLAYING
