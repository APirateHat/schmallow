extends Area2D

enum cooked_level {RAW, COOKED, BURNED}
var current_cooked : cooked_level

@onready var shader_graphics = $Graphics/Icon
var entered_flames = false
var marshmallow_cooked = 0
var marshmallow_burned = 0
@export var is_on_stick = false
var stick : Area2D
var seed : int

var cooking_sound = [load("res://audio/sfx/cooking.ogg"), load("res://audio/sfx/cooking_2.ogg")]

func _ready() -> void:
	shader_graphics.material.resource_local_to_scene = true
	shader_graphics.material.get_shader_parameter("dissolve_texture").noise.seed = seed
	current_cooked = cooked_level.RAW

func  _process(delta: float) -> void:
	
	if entered_flames:
		match current_cooked:
			cooked_level.RAW:
				if marshmallow_cooked < 1:
					marshmallow_cooked += pow(0.6, 2) * delta
					shader_graphics.material.set_shader_parameter("dissolve_value", marshmallow_cooked)
					SignalBus.amount_cooked.emit(marshmallow_cooked, current_cooked)
					$AudioStreamPlayer2D.pitch_scale = 1.5 - marshmallow_cooked / 2
				if marshmallow_cooked >= 1:
					await get_tree().create_timer(2.0).timeout
					current_cooked = cooked_level.COOKED
					$AudioStreamPlayer2D.volume_db = -3.0
			cooked_level.COOKED:
				if marshmallow_burned < 1:
					SignalBus.amount_cooked.emit(marshmallow_cooked, current_cooked)
					marshmallow_burned += pow(1.5, 2) * delta
					$Graphics/IconBurnt.material.set_shader_parameter("dissolve_value", marshmallow_burned)
					$AudioStreamPlayer2D.pitch_scale = 0.5 + marshmallow_burned / 2
				if marshmallow_burned >= 1:
					pass
					fade_sfx()
					SignalBus.cooked_status.emit()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Flames"):
		print("In Flames")
		entered_flames = true
		$AudioStreamPlayer2D.volume_db = -3.0
		$AudioStreamPlayer2D.stream = cooking_sound.pick_random()
		$AudioStreamPlayer2D.play() 
		#print("seed ",shader_graphics.material.get_shader_parameter("dissolve_texture").noise.seed)
	if area.is_in_group("Stick"):
		if !is_on_stick:
			SignalBus.marshmallow_on_stick.emit()
			area.show_schmallow()
			queue_free()
		#is_on_stick = true
		#stick = area

func on_stick():
	pass

func _on_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
	entered_flames = false
	fade_sfx()

func play_animation(anim:String):
	$AnimationPlayer.play(anim)

func fade_sfx():
	var tween = get_tree().create_tween()
	tween.tween_property($AudioStreamPlayer2D, "volume_db", -80, 0.3).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback($AudioStreamPlayer2D.stop)
	tween.tween_callback(tween.kill)
