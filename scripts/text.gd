extends Node2D

@onready var texture = $texture as Sprite2D
@onready var area_sign = $area_sign as Area2D

const lines: Array[String] = [
	"Olá Aventureiro!",
	"É muito bom vê-lo por aqui",
	"Espero que esteja preparado...",
	"Sua jornada está apenas começando...",
	"BOA SORTE!"
]

func _unhandled_input(event):
	if area_sign.get_overlapping_bodies().size() > 0:
		texture.show()
		if event.is_action_pressed("interact") && !DialogManager.is_message_active:
			texture.hide()
			DialogManager.start_message(global_position, lines)
		else:
			texture.hide()
			if DialogManager.dialog_box != null:
				DialogManager.dialog_box.queue_free()
				DialogManager.is_message_active = false
