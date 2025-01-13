extends Node2D

@export var fire_collision : PackedScene
var poke_cooldown = false

func _ready() -> void:
	pulsate_glow()	

func pulsate_glow():
	var tween = get_tree().create_tween()
	tween.tween_property($ShadowFireplace2, "modulate", Color(1, 0.82, 0.18, 0.275), randf_range(0.1, 0.5))
	tween.tween_property($ShadowFireplace2, "modulate", Color(1, 0.82, 0.18, 0.098), randf_range(0.1, 0.5))
	tween.tween_property($ShadowFireplace2, "modulate", Color(1, 0.82, 0.18, 0.275), randf_range(0.1, 0.5))
	tween.tween_callback(pulsate_glow)
	tween.tween_callback(tween.kill)


func _on_logs_collider_area_entered(area: Area2D) -> void:
	if area.is_in_group("Stick"):
		if area.schmallow_on_stick == false && poke_cooldown == false:
			poke_cooldown = true
			$Logs/AnimationPlayer.play("log_shake")
			SignalBus.achievement_get.emit("poke_fire")
			AudioManager.play_audio_2d(load("res://audio/sfx/fire_woof.ogg"), self.position, -12.0)
			AudioManager.play_audio_2d(load("res://audio/sfx/wood_2.ogg"), self.position, -6.0)
			var tween = get_tree().create_tween()
			$Fire.initial_velocity_max = 500
			tween.tween_method(poke_fire, 0, 120, 0.2).set_trans(Tween.TRANS_CUBIC)
			tween.tween_method(poke_fire, 120, 0, 0.2).set_trans(Tween.TRANS_CUBIC)
			tween.tween_callback(fire_stuff)
			tween.tween_callback(tween.kill)
			await get_tree().create_timer(0.5).timeout
			poke_cooldown = false

func poke_fire(value:float):
	$Fire.spread = value

func fire_stuff():
	$Fire.initial_velocity_max = 250
