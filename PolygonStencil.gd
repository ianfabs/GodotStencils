extends Node2D


export (Color) var color = Color(1,0,0,1)
export (String, "square", "diamond", "circle") var type = "square"
export (int, "small", "big") var size = 0
export (float) var side_length = 100

func vec2(x, y): return Vector2(x, y)

var rotation_angle = 50
var angle_from = 0
var angle_to = 360

# Called when the node enters the scene tree for the first time.
func _ready():
	$Res.color = $A.color
	set_hole_type(type)
	compute_diff()

func set_hole_type(stencil):
#	side_length = $A.polygon[1].x
	match stencil:
		"square":
			var l = side_length/2
			var fq = side_length/4
			var lq = fq*3
			$B.polygon = PoolVector2Array([
				vec2(fq,fq),vec2(lq,fq),vec2(lq,lq),vec2(fq,lq)
			])
		"diamond":
			var f = vec2(14.35534/100, 85.35534/100)
			var fq = side_length/4
			var lq = fq*3
			var l = side_length/2
			var sq = PoolVector2Array([vec2(fq,fq),vec2(lq,fq),vec2(lq,lq),vec2(fq,lq)])
			var dm = PoolVector2Array([vec2(l,(side_length*f.x)), vec2((side_length*f.y),l), vec2(l,(side_length*f.y)), vec2((side_length*f.x),l)])
			$B.polygon = dm
		"circle":
			var nb_points = 64
			var points_arc = PoolVector2Array()
			var center = vec2(side_length/2,side_length/2)
			var radius = center.x/2
			for i in range(nb_points + 1):
				var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
				points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
			$B.polygon = points_arc

func compute_diff():
	var res = Geometry.clip_polygons_2d($A.polygon, $B.polygon)
	print(res)
	print(is_hole(res[0]))
	print(is_hole(res[1]))
	$Res.polygon = res[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func is_hole(shape: PoolVector2Array):
	return Geometry.is_polygon_clockwise(shape)
