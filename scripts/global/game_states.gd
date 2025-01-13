extends Node

enum state {PLAYING, PAUSED}
#var current_state = state.PLAYING
var current_state : state :
	get:
		return current_state
	set(game_state):
		current_state = game_state
		match current_state:
			state.PLAYING:
				print("STATE: PLAYING")
				AudioServer.set_bus_effect_enabled(1, 0, false)
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				get_tree().paused = false
			state.PAUSED:
				print("STATE: PAUSED")
				AudioServer.set_bus_effect_enabled(1, 0, true)
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().paused = true


#func set_state(game_state:state):
	#current_state = game_state
