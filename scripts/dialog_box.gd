extends MarginContainer

# Node Label
@onready var message = $label_margin/message as Label
# Node Timer
@onready var letter_timer_display = $letter_timer_display as Timer

# largura máxima definida da caixa de diálogo
const MAX_WIDTH = 256

# estado inicial do texto que será passado
var text = ""
# Índice da string passada (array de caractere)
var letter_index = 0

# Tempo em que as letras aparecem na caixa de diálogo
var letter_display_timer := 0.07
# Tempo em que os espaços aparecem na caixa de diálogo
var space_display_timer := 0.05
# Tempo em que a pontuação aparece na caixa de diálogo
var punctuaction_display_timer := 0.2

# Sinal para indicar o fim das letras aparecerem na tela
signal text_display_finished()

# Função responsável por fazer o texto aparecer na caixa de diálogo
func display_text(text_to_display: String):
	# Atribuição do texto passado por parâmetro (que representa o campo message do node Label) a variável text (inicialmente vazia)
	text = text_to_display
	# Atribuição do texto passado por parâmetro a caixa de texto do Node Label
	message.text = text_to_display
	
	# O await observa a mudança de tamanho da caixa de texto para que possamos deixá-la responsiva de acordo com a chegada do texto
	await resized
	
	# Responsividade da textura da caixa de texto
	# O calculo vê o tamanho mínimo da caixa de diálogo e faz uma média entre o tamanho máximo e o tamanho do texto passado
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	# Caso este tamanho calculado acima seja maior que MAX-WIDTH:
	if size.x > MAX_WIDTH:
		# O texto se quebra para uma próxima linha
		message.autowrap_mode = TextServer.AUTOWRAP_WORD
		# A caixa é verificada 2x para que o tamanho não ultrapasse o limite colocado por nós (MAX-WIDTH)
		await resized
		await resized
		# Ele atribui ao tamanho mínimo da caixa o tamanho em y atual dela
		custom_minimum_size.y = size.y
	
	# global_position representa onde a caixa de texto abriu atualmente, ou seja, onde o dialog_box foi instanciado na cena
	# Em x posicionamos ao centro, pegando o tamanho atual da caixa e dividindo por 2
	global_position.x -= size.x / 2
	# Em y posicionamento a caixa acima do objeto de colisão responsável por abrir a caixa de diálogo
	global_position.y -= size.y + 24
	# Reatribuimos string vazia a caixa de texto do Node Label
	message.text = ""
	display_letter()
	
# Função responsável por mostrar as letras na tela
func display_letter():
	# Atribui a caixa de texto do Node Label a string text no índice atual dela
	message.text += text[letter_index]
	# Toda vez que for colocado uma letra, é adicionado 1 ao index
	letter_index += 1
	
	# Quando o índice for maior ou igual ao tamanho do texto emita o sinal de que o texto foi exibido completamente e finalizou
	if letter_index >= text.length():
		# Sinal emitido informando o fim da disposição das letras da string na tela
		text_display_finished.emit()
		return
	
	# Vê qual é o caractere colocado na caixa
	match text[letter_index]:
		# Caso seja pontuação, atribui-se punctuaction_display_timer que representa o tempo na variavel
		"!", "?", ",", ".":
			letter_timer_display.start(punctuaction_display_timer)
		# Caso seja espaço, atribui-se space_display_timer que representa o tempo na variação
		" ":
			letter_timer_display.start(space_display_timer)
		# Caso seja espaço, atribui-se letter_display_timer que representa o tempo na variação
		_:
			letter_timer_display.start(letter_display_timer)


func _on_letter_timer_display_timeout():
	display_letter()
