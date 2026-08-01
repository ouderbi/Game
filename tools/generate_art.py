#!/usr/bin/env python3
"""Procedural pixel art generator for placeholder game assets.
Generates 32x32 tiles, building sprites, unit sprites, and UI icons across eras.
Saves outputs to res://assets/art/{era}/ as PNG files (repo path: assets/art/...).
"""
import os
from PIL import Image, ImageDraw, ImageFont

OUT_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'assets', 'art')
ERAS = [
    ('stone_age', (80,160,60), (120,85,60)),
    ('bronze_age', (110,150,90), (150,110,70)),
    ('iron_age', (90,130,160), (120,100,80)),
    ('medieval', (100,100,160), (140,110,80)),
    ('industrial', (90,90,90), (60,60,60)),
    ('modern', (120,120,180), (90,90,140)),
    ('atomic', (160,120,120), (170,150,80)),
    ('information', (80,160,200), (100,140,180)),
    ('space', (30,30,60), (80,80,120)),
]

TILE_SIZE = 32
FONT = None
try:
    FONT = ImageFont.load_default()
except Exception:
    FONT = None

os.makedirs(OUT_DIR, exist_ok=True)

def save(img, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path, format='PNG')

def make_tile(color, name, era_dir):
    img = Image.new('RGBA', (TILE_SIZE, TILE_SIZE), color)
    draw = ImageDraw.Draw(img)
    # simple pattern: darker border
    draw.rectangle([0,0,TILE_SIZE-1,TILE_SIZE-1], outline=tuple(max(0,c-40) for c in color)+(255,))
    # subtle noise dots
    for x in range(4, TILE_SIZE, 6):
        for y in range(5, TILE_SIZE, 7):
            draw.point((x,y), fill=tuple(min(255,c+10) for c in color)+(255,))
    path = os.path.join(era_dir, f'tile_{name}.png')
    save(img, path)


def make_building(base_color, symbol, name, era_dir):
    img = Image.new('RGBA', (TILE_SIZE, TILE_SIZE), (0,0,0,0))
    draw = ImageDraw.Draw(img)
    # building base rectangle
    draw.rectangle([6,8,25,25], fill=base_color+(255,), outline=(0,0,0,255))
    # roof
    draw.polygon([(6,12),(16,4),(25,12)], fill=tuple(max(0,c-30) for c in base_color)+(255,), outline=(0,0,0,255))
    # symbol letter
    if FONT:
        w,h = draw.textsize(symbol, font=FONT)
        draw.text(((TILE_SIZE-w)/2, (TILE_SIZE-h)/2), symbol, fill=(0,0,0), font=FONT)
    path = os.path.join(era_dir, f'building_{name}.png')
    save(img, path)


def make_unit(color, role, name, era_dir):
    img = Image.new('RGBA', (TILE_SIZE, TILE_SIZE), (0,0,0,0))
    draw = ImageDraw.Draw(img)
    # head
    draw.ellipse([10,6,22,18], fill=color+(255,), outline=(0,0,0,255))
    # body
    draw.rectangle([12,16,20,26], fill=tuple(max(0,c-30) for c in color)+(255,), outline=(0,0,0,255))
    # weapon / tool pixel
    draw.line([20,18,28,22], fill=(80,80,80,255), width=2)
    if FONT:
        draw.text((2,2), role[0].upper(), fill=(0,0,0), font=FONT)
    path = os.path.join(era_dir, f'unit_{name}.png')
    save(img, path)


def make_icon(bg_color, glyph, name, era_dir):
    img = Image.new('RGBA', (24,24), bg_color+(255,))
    draw = ImageDraw.Draw(img)
    if FONT:
        w,h = draw.textsize(glyph, font=FONT)
        draw.text(((24-w)/2,(24-h)/2), glyph, fill=(255,255,255), font=FONT)
    path = os.path.join(era_dir, f'icon_{name}.png')
    save(img, path)


def generate_for_era(era_id, primary, secondary):
    era_dir = os.path.join(OUT_DIR, era_id)
    os.makedirs(era_dir, exist_ok=True)
    # tiles: grass, water, stone, sand
    make_tile(primary, 'ground', era_dir)
    make_tile(tuple(max(0,c-50) for c in primary), 'forest', era_dir)
    make_tile((30,90,200), 'water', era_dir)
    make_tile((180,160,120), 'sand', era_dir)
    make_tile(secondary, 'stone', era_dir)

    # buildings
    make_building(primary, 'C', 'cabin', era_dir)
    make_building(primary, 'G', 'granary', era_dir)
    make_building(secondary, 'M', 'market', era_dir)
    make_building((200,200,200), 'F', 'fortress', era_dir)

    # units
    make_unit(primary, 'peasant', 'peasant', era_dir)
    make_unit(secondary, 'soldier', 'soldier', era_dir)

    # icons
    make_icon(primary, 'F', 'food', era_dir)
    make_icon((200,160,0), 'G', 'gold', era_dir)
    make_icon((120,120,120), 'S', 'stone', era_dir)


if __name__ == '__main__':
    for era_id, pcol, scol in ERAS:
        generate_for_era(era_id, pcol, scol)
    print('Generated art into', OUT_DIR)
