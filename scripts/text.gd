extends Node2D

# Trouxemos a textura que queremos mostrar quando o diálogo aparecer
@onready var texture = $speech_emote as Sprite2D
# Trouxemos também a área de interação com o player
@onready var area_sign = $area_sign as Area2D

# Aqui são as mensagens que irão ser passadas para as funções onde o diálogo funcionará
const lines: Array[String] = [
	"Olá Aventureiro!",
	"É muito bom vê-lo por aqui",
	"Espero que esteja preparado...",
	"Sua jornada está apenas começando...",
	"BOA SORTE!"
]

# Função de evento responsável para começar a interação com o player
func _unhandled_input(event):
	# Aqui há uma condicional responsável para ver se o player colidiu com a área de interação da placa
	if area_sign.get_overlapping_bodies().size() > 0:
		# Assim que ele interagir, o emote aparecerá acima da placa
		texture.show()
		# Quando o emote aparecer, basta o player apertar a tecla I para iniciar a interação com a placa
		# Na condicional veridicamos se a tecla foi pressionada e se não há diálogos acontecendo ao mesmo tempo
		if event.is_action_pressed("interact") && !DialogManager.is_message_active:
			print("Interagido")
			# Caso a condicional seja verdadeira, escondemos o emote
			texture.hide()
			# E começamos a mensagem
			DialogManager.start_message(global_position, lines)
		# Caso a condicional não seja verdadeira
		else:
			# Escondemos o texto
			texture.hide()
			# E verificamos se dialog_box é diferente de null
			if DialogManager.dialog_box != null:
				# Limpamos a mensagem
				DialogManager.dialog_box.queue_free()
				# E setamos is_message_active como false
				DialogManager.is_message_active = false
