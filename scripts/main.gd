extends Node

@export var schmallow : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	spawn_marshmallow()
	SignalBus.marshmallow_eaten.connect(spawn_marshmallow)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func  _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		spawn_marshmallow()

func spawn_marshmallow():
	await get_tree().create_timer(0.5).timeout
	$MarshmallowSpawnPoint/AnimationPlayer2.play("spawn")
	var s = schmallow.instantiate()
	$MarshmallowSpawnPoint.add_child(s)
	AudioManager.play_audio_2d(load("res://audio/sfx/marshmallow_spawn.ogg"), $MarshmallowSpawnPoint.position)
	#s.position = $MarshmallowSpawnPoint.position

func marshmallow_spawn_particles():
	$MarshmallowSpawnPoint/CPUParticles2D2.emitting = true
