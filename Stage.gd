extends Node2D

export (PackedScene) var stencil

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var new_stencil_color
var new_stencil_shape

var answers = Array()
var guesses = Array()

var menuShown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var stencils = $Stack.get_children()
	for stencil in stencils:
		if stencil.visible:
			var hex_code = stencil.get_hex_code()
			print('stencil hex = 0x%x'%hex_code)
			answers.push_back(hex_code)
			var txRect = TextureRect.new()
			txRect.texture = stencil.get_texture()
			txRect.rect_size.x = 50
			txRect.rect_size.y = 50
			txRect.expand = true
			txRect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			$UI/Footer/Stencils.add_child(txRect)
#	for stencil in stencils: add_stencil_btn(stencil)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		menuShown = !menuShown
		if menuShown: $Menu/MainMenu.show()
		else: $Menu/MainMenu.hide()
		

func _on_OptionButton_item_selected(index):
	match index:
		0: new_stencil_shape = "square"
		1: new_stencil_shape = "diamond"
		2: new_stencil_shape = "circle"

func add_stencil_btn(stencil):
	var btn : TextureButton = stencil.get_button().duplicate()
	$UI/Footer/Stencils.add_child(btn)
	btn.show()


func _on_CheckGuessBtn_pressed():
	var last_good = false
	for n in len(answers):
		if (n > 0 and last_good) or (n == 0):
			var ans = answers[n]
			var gus = guesses[n]
			print('guess = 0x%x' % gus)
			print('answer = 0x%x'% ans)
			last_good = ans == gus
		if last_good and n == (len(answers)-1):
			print('you win!')
			$UI/WinAlert.popup()
				

func _on_UI_add_guess(guessCode):
	print('adding guess 0x%x' % guessCode)
	guesses.push_back(guessCode)
