extends Node

# Chama a caixa de diálogo com os scripts que foram escritos la
@onready var dialog_box_scene = preload("res://prefabs/dialog_box.tscn")

# Variável responsável por armazenar strings dos diálogos
var message_lines: Array[String] = []
# Linha atual a qual será colocada no index como parâmetro para a função display_text
var current_line = 0
# Variável para fazer a instanciação futura da dialog box
var dialog_box
# Posição atual da caixa de diálogo
var dialog_box_position := Vector2.ZERO
# Variável para verificar se há ou não messagem ativa na tela
var is_message_active := false
# Variável responsável para ver se é possível avançar a mensagem depois de mostrada
var can_advance_message := false

# Função para iniciar a mensagem quando a caixa de mensagem for aberta, sendo necessário passar a posição e quantas linhas de texto haverão
func start_message(position: Vector2, lines: Array[String]):
	# Verificar se a mensagem está ou não ativa, caso sim, retorne nada
	if is_message_active:
		return
	# Aqui há a atribuição das linhas de diálogo a variável inicialmente vazia message_lines pelo parâmetro lines
	message_lines = lines
	# O mesmo para dialog_box_position que recebe o position vindo por parâmetro
	dialog_box_position = position
	show_text()
	# Após chamar a dialog_box_scene na tela é possível setar is_message_active como true, pois a mensagem foi chamada e está aparecendo para o player
	is_message_active = true

# Função responsável por efetivamente instanciar a dialog_box_scene, ou seja, a caixa de diálogo criada
func show_text():
	# Instanciamos a dialog_box_scene
	dialog_box = dialog_box_scene.instantiate()
	# Conectamos o sinal de _on_all_text_displayed, ou seja, todo o texto foi disposto na tela e podemos avançar
	# Obs: O text_display_finished é um sinal do script dialog_box.gd que determina que todas as letras foram dispostas na tela dentro da caixa de diálogo
	# Obs²: Conectamos o sinal dentro do script dialog_box.gd ao dialog_manager para que possamos ter a confirmação que o texto foi colocado corretamente na tela
	dialog_box.text_display_finished.connect(_on_all_text_displayed)
	# Chamamos a raiz da arvore de nós adicionando como filho a dialog_box responsável por abrir a caixa de texto
	get_tree().root.add_child(dialog_box)
	# Associando o global_position do dialog_box ao Vector2.ZERO, ou seja, a posição em tela da caixa de diálogo
	dialog_box.global_position = dialog_box_position
	# Chamamos o método display_text de dialog_box que fará a disposição na caixa de texto dos textos passados por parâmetro
	dialog_box.display_text(message_lines[current_line])
	# Enquanto o texto for passado para a caixa de diálogo, não podemos avançá-lo
	can_advance_message = false

# Função responsável por avisar para o sinal text_display_finished que sua condição é verdadeira
func _on_all_text_displayed():
	# Caso _on_all_text_displayed seja verdadeiro, podemos avançar o texto
	can_advance_message = true

# Função responsável para ver se o evento de apertar a tecla foi feito
func _unhandled_input(event):
	# Verifica se o botão de advance_message (Enter) foi pressionado e se a mensagem está ativa e se podemos avançá-la
	if Input.is_action_just_released("advance_message") && is_message_active && can_advance_message:
		# Deletamos o dialog_box da cena, ou seja, tiramos uma para colocar a próxima
		dialog_box.queue_free()
		# Adicionamos 1 a cada diálogo passado para a linha atual
		current_line += 1
		
		# Se a linha atual, ou seja, o índice da frase for maior que o tamanho do array de frases:
		if current_line >= message_lines.size():
			# A mensagem não está mais ativa
			is_message_active = false
			# E zeramos o current_line para iniciar o diálogo novamente
			current_line = 0
			return
		show_text()
