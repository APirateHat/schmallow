extends Area2D

@onready var attachment_point = $SchmallowAttatchmentPoint
@export var schmallow : PackedScene
var schmallow_on_stick = false
var cookedness = 0

@export var food_particles : CPUParticles2D

var schmallow_spiked_sounds = [load("res://audio/sfx/schmallow_spiked.ogg"), load("res://audio/sfx/schmallow_spiked_2.ogg")]
var munch_sound = [load("res://audio/sfx/munch_0.ogg"), load("res://audio/sfx/munch_1.ogg"), load("res://audio/sfx/munch_2.ogg")]

func _ready() -> void:
	SignalBus.amount_cooked.connect(cooked_schmallow)
	SignalBus.cooked_status.connect(burned_marshmallow)


func _process(delta: float) -> void:
	pass
	position = get_global_mouse_position()
	eat_schmallow()

func show_schmallow():
	food_particles.color_initial_ramp.colors[0] = Color.WHITE
	schmallow_on_stick = true
	var s = schmallow.instantiate()
	s.is_on_stick = true
	s.seed = randi_range(0, 1000)
	attachment_point.call_deferred("add_child", s)
	s.play_animation("bounce")
	AudioManager.play_audio_2d(schmallow_spiked_sounds.pick_random(), attachment_point.position)

func eat_schmallow():
	if Input.is_action_just_pressed("use"):
		if attachment_point.get_child_count() != 0:
			SignalBus.marshmallow_eaten.emit()
			SignalBus.achievement_get.emit("eat_marshmallow")
			$FoodParticles.emitting = true
			AudioManager.play_audio(munch_sound.pick_random(), -6.0)
			schmallow_on_stick = false
			for i in attachment_point.get_children():
				i.queue_free()
			cookedness = 0

func cooked_schmallow(value, state):
	#print(value)
	if state == 0:
		cookedness = value
		food_particles.color_initial_ramp.colors[0] = Color(0.898, 0.42, 0)
		food_particles.color_initial_ramp.set_offset(0,value-0.1)
		
		if value >= 1:
			SignalBus.achievement_get.emit("cooked_marshmallow")
	if state == 1:
		food_particles.color_initial_ramp.colors[0] = Color(0.113, 0.029, 0)
		food_particles.color_initial_ramp.set_offset(0,value-0.1)

func burned_marshmallow():
	schmallow_on_stick = false
	food_particles.color_initial_ramp.colors[0] = Color.BLACK
	food_particles.emitting = true
	for i in attachment_point.get_children():
		i.queue_free()
	cookedness = 0
	SignalBus.marshmallow_eaten.emit()
	AudioManager.play_audio_2d(load("res://audio/sfx/fire_woof.ogg"), attachment_point.position, -12.0, false, 1.5)
	SignalBus.achievement_get.emit("burnt_marshmallow")
