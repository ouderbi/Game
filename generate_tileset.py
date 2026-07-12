#!/usr/bin/env python3
"""Generate simple tileset image for the game"""

try:
    from PIL import Image, ImageDraw
    
    # Create a simple 16x16 tileset with 4 tiles (2x2)
    tile_size = 16
    tileset_width = tile_size * 2
    tileset_height = tile_size * 2
    
    img = Image.new('RGB', (tileset_width, tileset_height), color='white')
    draw = ImageDraw.Draw(img)
    
    # Tile 0,0 - Grass (light green)
    draw.rectangle([0, 0, tile_size-1, tile_size-1], fill=(34, 139, 34))
    
    # Tile 1,0 - Forest (dark green)
    draw.rectangle([tile_size, 0, tileset_width-1, tile_size-1], fill=(0, 100, 0))
    
    # Tile 0,1 - Water (light blue)
    draw.rectangle([0, tile_size, tile_size-1, tileset_height-1], fill=(30, 144, 255))
    
    # Tile 1,1 - Stone (grey)
    draw.rectangle([tile_size, tile_size, tileset_width-1, tileset_height-1], fill=(128, 128, 128))
    
    img.save('assets/tiles/tileset_simple.png')
    print("✓ Tileset created: assets/tiles/tileset_simple.png")
    
except ImportError:
    print("PIL not installed. Creating dummy file instead.")
    # Create a minimal PNG file manually (1x1 pixel, green)
    import struct
    png_data = (
        b'\x89PNG\r\n\x1a\n'  # PNG signature
        b'\x00\x00\x00\rIHDR\x00\x00\x00\x20\x00\x00\x00\x20'
        b'\x08\x02\x00\x00\x00\xbf\xb4\x9b\xb8\x00\x00\x00\x19'
        b'tEXtSoftware\x00Adobe ImageReadyq\xc9e<\x00\x00\x00*'
        b'IDATx\xdab\xf8\x0f\x00\x00\x01\x01\x00\x00\x18\xdd'
        b'\x8d\xe4\x01\x00\x00\x00\x00IEND\xaeB`\x82'
    )
    import os
    os.makedirs('assets/tiles', exist_ok=True)
    with open('assets/tiles/tileset_simple.png', 'wb') as f:
        f.write(png_data)
    print("✓ Minimal tileset created")
