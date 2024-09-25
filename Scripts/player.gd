extends CharacterBody2D

@onready var resource_detector_collider: CollisionShape2D = $ResourceDetector/ResourceDetectorCollider
@onready var sprite_2d: Sprite2D = $ResourceDetector/ResourceDetectorCollider/Sprite2D

@export var speed = 300.0
@export var sprint_speed_multiplier = .2 



func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var directionx := Input.get_axis("left", "right")
	if Input.is_action_pressed("sprint") == true:
		if directionx:
			velocity.x = directionx * speed * (1 + sprint_speed_multiplier)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		var directiony := Input.get_axis("up", "down")
		if directiony:
			velocity.y = directiony * speed *(1 + sprint_speed_multiplier)
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
			
	elif Input.is_action_pressed("sprint") == false:
		if directionx:
			velocity.x = directionx * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		var directiony := Input.get_axis("up", "down")
		if directiony:
			velocity.y = directiony * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
	
	if Input.is_action_pressed("left"):
		resource_detector_collider.position = Vector2 (-8,0)
		resource_detector_collider.scale = Vector2 (1,4.5)
		
		#print("left")
	
	if Input.is_action_pressed("right"):
		resource_detector_collider.position = Vector2 (8,0)
		resource_detector_collider.scale = Vector2 (1,4.5)
		
		#print("right")
	
	if Input.is_action_pressed("up"):
		resource_detector_collider.position = Vector2 (0,-11)
		resource_detector_collider.scale = Vector2 (3,1)
		
		#print("up")
	
	if Input.is_action_pressed("down"):
		resource_detector_collider.position = Vector2 (0,11)
		resource_detector_collider.scale = Vector2 (3,1)
		
		#print("down")
		
	if Input.is_action_just_pressed("space"):
		get_tree().reload_current_scene()
		print("Scene Reloaded"+"\n" + "-----------------------------------------------------------------------------------------------------------------------")
	
	move_and_slide()
