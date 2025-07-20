extends TextureRect

var active: bool = false

var velocity: Vector2
var rotation_dir: int
var rotation_speed: float
var gravity: float = 400

var angular_velocity: float
var angular_acceleration: float

var bigger_total_height: int

var disappear_rate: float = 0.75

func _process(delta: float):
	if active:
		position += velocity * delta
		velocity += Vector2(0.0, gravity * delta)
		rotation += angular_velocity * rotation_dir * delta
		angular_velocity += angular_acceleration * delta
		
		self_modulate.a -= disappear_rate * delta

func start_falling():
	active = true
	var dir = coin_flip()
	var vel = randf_range(50.0, 100.0)
	velocity = Vector2(vel * dir, randf_range(-100, -50))
	rotation_dir = dir
	angular_velocity = vel * 0.01 * ((bigger_total_height - self.size.y) / bigger_total_height)
	angular_acceleration = 5.0 * ((bigger_total_height - self.size.y) / bigger_total_height)
	print((bigger_total_height - self.size.y) / bigger_total_height)

func coin_flip() -> int:
	var flip = randi_range(0, 1)
	return -1 if flip == 0 else 1
