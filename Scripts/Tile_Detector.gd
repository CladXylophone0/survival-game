extends Area2D


@onready var ground_ui: Label = $"../Ground_UI"
@onready var resource_ui: Label = $"../Resource_UI"

@export_category("Tile Groups")
@export var Ground: bool = true
@export var Resources: bool = true


var resource_custom_data: String = "resources"
var terrain_custom_data: String = "ground_type"
var current_tilemaplayer : TileMapLayer
var last_ground_name: String
var last_resource_name: String
var coordinates: Vector2i
var resource_coordinates: Vector2i
var collided_resource_coords
var collided_resource_global_coords


var resource_names = ["IRON","STONE","COAL"]
var terrain_names = ["GRASS"]


#functions

func _break_resource_tile() -> void:
	#delete tile
	current_tilemaplayer.set_cell(collided_resource_coords, -1)
	
	#spawn loot
	const IRON_PICKAXE = preload("res://Scenes/iron_pickaxe.tscn")
	var iron_pick = IRON_PICKAXE.instantiate()
	collided_resource_global_coords = current_tilemaplayer.map_to_local(collided_resource_coords)
	iron_pick.position = collided_resource_global_coords
	get_tree().current_scene.call_deferred("add_child", iron_pick)
	print(collided_resource_global_coords)

func _process_rescource_collision(body: Node2D, body_rid: RID) -> void:
	current_tilemaplayer = body
	collided_resource_coords = current_tilemaplayer.get_coords_for_body_rid(body_rid)
	var resource_data_num = current_tilemaplayer.get_cell_tile_data(collided_resource_coords).get_custom_data(resource_custom_data)
	var resource_name = resource_names[resource_data_num]
	last_resource_name = resource_name
	resource_coordinates = collided_resource_coords
	#don't forget to make a function to handle resources being broken
	#cut the line below in the function to delete tiles
	
	
	#print(resource_name)
	#print(collided_resource_coords)
	#print("-----------------------------------------------")
	
func _process_ground_collision(body: Node2D, body_rid: RID):
	current_tilemaplayer = body
	var collided_tile_coords = current_tilemaplayer.get_coords_for_body_rid(body_rid)
	var tile_data_num = current_tilemaplayer.get_cell_tile_data(collided_tile_coords).get_custom_data(terrain_custom_data)
	var tile_name = terrain_names[tile_data_num]
	last_ground_name = tile_name
	coordinates = collided_tile_coords
	#print("You are standing on " + tile_name)
	#print(collided_tile_coords)
	#print("-----------------------------------------------")

#signals

func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer && body.name == "Resource_Tiles" && Resources == true:
		_process_rescource_collision(body, body_rid)
		resource_ui.text = "Resource = " + last_resource_name + "\n" + "Coords: " + str(resource_coordinates)
		_break_resource_tile()
		
	if body is TileMapLayer && body.name == "Ground_Tiles" && Ground == true:
		_process_ground_collision(body, body_rid)
		ground_ui.text = "Ground = " + last_ground_name + "\n" + "Coords: " + str(coordinates)
		
	
