extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).

var screen_size # Size of the game window.
var player_direction = Vector2.RIGHT
var nearest_box : Area2D = null

func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		player_direction = velocity # プレイヤーの向きを更新
	else:
		$AnimatedSprite2D.stop()
		
	# プレイヤーが向いている方向に$Marker2Dを向ける
	$Marker2D.rotation = player_direction.angle()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	if Input.is_action_pressed("interact") and nearest_box:
		var item = nearest_box.open()
		if item:
			$ItemHolder.add_child(item)

func _on_target_finder_area_entered(area: Area2D) -> void:
	nearest_box = area


func _on_target_finder_area_exited(area: Area2D) -> void:
	if nearest_box == area:
		nearest_box = null
