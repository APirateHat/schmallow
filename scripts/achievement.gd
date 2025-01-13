extends Control

var data : Resource

@export var panel : PanelContainer

@export var achievement_text : Label
@export var achievement_image : TextureRect
	

func assign_data(achievement_data):
	achievement_text.text = achievement_data.text
	achievement_image.texture = achievement_data.image
	achievement_image.modulate = achievement_data.image_color

func show_achievement():
	assign_data(data)
	panel.pivot_offset = panel.size/2
	panel.scale = Vector2(0,0)
	var tween = get_tree().create_tween()
	tween.tween_property(panel, "scale", Vector2(1.2,1.2), 0.2).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(panel, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(remove_achievement)
	tween.tween_callback(tween.kill)

func remove_achievement():
	await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(panel, "scale", Vector2(1.2,1.2), 0.2).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(panel, "scale", Vector2(0,0), 0.2).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(queue_free)
