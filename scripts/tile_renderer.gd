extends CanvasLayer
class_name TileRenderer

# Render tiles procedurally instead of using TileSet
# Much simpler for procedural generation

const TILE_SIZE = 32
const MAP_WIDTH = 256
const MAP_HEIGHT = 256

var tile_colors: Dictionary = {
	"grass": Color(34, 139, 34),
	"forest": Color(0, 100, 0),
	"water": Color(30, 144, 255),
	"stone": Color(128, 128, 128),
	"sand": Color(194, 178, 128),
	"snow": Color(255, 250, 250),
	"city": Color(169, 169, 169),
	"urban": Color(105, 105, 105),
	"contaminated": Color(139, 69, 19)
}

var current_era: String = "stone_age"
var tiles: Array[Array] = []

func _ready():
	generate_map()

func generate_map():
	"""Generate procedural tilemap"""
	tiles.clear()
	
	for y in range(MAP_HEIGHT):
		var row: Array[int] = []
		for x in range(MAP_WIDTH):
			# Simple procedural: islands of different terrain
			var noise_val = sin(x * 0.05) * cos(y * 0.05)
			var tile_type = 0 if noise_val > 0 else 1
			row.append(tile_type)
		tiles.append(row)

func set_era(era_id: String):
	"""Change tileset colors based on era"""
	current_era = era_id
	queue_redraw()

func _draw():
	"""Draw all tiles"""
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			if y >= tiles.size() or x >= tiles[y].size():
				continue
			
			var tile_id = tiles[y][x]
			var color = get_tile_color(tile_id)
			var rect = Rect2(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
			
			draw_rect(rect, color)
			
			# Draw border
			draw_rect(rect, Color.BLACK, false, 0.5)

func get_tile_color(tile_id: int) -> Color:
	"""Get color for tile based on era and tile type"""
	match current_era:
		"stone_age", "bronze_age", "iron_age":
			return tile_colors["grass"] if tile_id == 0 else tile_colors["forest"]
		"medieval", "renaissance", "enlightenment":
			return tile_colors["grass"] if tile_id == 0 else tile_colors["stone"]
		"industrial", "modern":
			return tile_colors["city"] if tile_id == 0 else tile_colors["urban"]
		"atomic", "information":
			return tile_colors["urban"] if tile_id == 0 else tile_colors["contaminated"]
		"space":
			return tile_colors["snow"] if tile_id == 0 else tile_colors["stone"]
		_:
			return tile_colors["grass"]
