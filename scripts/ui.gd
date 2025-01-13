extends Control

@export var achievement : PackedScene
var hunger = 5
@export var food_icons : Array[TextureRect]

var achievements = {
	"eat_marshmallow": {
		"data": load("res://scripts/resources/achievement_eaten_marshmallow.tres"),
		"unlocked": false
	},
	"poke_fire": {
		"data": load("res://scripts/resources/achievement_poked_fire.tres"),
		"unlocked": false
	},
	"cooked_marshmallow": {
		"data": load("res://scripts/resources/achievement_cooked_marshmallow.tres"),
		"unlocked": false
	},
	"burnt_marshmallow": {
		"data": load("res://scripts/resources/achievement_burnt_marshmallow.tres"),
		"unlocked": false
	}
}

func _ready() -> void:
	SignalBus.marshmallow_on_stick.connect(show_key)
	SignalBus.marshmallow_eaten.connect(hide_key)
	SignalBus.achievement_get.connect(add_achievement)
	
	change_hunger_bar()

func show_key():
	$CenterContainer.visible = true

func hide_key():
	$CenterContainer.visible = false
	
func add_achievement(achievement_string):
	#if achievements[achievement_string]["unlocked"] == false:
	var a = achievement.instantiate()
	a.data = achievements[achievement_string]["data"]
	achievements[achievement_string]["unlocked"] = true
	$Achievements/AchievementList.add_child(a)
	a.show_achievement()
	#for achiev in $Achievements/AchievementList.get_child_count():
		#AudioManager.play_audio(load("res://audio/sfx/notification_sound.ogg"), 0.0, false, 1.0 + float(achiev)/10.0)
	#else:
		#print_debug("Achievement already unlocked!")

func change_hunger_bar():
	for i in 5:
		if i >= hunger:
			food_icons[i].visible = false
		else:
			food_icons[i].visible = true
		
		

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_down"):
		hunger -= 1
		change_hunger_bar()
		print(hunger)
