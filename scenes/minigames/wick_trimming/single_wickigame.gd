extends Control

@export var arrow_move_speed: float = 150.0 # px/s
@export var forgiveness: int = 3 # px of tolerance outside the boundary of the goal pos
@export var target_edge_margin: int = 20

@export_range(0.0, 1.0) var shake_intensity: float = 0.0

@onready var main_bar: ColorRect = $MainBar
@onready var arrow: TextureRect = $Arrow
@onready var goal_pos: ColorRect = $GoalPos 
# might wanna change these ^ to be of type Control to make it more flexible but who actually cares

@onready var top_extent: float = main_bar.get_rect().position.y
@onready var bottom_extent: float = main_bar.get_rect().end.y

@onready var active: bool = false

var would_be_arrow_position: float = top_extent

var arrow_move_dir: int = 1

var shakiness: float = 0.0

signal completed
signal did_it_badly

func _ready():
	# pick a random spot for the target position
	var loc = randf_range(top_extent + target_edge_margin, bottom_extent - target_edge_margin)
	goal_pos.position.y = loc
	
	
	
	# adjust pos of things
	# now that we know the goal pos position we can put The Part That Falls Off in the proper place
	# (and also the bottom part)
	$ThePartThatFallsOff.size.y = loc
	$ThePartThatFallsOff.pivot_offset = $ThePartThatFallsOff.size / 2
	$BottomPart.position.y = loc
	$BottomPart.size.y = bottom_extent - loc
	$ThePartThatFallsOff.bigger_total_height = $ThePartThatFallsOff.size.y + $BottomPart.size.y
	
	$SliceTexture.position.y = loc - ($SliceTexture.size.y/2)
	
	goal_pos.color = Color.DIM_GRAY
	$GoalPos/GoalPos2.color = Color.DIM_GRAY
	$GoalPos/GoalPos3.color = Color.DIM_GRAY

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("accept"):
		check_completed()

func enable():
	active = true

func disable():
	active = false

func _process(delta: float):
	if active:
		delta = delta * get_parent().mg_time_scale
		#var t = Time.get_ticks_msec() / 1000.0
		#would_be_arrow_position = lerp(top_extent, bottom_extent, remap(sin(arrow_move_speed*t), -1.0, 1.0, 0.0, 1.0))
		#set_arrow_point_position(would_be_arrow_position)
		
		# see you *could* do it like that with a nice little periodic function and a single line of code
		# or you could do it My Way ;)
		
		# (this way is only to make using Shakiness and Variable Move Speed possible)
		would_be_arrow_position += arrow_move_dir * arrow_move_speed * delta * (1 + shakiness * shake_intensity)
		if would_be_arrow_position < top_extent:
			arrow_move_dir *= -1
			would_be_arrow_position = top_extent
		elif would_be_arrow_position > bottom_extent:
			arrow_move_dir *= -1
			would_be_arrow_position = bottom_extent
		
		set_arrow_point_position(would_be_arrow_position)
		
		if is_within_goal_pos(arrow_pos_to_point_pos(arrow.global_position)):
			goal_pos.color = Color.WHITE
			$GoalPos/GoalPos2.color = Color.WHITE
			$GoalPos/GoalPos3.color = Color.WHITE
		else:
			goal_pos.color = Color.DIM_GRAY
			$GoalPos/GoalPos2.color = Color.DIM_GRAY
			$GoalPos/GoalPos3.color = Color.DIM_GRAY
		
		adjust_shakiness()
		
	else:
		# do nothing!
		pass


func is_within_goal_pos(arrow_pos: Vector2) -> bool:
	var goal_rect = goal_pos.get_global_rect()
	var forgiveness_rect = Rect2(goal_rect.position - Vector2(0.0, forgiveness), 
								 goal_rect.size + Vector2(0.0, forgiveness*2))
	# only care about y coordinate
	var test_pos = Vector2(goal_pos.global_position.x, arrow_pos.y)
	return forgiveness_rect.has_point(test_pos)

func _draw():
	return
	#var goal_rect = goal_pos.get_rect()
	#var forgiveness_rect = Rect2(goal_rect.position - Vector2(0.0, forgiveness), goal_rect.size + Vector2(0.0, forgiveness*2))
	#draw_rect(goal_rect, Color.GREEN, false)
	#draw_rect(forgiveness_rect, Color.BLUE, false)

func check_completed():
	if active and is_within_goal_pos(arrow_pos_to_point_pos(arrow.global_position)):
		print("completed! meow!")
		stop_arrow()
		completed.emit()
		# prob wanna play a sound here too
		$ThePartThatFallsOff.start_falling()
		$SliceTexture.visible = true
		var tw = get_tree().create_tween()
		tw.tween_property($SliceTexture, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	elif active:
		# idk like play a sound or somethin
		did_it_badly.emit()

func stop_arrow():
	active = false

func set_arrow_point_position(new_y: float):
	var sz = arrow.get_rect().size
	arrow.position.y = new_y - (sz.y/2.0)

func arrow_pos_to_point_pos(arrow_pos: Vector2) -> Vector2:
	var sz = arrow.get_rect().size
	return arrow_pos + Vector2(0.0, sz.y / 2.0)

func adjust_shakiness() -> void:
	var t = Time.get_ticks_msec() / 1000.0
	shakiness = remap(sin(30*t), -1.0, 1.0, -0.5, 1.5)
