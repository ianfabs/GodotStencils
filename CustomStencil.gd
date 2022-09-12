tool
extends Node2D

export (Color) var color = Color(1,0,0,1)
export (String, "square", "diamond", "circle") var type = "square"
export (int, "small", "big") var size = 0
export (float) var side_length = 100

func vec2(x, y): return Vector2(x, y)

var rotation_angle = 50
var angle_from = 0
var angle_to = 360

func _draw():
#	draw_circle_arc(center, radius, angle_from, angle_to, color)
#	draw_circle_arc_poly(center, radius, angle_from, angle_to, color)
#	draw_circle_arc( center, radius, angle_from, angle_to, color )
#	draw_rect(Rect2(50,50,100,100), color, true)
#	draw_square_with_cutout(cutout, color)
	draw_stencil(type)

func _ready():
	update()
	pass # Replace with function body.

func draw_stencil(stencil):
	match stencil:
		"square":
			var l = side_length/2
			var fq = side_length/4
			var lq = fq*3
			draw_sq_w_cutout(PoolVector2Array([
				vec2(fq,fq),vec2(lq,fq),vec2(lq,lq),vec2(fq,lq)
			]), color)
		"diamond":
			var f = vec2(14.35534/100, 85.35534/100)
			var fq = side_length/4
			var lq = fq*3
			var l = side_length/2
			var sq = PoolVector2Array([vec2(fq,fq),vec2(lq,fq),vec2(lq,lq),vec2(fq,lq)])
			var dm = PoolVector2Array([vec2(l,(side_length*f.x)), vec2((side_length*f.y),l), vec2(l,(side_length*f.y)), vec2((side_length*f.x),l)])
			draw_sq_w_cutout(dm, color)
		"circle":
			var nb_points = 64
			var points_arc = PoolVector2Array()
			var center = vec2(side_length/2,side_length/2)
			var radius = center.x/2
			for i in range(nb_points + 1):
				var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
				points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
			draw_sq_w_cutout(points_arc, color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_param("color", color)
	update()
	
func draw_square_with_cutout(cutoutShape: PoolVector2Array, color):
	var colors = PoolColorArray([color])
	var square = PoolVector2Array([vec2(0,0), vec2(100, 0), vec2(100,100), vec2(0, 100)])
	var square2 = PoolVector2Array([
		vec2(0,0), vec2(100, 0), vec2(100,100), vec2(0, 100),
		vec2(0, 75), vec2(75,75), vec2(75,25), vec2(25,25), vec2(25,75), vec2(0,75)
	])
	var sq3_len = vec2(14.35534, 85.35534)
	var d_sq3 = dist(vec2(50,sq3_len.y), vec2(sq3_len.y,50))
	var d_sq2 = dist(vec2(75,75), vec2(75,25))
	print('sq3 side len = ', d_sq3)
	print('sq2 side len = ', d_sq2)
	if d_sq3 < d_sq2: print('too short')
	elif d_sq3 > d_sq2: print('too big')
	else: print('equal')
	# diamond
	var square3 = PoolVector2Array([
		vec2(0,0), vec2(100, 0), vec2(100,100), vec2(0, 100),
		vec2(0, sq3_len.y), vec2(50,sq3_len.y), vec2(sq3_len.y,50), vec2(50,sq3_len.x), vec2(sq3_len.x,50), vec2(50,sq3_len.y), vec2(0, sq3_len.y)
	])
	# circle
	var nb_points = 12
	var radius = 10
	var center = vec2(50,50)
	var square4 = PoolVector2Array([ ])
#		vec2(0,0), vec2(100, 0), vec2(100,100), vec2(0, 100),
#	])
#	square4.push_back(center)
#	for i in range(nb_points + 1):
#		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
#		square4.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius * 2)
	for i in range(nb_points+1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		square4.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(square2, colors)
	draw_polygon(square4, [Color(0,0,0,1)])
	
func draw_sq_w_cutout(shape: PoolVector2Array, color):
	var colors = PoolColorArray([color])
	var square = PoolVector2Array([vec2(0,0), vec2(side_length, 0), vec2(side_length,side_length), vec2(0, side_length)])
	draw_polygon(square, colors)
	draw_polygon(shape, [Color(0,0,0,1)])

func dist(pt1, pt2): return sqrt(pow(pt2.x - pt1.x,2) + pow(pt2.y - pt1.y,2))

func _on_OptionButton_item_selected(index):
	match index:
		0: type = "square"
		1: type = "diamond"
		2: type = "circle"

func get_hex_code():
	var colorHex = 0x000
	if color == Color(1,0,0):
		colorHex = 0x000
	elif color == Color(0,1,0):
		colorHex = 0x010
	elif color == Color(0,0,1):
		colorHex = 0x020
		
	var shapeHex = 0x000
	if type == "square":
		shapeHex = 0x000
	elif type == "diamond":
		shapeHex = 0x100
	elif type == "circle":
		shapeHex = 0x200
	
	return shapeHex + colorHex


func _on_ColorPickerButton_color_changed(color):
	self.color = color
