#!/usr/bin/env python3
"""Gera terreno isométrico (27) e top-down (9) = 36 arquivos."""
from gerar_common import *

def gen_iso_tile(biome_key, level="flat"):
    b = BIOMAS[biome_key]
    if level == "flat":
        w, h = 128, 64
        body = f'''  <polygon points="{iso_polygon(64,32,128,64)}" fill="{b['base']}" stroke="{b['dark']}" stroke-width="1"/>
  <polygon points="{iso_polygon(64,32,128,64)}" fill="url(#g)"/>
  <polygon points="64,4 124,32 64,60 4,32" fill="none" stroke="{b['light']}" stroke-width="0.5" opacity="0.4"/>'''
        if biome_key == "ocean":
            body += f'''
  <path d="M 30,32 Q 40,28 50,32 T 70,32 T 90,32" fill="none" stroke="{b['light']}" stroke-width="1.5" opacity="0.6"/>
  <path d="M 40,40 Q 50,36 60,40 T 80,40" fill="none" stroke="{b['light']}" stroke-width="1" opacity="0.4"/>'''
        elif biome_key == "forest":
            for cx, cy in [(40,28),(88,28),(64,40),(32,44),(96,44)]:
                body += f'\n  <circle cx="{cx}" cy="{cy}" r="5" fill="{b["dark"]}" opacity="0.7"/>\n  <circle cx="{cx}" cy="{cy-2}" r="4" fill="{b["detail"]}" opacity="0.6"/>'
        elif biome_key == "mountain":
            body += f'\n  <polygon points="64,10 80,32 48,32" fill="{b["dark"]}" opacity="0.8"/>\n  <polygon points="64,10 72,22 56,22" fill="{b["light"]}" opacity="0.5"/>'
        elif biome_key == "desert":
            body += '\n  <path d="M 20,34 Q 40,30 60,34 T 100,34" fill="none" stroke="'+b['dark']+'" stroke-width="0.8" opacity="0.4"/>'
        elif biome_key == "tundra":
            body += '\n  <line x1="30" y1="28" x2="40" y2="36" stroke="'+b['dark']+'" stroke-width="0.5" opacity="0.3"/>\n  <line x1="80" y1="28" x2="90" y2="36" stroke="'+b['dark']+'" stroke-width="0.5" opacity="0.3"/>'
    elif level == "low":
        w, h = 128, 96
        wall_h = 32
        body = f'''  <polygon points="{iso_polygon(64,32,128,64)}" fill="{b['base']}" stroke="{b['dark']}" stroke-width="1"/>
  <polygon points="4,32 4,{32+wall_h} 64,{64+wall_h} 64,64" fill="{b['dark']}" opacity="0.9"/>
  <polygon points="124,32 124,{32+wall_h} 64,{64+wall_h} 64,64" fill="{b['detail']}" opacity="0.8"/>
  <polygon points="{iso_polygon(64,32,128,64)}" fill="url(#g)"/>'''
    else:
        w, h = 128, 128
        wall_h = 64
        body = f'''  <polygon points="{iso_polygon(64,32,128,64)}" fill="{b['base']}" stroke="{b['dark']}" stroke-width="1"/>
  <polygon points="4,32 4,{32+wall_h} 64,{64+wall_h} 64,64" fill="{b['dark']}" opacity="0.9"/>
  <polygon points="124,32 124,{32+wall_h} 64,{64+wall_h} 64,64" fill="{b['detail']}" opacity="0.8"/>
  <polygon points="{iso_polygon(64,32,128,64)}" fill="url(#g)"/>
  <polygon points="64,{64+wall_h} 124,{32+wall_h} 64,{96+wall_h-8} 4,{32+wall_h}" fill="{b['base']}" opacity="0.5"/>'''
    return svg_wrap(w, h, body)

def gen_topdown_tile(biome_key):
    b = BIOMAS[biome_key]
    w = h = 64
    body = f'''  <rect x="0" y="0" width="{w}" height="{h}" fill="{b['base']}"/>
  <rect x="0" y="0" width="{w}" height="{h}" fill="url(#g)"/>
  <rect x="0" y="0" width="{w}" height="{h}" fill="none" stroke="{b['dark']}" stroke-width="1" opacity="0.5"/>'''
    if biome_key == "ocean":
        body += '\n  <path d="M 8,20 Q 20,16 32,20 T 56,20" fill="none" stroke="'+b['light']+'" stroke-width="1.5" opacity="0.5"/>\n  <path d="M 8,40 Q 20,36 32,40 T 56,40" fill="none" stroke="'+b['light']+'" stroke-width="1" opacity="0.4"/>'
    elif biome_key == "forest":
        for cx, cy in [(16,16),(48,16),(16,48),(48,48),(32,32)]:
            body += f'\n  <circle cx="{cx}" cy="{cy}" r="6" fill="{b["dark"]}" opacity="0.7"/>\n  <circle cx="{cx}" cy="{cy-2}" r="5" fill="{b["detail"]}" opacity="0.5"/>'
    elif biome_key == "mountain":
        body += f'\n  <polygon points="32,8 52,48 12,48" fill="{b["dark"]}" opacity="0.8"/>\n  <polygon points="32,8 40,24 24,24" fill="{b["light"]}" opacity="0.6"/>'
    elif biome_key == "desert":
        body += '\n  <path d="M 8,24 Q 24,20 40,24 T 56,24" fill="none" stroke="'+b['dark']+'" stroke-width="0.8" opacity="0.4"/>\n  <path d="M 8,44 Q 24,40 40,44 T 56,44" fill="none" stroke="'+b['dark']+'" stroke-width="0.8" opacity="0.3"/>'
    elif biome_key == "tundra":
        body += '\n  <line x1="12" y1="16" x2="20" y2="28" stroke="'+b['dark']+'" stroke-width="0.5" opacity="0.3"/>\n  <line x1="44" y1="16" x2="52" y2="28" stroke="'+b['dark']+'" stroke-width="0.5" opacity="0.3"/>\n  <line x1="28" y1="40" x2="36" y2="52" stroke="'+b['dark']+'" stroke-width="0.5" opacity="0.3"/>'
    elif biome_key == "swamp":
        body += '\n  <ellipse cx="20" cy="24" rx="6" ry="3" fill="'+b['dark']+'" opacity="0.5"/>\n  <ellipse cx="44" cy="40" rx="8" ry="4" fill="'+b['dark']+'" opacity="0.5"/>'
    elif biome_key == "savanna":
        body += '\n  <line x1="16" y1="20" x2="18" y2="28" stroke="'+b['dark']+'" stroke-width="1" opacity="0.4"/>\n  <line x1="48" y1="36" x2="50" y2="44" stroke="'+b['dark']+'" stroke-width="1" opacity="0.4"/>'
    elif biome_key == "coast":
        body += '\n  <path d="M 0,48 Q 16,44 32,48 T 64,48 L 64,64 L 0,64 Z" fill="'+b['detail']+'" opacity="0.4"/>\n  <path d="M 0,48 Q 16,44 32,48 T 64,48" fill="none" stroke="'+b['dark']+'" stroke-width="0.8" opacity="0.5"/>'
    return svg_wrap(w, h, body)

def generate_all():
    count = 0
    for biome_key in BIOMAS:
        for level in ["flat", "low", "high"]:
            save_svg(f"{OUTPUT}/terrain/iso/{biome_key}_{level}.svg", gen_iso_tile(biome_key, level))
            count += 1
    for biome_key in BIOMAS:
        save_svg(f"{OUTPUT}/terrain/topdown/{biome_key}.svg", gen_topdown_tile(biome_key))
        count += 1
    return count
