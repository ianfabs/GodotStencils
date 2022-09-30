tool
extends Node2D

export (Color) var color = Color(1,0,0,1)
export (String, "solid", "square", "diamond", "circle") var type = "square" 
export (int, "small", "normal", "big") var size = 1 setget set_size
export (float) var side_length = 500

export (PackedScene) var button

func set_size(v):
	size = v
	property_list_changed_notify()
	if (size == 2 and type == "diamond"):
		print('big size not implemented for diamond shape')
		

func vec2(x, y=null):
	if y == null: y = x
	return Vector2(x, y)

var rotation_angle = 50
var angle_from = 0
var angle_to = 360

func _draw():
	$Viewport/Polygon2D.color = color
#	draw_circle_arc(center, radius, angle_from, angle_to, color)
#	draw_circle_arc_poly(center, radius, angle_from, angle_to, color)
#	draw_circle_arc( center, radius, angle_from, angle_to, color )
#	draw_rect(Rect2(50,50,100,100), color, true)
#	draw_square_with_cutout(cutout, color)
	draw_stencil(type)

func _ready():
	$Sprite.texture = $Viewport.get_texture()
	draw_stencil(type)
	update()
#	pass

func draw_stencil(stencil):
	if stencil == "solid": 
		$Viewport/Polygon2D.invert_enable = false
	else:
		$Viewport/Polygon2D.invert_enable = true
	
	match stencil:
		"square":
			var square = PoolVector2Array([vec2(0,0), vec2(side_length, 0), vec2(side_length,side_length), vec2(0, side_length)])
			var l = side_length
			var fq = (l/4)
			if size == 0:
				fq = (l/3)
			elif size == 1:
				fq = (l/4)
			else:
				fq = (l/5)
			var lq = (l-fq)
			var d = dist(vec2(fq,0), vec2(lq,0))
			$Viewport/Polygon2D.invert_border = (l - d) / 2
			draw_hole(PoolVector2Array([
				vec2(lq,fq),vec2(fq,fq),vec2(fq,lq),vec2(lq,lq)
			]))
		"diamond":
			var fac = vec2(14.35534/100.0, 85.35534/100.0) # other side factor for point calc
			var dnm = 2.0 # denomenator
			var l = side_length # lenght of outer square side
			var s = l/dnm # diamond side len
			var f = l*fac # multiplying total side len by factor gets right proportion x and y
			var d = dist(vec2(s,f.x), vec2(f.y,s)) # distance between first two pts in shape
			#var r = d/dnm # r for 'radius' like in the circle calc, but is really just half the dist
			# TODO: Refine this logic so it can be applied for all three sizes for any dnm
			if size == 0:
				s = (l/(dnm*2)) + (d/dnm)
				f = (f/dnm) + vec2(d/dnm)
			elif size == 1:
				# There is some really interesting behavior happening here that I'm not smart enough to explain
				# I just know it works, don't fuck with it
				# gotta figure out how to make the "normal" diamond a little bigger
				dnm = 3.0
				s = (l/dnm) + (d/dnm)
				f = (f/(dnm/2.0)) + vec2(d/dnm)
			elif size == 2:
				dnm = 2.0
				s = (l/dnm) #+ (d/dnm)
				f = (f/(dnm/2.0)) #+ vec2(d/dnm)
			
			$Viewport/Polygon2D.invert_border = f.x
			var dm = PoolVector2Array([
				vec2(s,f.x), vec2(f.y,s), vec2(s,f.y), vec2(f.x,s)
			])
			draw_hole(dm)
		"circle":
			var nb_points = 64
			var points_arc = PoolVector2Array()
			var center = vec2(side_length/2,side_length/2)
			var inc = 25
			if size == 0:
				inc = -25
			elif size == 2:
				inc = 75
			var radius = (center.x/2)+inc
			var d = radius*2
			$Viewport/Polygon2D.invert_border = (side_length-d)/2.0
			for i in range(nb_points + 1):
				var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
				points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
			draw_hole(points_arc)
		"star":
			var side_len = side_length
			var fq = side_len/4
			var lq = fq*3
			var l = side_len/2
#			var star = PoolVector2Array([
#				vec2(l,25), vec2(l+10, l-10), vec2()
#			])
#			draw_hole(square)
		"solid":
			var square = PoolVector2Array([vec2(0,0), vec2(side_length, 0), vec2(side_length,side_length), vec2(0, side_length)])
			draw_hole(square)
			

func draw_hole(holeShape: PoolVector2Array):
	$Viewport/Polygon2D.polygon = holeShape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	material.set_shader_param("color", color)
	update()
	$Sprite.texture = $Viewport.get_texture()
	
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
	var colorHex = 0x010
	if color == Color(1,0,0): #RED
		colorHex = 0x010
	elif color == Color(0,1,0): #GREEN
		colorHex = 0x020
	elif color == Color(0,0,1): #BLUE
		colorHex = 0x030
	elif color == Color(1,1,0): #YELLOW
		colorHex = 0x040
	else: print('color = ', color)
	var shapeHex = 0x100
	if type == "solid":
		shapeHex = 0x100
	elif type == "square":
		shapeHex = 0x200
	elif type == "diamond":
		shapeHex = 0x300
	elif type == "circle":
		shapeHex = 0x400
	var res = shapeHex + colorHex
	return res

func get_texture(): return $Viewport.get_texture()
func get_viewport() -> Viewport: return ($Viewport as Viewport)
func set_button(loc: Control) -> TextureButton:
	var btn = button.instance()
	btn.texture_normal = get_texture()
	loc.add_child(btn)
	return btn as TextureButton
