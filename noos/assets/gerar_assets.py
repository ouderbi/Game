#!/usr/bin/env python3
"""
Gerador de assets SVG para o jogo Noós.
Cria 108 arquivos SVG cobrindo terreno, edifícios, unidades, UI e efeitos.
"""
import os
import math

# ── Paletas ──────────────────────────────────────────────────────────
BIOMAS = {
    "ocean":   {"base": "#1B4B7A", "dark": "#0D3560", "light": "#2A6BA0", "detail": "#3A8BC0"},
    "plains":  {"base": "#6FAE3A", "dark": "#4D8A22", "light": "#8ACE5A", "detail": "#5A9E2A"},
    "forest":  {"base": "#2D6B1F", "dark": "#1A4A12", "light": "#4D8B3A", "detail": "#3D7B2A"},
    "desert":  {"base": "#D4A85A", "dark": "#B8923E", "light": "#E4C87A", "detail": "#C4984A"},
    "mountain":{"base": "#7A7670", "dark": "#5A564F", "light": "#9A9690", "detail": "#6A6660"},
    "tundra":  {"base": "#C8D5DC", "dark": "#A8B5BC", "light": "#E8F5FC", "detail": "#B8C5CC"},
    "savanna": {"base": "#B8B44A", "dark": "#8A8620", "light": "#D8D46A", "detail": "#A8A43A"},
    "swamp":   {"base": "#4A6B3A", "dark": "#2A4A1A", "light": "#6A8B5A", "detail": "#3A5B2A"},
    "coast":   {"base": "#D4C58A", "dark": "#B89A5A", "light": "#E4D5AA", "detail": "#C4B57A"},
}

ERAS = {
    1:  {"name": "stone_age",      "base": "#8B7355", "accent": "#6B8E23", "dark": "#5A4A38", "light": "#AB9375"},
    2:  {"name": "antiquity",      "base": "#D4A76A", "accent": "#C17B3A", "dark": "#8B5A2B", "light": "#E4B78A"},
    3:  {"name": "classical",      "base": "#E8E0D0", "accent": "#D4AF37", "dark": "#8B7355", "light": "#F8F0E0"},
    4:  {"name": "medieval",       "base": "#8B8B7A", "accent": "#8B0000", "dark": "#4A4A3A", "light": "#ABAB9A"},
    5:  {"name": "industrial",     "base": "#8B4513", "accent": "#4A4A4A", "dark": "#2F2F2F", "light": "#AB6533"},
    6:  {"name": "modern",         "base": "#556B2F", "accent": "#708090", "dark": "#2F4F2F", "light": "#758B4F"},
    7:  {"name": "information",    "base": "#4682B4", "accent": "#B0C4DE", "dark": "#2F5F8F", "light": "#66A2D4"},
    8:  {"name": "high_tech",      "base": "#00CEDD", "accent": "#FF6B35", "dark": "#1A1A2E", "light": "#20DEED"},
    9:  {"name": "space",          "base": "#191970", "accent": "#D0D0D0", "dark": "#0D0D4F", "light": "#393990"},
    10: {"name": "interplanetary", "base": "#1A1A2E", "accent": "#FF6B35", "dark": "#0D0D1A", "light": "#3A3A5E"},
    11: {"name": "stellar",        "base": "#2D1B4E", "accent": "#FFD700", "dark": "#1A0D2E", "light": "#4D3B6E"},
    12: {"name": "intergalactic",  "base": "#0D0D0D", "accent": "#FF00FF", "dark": "#000000", "light": "#2D2D2D"},
}

OUTPUT = "noos/assets"

# ── Helpers ──────────────────────────────────────────────────────────
def ensure_dir(path):
    os.makedirs(path, exist_ok=True)

def save_svg(path, content):
    ensure_dir(os.path.dirname(path))
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

def svg_wrap(w, h, body, extra_defs=""):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}">
<defs>
  <linearGradient id="g" x1="0" y1="0" x2="0" y2="1">
    <stop offset="0" stop-color="#fff" stop-opacity="0.15"/>
    <stop offset="1" stop-color="#000" stop-opacity="0.15"/>
  </linearGradient>
  {extra_defs}
</defs>
{body}
</svg>'''

def iso_polygon(cx, cy, w, h):
    """Losango isométrico 2:1 centrado em (cx, cy)."""
    hw = w / 2
    hh = h / 2
    return f"{cx},{cy-hh} {cx+hw},{cy} {cx},{cy+hh} {cx-hw},{cy}"

# ── 1. Terreno Isométrico (27) ───────────────────────────────────────
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
    else:  # high
        w, h = 128, 128
        wall_h = 64
        body = f'''  <polygon points="{iso_polygon(64,32,128,64)}" fill="{b['base']}" stroke="{b['dark']}" stroke-width="1"/>
  <polygon points="4,32 4,{32+wall_h} 64,{64+wall_h} 64,64" fill="{b['dark']}" opacity="0.9"/>
  <polygon points="124,32 124,{32+wall_h} 64,{64+wall_h} 64,64" fill="{b['detail']}" opacity="0.8"/>
  <polygon points="{iso_polygon(64,32,128,64)}" fill="url(#g)"/>
  <polygon points="64,{64+wall_h} 124,{32+wall_h} 64,{96+wall_h-8} 4,{32+wall_h}" fill="{b['base']}" opacity="0.5"/>'''
    return svg_wrap(w, h, body)

# ── 2. Terreno Top-Down (9) ──────────────────────────────────────────
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

# ── 3. Edifícios (36) ────────────────────────────────────────────────
def gen_building(era_num, building_type):
    e = ERAS[era_num]
    w = h = 128
    base_y = 96
    # Sombra
    body = f'  <ellipse cx="64" cy="{base_y+8}" rx="40" ry="10" fill="#000" opacity="0.25"/>\n'
    if building_type == "defense":
        body += gen_defense(era_num, e, base_y)
    elif building_type == "civic":
        body += gen_civic(era_num, e, base_y)
    elif building_type == "economic":
        body += gen_economic(era_num, e, base_y)
    return svg_wrap(w, h, body)

def gen_defense(era_num, e, by):
    if era_num == 1:  # Paliçada
        return f'''  <rect x="32" y="{by-40}" width="8" height="40" fill="{e['dark']}"/>
  <rect x="44" y="{by-48}" width="8" height="48" fill="{e['base']}"/>
  <rect x="56" y="{by-44}" width="8" height="44" fill="{e['dark']}"/>
  <rect x="68" y="{by-50}" width="8" height="50" fill="{e['base']}"/>
  <rect x="80" y="{by-42}" width="8" height="42" fill="{e['dark']}"/>
  <polygon points="44,{by-48} 52,{by-48} 48,{by-54}" fill="{e['accent']}"/>
  <polygon points="68,{by-50} 76,{by-50} 72,{by-56}" fill="{e['accent']}"/>'''
    if era_num == 2:  # Muralha de Taipa
        return f'''  <rect x="28" y="{by-50}" width="72" height="50" fill="{e['base']}"/>
  <rect x="28" y="{by-50}" width="72" height="6" fill="{e['dark']}"/>
  <rect x="40" y="{by-30}" width="12" height="30" fill="{e['dark']}" opacity="0.6"/>
  <rect x="64" y="{by-30}" width="12" height="30" fill="{e['dark']}" opacity="0.6"/>
  <polygon points="28,{by-50} 100,{by-50} 96,{by-56} 32,{by-56}" fill="{e['accent']}" opacity="0.7"/>'''
    if era_num == 3:  # Muralha de Pedra
        return f'''  <rect x="24" y="{by-56}" width="80" height="56" fill="{e['base']}"/>
  <rect x="24" y="{by-56}" width="80" height="8" fill="{e['accent']}"/>
  <rect x="24" y="{by-12}" width="80" height="12" fill="{e['dark']}"/>
  <rect x="32" y="{by-44}" width="10" height="10" fill="{e['dark']}" opacity="0.3"/>
  <rect x="50" y="{by-44}" width="10" height="10" fill="{e['dark']}" opacity="0.3"/>
  <rect x="68" y="{by-44}" width="10" height="10" fill="{e['dark']}" opacity="0.3"/>
  <rect x="86" y="{by-44}" width="10" height="10" fill="{e['dark']}" opacity="0.3"/>
  <rect x="32" y="{by-28}" width="10" height="10" fill="{e['dark']}" opacity="0.3"/>
  <rect x="68" y="{by-28}" width="10" height="10" fill="{e['dark']}" opacity="0.3"/>
  <rect x="56" y="{by-64}" width="16" height="8" fill="{e['base']}"/>'''
    if era_num == 4:  # Castelo
        return f'''  <rect x="36" y="{by-48}" width="56" height="48" fill="{e['base']}"/>
  <rect x="28" y="{by-60}" width="16" height="60" fill="{e['dark']}"/>
  <rect x="84" y="{by-60}" width="16" height="60" fill="{e['dark']}"/>
  <rect x="52" y="{by-72}" width="24" height="72" fill="{e['accent']}"/>
  <polygon points="28,{by-60} 44,{by-60} 36,{by-68}" fill="{e['dark']}"/>
  <polygon points="84,{by-60} 100,{by-60} 92,{by-68}" fill="{e['dark']}"/>
  <rect x="58" y="{by-56}" width="12" height="20" fill="{e['dark']}" opacity="0.5"/>
  <rect x="30" y="{by-64}" width="4" height="4" fill="{e['light']}"/>
  <rect x="38" y="{by-64}" width="4" height="4" fill="{e['light']}"/>
  <rect x="86" y="{by-64}" width="4" height="4" fill="{e['light']}"/>
  <rect x="94" y="{by-64}" width="4" height="4" fill="{e['light']}"/>'''
    if era_num == 5:  # Forte Bastionado
        return f'''  <polygon points="24,{by} 40,{by-40} 88,{by-40} 104,{by} 88,{by-40} 40,{by-40}" fill="{e['dark']}"/>
  <polygon points="32,{by} 44,{by-36} 84,{by-36} 96,{by}" fill="{e['base']}"/>
  <rect x="48" y="{by-52}" width="32" height="16" fill="{e['accent']}"/>
  <rect x="56" y="{by-48}" width="16" height="8" fill="{e['dark']}"/>
  <line x1="40" y1="{by-20}" x2="88" y2="{by-20}" stroke="{e['dark']}" stroke-width="1" opacity="0.4"/>'''
    if era_num == 6:  # Bunker
        return f'''  <path d="M 28,{by} L 28,{by-32} Q 28,{by-44} 64,{by-44} Q 100,{by-44} 100,{by-32} L 100,{by} Z" fill="{e['dark']}"/>
  <path d="M 36,{by} L 36,{by-28} Q 36,{by-38} 64,{by-38} Q 92,{by-38} 92,{by-28} L 92,{by}" fill="{e['base']}"/>
  <rect x="52" y="{by-32}" width="24" height="10" fill="{e['dark']}" opacity="0.7" rx="2"/>
  <line x1="28" y1="{by-10}" x2="100" y2="{by-10}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>'''
    if era_num == 7:  # Bateria de Mísseis
        return f'''  <rect x="32" y="{by-32}" width="64" height="32" fill="{e['dark']}"/>
  <rect x="36" y="{by-36}" width="56" height="4" fill="{e['accent']}"/>
  <rect x="44" y="{by-56}" width="8" height="24" fill="{e['base']}"/>
  <rect x="60" y="{by-64}" width="8" height="32" fill="{e['base']}"/>
  <rect x="76" y="{by-52}" width="8" height="20" fill="{e['base']}"/>
  <polygon points="44,{by-56} 52,{by-56} 48,{by-64}" fill="{e['accent']}"/>
  <polygon points="60,{by-64} 68,{by-64} 64,{by-72}" fill="{e['accent']}"/>
  <polygon points="76,{by-52} 84,{by-52} 80,{by-60}" fill="{e['accent']}"/>'''
    if era_num == 8:  # Escudo de Energia
        return f'''  <ellipse cx="64" cy="{by-20}" rx="44" ry="56" fill="{e['base']}" opacity="0.15" stroke="{e['base']}" stroke-width="2"/>
  <ellipse cx="64" cy="{by-20}" rx="36" ry="48" fill="{e['accent']}" opacity="0.1" stroke="{e['accent']}" stroke-width="1"/>
  <ellipse cx="64" cy="{by-20}" rx="28" ry="40" fill="{e['base']}" opacity="0.08"/>
  <rect x="56" y="{by-12}" width="16" height="12" fill="{e['dark']}"/>
  <circle cx="64" cy="{by-20}" r="3" fill="{e['accent']}"/>
  <line x1="64" y1="{by-44}" x2="64" y2="{by-36}" stroke="{e['accent']}" stroke-width="2"/>'''
    if era_num == 9:  # Defesa Orbital
        return f'''  <circle cx="64" cy="{by-40}" r="28" fill="none" stroke="{e['accent']}" stroke-width="2" opacity="0.6"/>
  <circle cx="64" cy="{by-40}" r="20" fill="{e['dark']}" opacity="0.8"/>
  <circle cx="64" cy="{by-40}" r="14" fill="{e['base']}" opacity="0.5"/>
  <circle cx="64" cy="{by-40}" r="6" fill="{e['accent']}"/>
  <line x1="36" y1="{by-40}" x2="20" y2="{by-40}" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="92" y1="{by-40}" x2="108" y2="{by-40}" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="64" y1="{by-12}" x2="64" y2="0" stroke="{e['accent']}" stroke-width="2" opacity="0.5"/>
  <circle cx="20" cy="{by-40}" r="4" fill="{e['base']}"/>
  <circle cx="108" cy="{by-40}" r="4" fill="{e['base']}"/>'''
    if era_num == 10:  # Grade de Defesa Planetária
        return f'''  <circle cx="64" cy="{by-36}" r="32" fill="none" stroke="{e['accent']}" stroke-width="1" opacity="0.4"/>
  <circle cx="64" cy="{by-36}" r="24" fill="{e['dark']}" opacity="0.6"/>
  <circle cx="64" cy="{by-36}" r="16" fill="{e['base']}" opacity="0.4"/>
  <polygon points="64,{by-60} 72,{by-44} 56,{by-44}" fill="{e['accent']}"/>
  <polygon points="64,{by-12} 72,{by-28} 56,{by-28}" fill="{e['accent']}"/>
  <polygon points="36,{by-36} 52,{by-32} 52,{by-40}" fill="{e['accent']}"/>
  <polygon points="92,{by-36} 76,{by-32} 76,{by-40}" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-36}" r="4" fill="{e['accent']}"/>'''
    if era_num == 11:  # Estação de Defesa
        return f'''  <rect x="48" y="{by-52}" width="32" height="8" fill="{e['accent']}"/>
  <rect x="56" y="{by-44}" width="16" height="40" fill="{e['dark']}"/>
  <rect x="52" y="{by-44}" width="4" height="40" fill="{e['base']}"/>
  <rect x="72" y="{by-44}" width="4" height="40" fill="{e['base']}"/>
  <circle cx="64" cy="{by-36}" r="6" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-36}" r="3" fill="{e['light']}"/>
  <rect x="40" y="{by-20}" width="8" height="16" fill="{e['base']}"/>
  <rect x="80" y="{by-20}" width="8" height="16" fill="{e['base']}"/>'''
    if era_num == 12:  # Array de Defesa Galáctica
        return f'''  <circle cx="64" cy="{by-40}" r="40" fill="none" stroke="{e['accent']}" stroke-width="1" opacity="0.3"/>
  <circle cx="64" cy="{by-40}" r="28" fill="none" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>
  <circle cx="64" cy="{by-40}" r="16" fill="{e['dark']}"/>
  <circle cx="64" cy="{by-40}" r="8" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-40}" r="3" fill="#fff"/>
  <line x1="64" y1="{by-80}" x2="64" y2="0" stroke="{e['accent']}" stroke-width="0.5" opacity="0.4"/>
  <line x1="24" y1="{by-40}" x2="104" y2="{by-40}" stroke="{e['accent']}" stroke-width="0.5" opacity="0.4"/>'''

def gen_civic(era_num, e, by):
    if era_num == 1:  # Círculo de Pedras
        stones = ""
        for angle in range(0, 360, 45):
            rad = math.radians(angle)
            x = 64 + math.cos(rad) * 28
            y = by - 16 + math.sin(rad) * 14
            stones += f'  <ellipse cx="{x:.0f}" cy="{y:.0f}" rx="6" ry="10" fill="{e["base"]}"/>\n'
            stones += f'  <ellipse cx="{x:.0f}" cy="{y-3:.0f}" rx="5" ry="8" fill="{e["light"]}" opacity="0.6"/>\n'
        return stones + f'  <circle cx="64" cy="{by-16}" r="8" fill="{e["dark"]}" opacity="0.5"/>'
    if era_num == 2:  # Zigurate
        return f'''  <polygon points="32,{by} 96,{by} 80,{by-16} 48,{by-16}" fill="{e['dark']}"/>
  <polygon points="40,{by-16} 88,{by-16} 76,{by-32} 52,{by-32}" fill="{e['base']}"/>
  <polygon points="48,{by-32} 80,{by-32} 72,{by-48} 56,{by-48}" fill="{e['light']}"/>
  <rect x="60" y="{by-48}" width="8" height="12" fill="{e['dark']}"/>
  <line x1="32" y1="{by}" x2="96" y2="{by}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>'''
    if era_num == 3:  # Academia
        return f'''  <rect x="32" y="{by-40}" width="64" height="40" fill="{e['base']}"/>
  <polygon points="24,{by-40} 104,{by-40} 96,{by-52} 32,{by-52}" fill="{e['accent']}"/>
  <polygon points="24,{by-40} 104,{by-40} 96,{by-48} 32,{by-48}" fill="{e['light']}" opacity="0.6"/>
  <rect x="40" y="{by-36}" width="6" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="82" y="{by-36}" width="6" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="56" y="{by-28}" width="16" height="28" fill="{e['dark']}" opacity="0.5"/>
  <polygon points="56,{by-28} 72,{by-28} 64,{by-36}" fill="{e['dark']}" opacity="0.6"/>'''
    if era_num == 4:  # Catedral
        return f'''  <rect x="36" y="{by-44}" width="56" height="44" fill="{e['base']}"/>
  <polygon points="36,{by-44} 92,{by-44} 64,{by-64}" fill="{e['dark']}"/>
  <rect x="56" y="{by-64}" width="16" height="20" fill="{e['accent']}"/>
  <rect x="40" y="{by-36}" width="8" height="20" fill="{e['dark']}" opacity="0.5" rx="4"/>
  <rect x="80" y="{by-36}" width="8" height="20" fill="{e['dark']}" opacity="0.5" rx="4"/>
  <rect x="58" y="{by-30}" width="12" height="30" fill="{e['dark']}" opacity="0.6" rx="6"/>
  <polygon points="44,{by-44} 52,{by-44} 48,{by-50}" fill="{e['accent']}"/>
  <polygon points="76,{by-44} 84,{by-44} 80,{by-50}" fill="{e['accent']}"/>'''
    if era_num == 5:  # Câmara Municipal
        return f'''  <rect x="32" y="{by-44}" width="64" height="44" fill="{e['base']}"/>
  <rect x="28" y="{by-48}" width="72" height="8" fill="{e['dark']}"/>
  <rect x="36" y="{by-52}" width="4" height="8" fill="{e['dark']}"/>
  <rect x="52" y="{by-52}" width="4" height="8" fill="{e['dark']}"/>
  <rect x="68" y="{by-52}" width="4" height="8" fill="{e['dark']}"/>
  <rect x="84" y="{by-52}" width="4" height="8" fill="{e['dark']}"/>
  <rect x="44" y="{by-32}" width="10" height="32" fill="{e['dark']}" opacity="0.5"/>
  <rect x="74" y="{by-32}" width="10" height="32" fill="{e['dark']}" opacity="0.5"/>
  <rect x="58" y="{by-24}" width="12" height="24" fill="{e['accent']}" opacity="0.7"/>
  <circle cx="64" cy="{by-56}" r="3" fill="{e['accent']}"/>'''
    if era_num == 6:  # Parlamento
        return f'''  <rect x="28" y="{by-48}" width="72" height="48" fill="{e['base']}"/>
  <rect x="24" y="{by-52}" width="80" height="6" fill="{e['dark']}"/>
  <rect x="32" y="{by-36}" width="8" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="44" y="{by-36}" width="8" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="76" y="{by-36}" width="8" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="88" y="{by-36}" width="8" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="56" y="{by-28}" width="16" height="28" fill="{e['accent']}" opacity="0.6" rx="8"/>
  <circle cx="64" cy="{by-60}" r="6" fill="{e['accent']}"/>
  <rect x="62" y="{by-72}" width="4" height="12" fill="{e['accent']}"/>'''
    if era_num == 7:  # Centro de Dados
        return f'''  <rect x="32" y="{by-56}" width="64" height="56" fill="{e['dark']}"/>
  <rect x="36" y="{by-52}" width="56" height="48" fill="{e['base']}"/>
  <rect x="40" y="{by-48}" width="48" height="4" fill="{e['accent']}" opacity="0.7"/>
  <rect x="40" y="{by-40}" width="48" height="4" fill="{e['accent']}" opacity="0.5"/>
  <rect x="40" y="{by-32}" width="48" height="4" fill="{e['accent']}" opacity="0.5"/>
  <rect x="40" y="{by-24}" width="48" height="4" fill="{e['accent']}" opacity="0.5"/>
  <circle cx="44" cy="{by-46}" r="1.5" fill="{e['accent']}"/>
  <circle cx="44" cy="{by-38}" r="1.5" fill="#00ff00"/>
  <circle cx="44" cy="{by-30}" r="1.5" fill="{e['accent']}"/>
  <circle cx="44" cy="{by-22}" r="1.5" fill="#00ff00"/>'''
    if era_num == 8:  # Laboratório de IA
        return f'''  <rect x="36" y="{by-52}" width="56" height="52" fill="{e['dark']}"/>
  <rect x="40" y="{by-48}" width="48" height="44" fill="{e['base']}" opacity="0.3"/>
  <circle cx="64" cy="{by-28}" r="20" fill="none" stroke="{e['accent']}" stroke-width="2" opacity="0.6"/>
  <circle cx="64" cy="{by-28}" r="12" fill="none" stroke="{e['accent']}" stroke-width="1.5" opacity="0.8"/>
  <circle cx="64" cy="{by-28}" r="4" fill="{e['accent']}"/>
  <line x1="44" y1="{by-28}" x2="52" y2="{by-28}" stroke="{e['accent']}" stroke-width="1.5"/>
  <line x1="76" y1="{by-28}" x2="84" y2="{by-28}" stroke="{e['accent']}" stroke-width="1.5"/>
  <line x1="64" y1="{by-48}" x2="64" y2="{by-44}" stroke="{e['accent']}" stroke-width="1.5"/>'''
    if era_num == 9:  # Colônia Espacial
        return f'''  <ellipse cx="64" cy="{by-8}" rx="44" ry="8" fill="{e['dark']}"/>
  <rect x="48" y="{by-48}" width="32" height="40" fill="{e['base']}"/>
  <rect x="52" y="{by-44}" width="24" height="36" fill="{e['accent']}" opacity="0.3"/>
  <ellipse cx="64" cy="{by-48}" rx="16" ry="4" fill="{e['accent']}"/>
  <circle cx="56" cy="{by-36}" r="3" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-36}" r="3" fill="{e['accent']}"/>
  <circle cx="72" cy="{by-36}" r="3" fill="{e['accent']}"/>
  <line x1="48" y1="{by-28}" x2="44" y2="{by-16}" stroke="{e['base']}" stroke-width="2"/>
  <line x1="80" y1="{by-28}" x2="84" y2="{by-16}" stroke="{e['base']}" stroke-width="2"/>'''
    if era_num == 10:  # Terraformação
        return f'''  <ellipse cx="64" cy="{by-8}" rx="40" ry="8" fill="{e['dark']}"/>
  <path d="M 28,{by-8} Q 28,{by-44} 64,{by-44} Q 100,{by-44} 100,{by-8}" fill="{e['base']}" opacity="0.6"/>
  <path d="M 36,{by-12} Q 36,{by-36} 64,{by-36} Q 92,{by-36} 92,{by-12}" fill="{e['accent']}" opacity="0.3"/>
  <circle cx="48" cy="{by-24}" r="4" fill="{e['accent']}"/>
  <circle cx="72" cy="{by-20}" r="3" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-32}" r="2" fill="{e['accent']}"/>
  <line x1="64" y1="{by-44}" x2="64" y2="{by-56}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>
  <circle cx="64" cy="{by-60}" r="3" fill="{e['accent']}"/>'''
    if era_num == 11:  # Assembleia Estelar
        return f'''  <ellipse cx="64" cy="{by-8}" rx="48" ry="8" fill="{e['dark']}"/>
  <polygon points="40,{by-8} 88,{by-8} 96,{by-40} 32,{by-40}" fill="{e['base']}"/>
  <polygon points="48,{by-40} 80,{by-40} 84,{by-56} 44,{by-56}" fill="{e['accent']}"/>
  <polygon points="56,{by-56} 72,{by-56} 64,{by-68}" fill="{e['light']}"/>
  <circle cx="64" cy="{by-48}" r="4" fill="{e['accent']}"/>
  <line x1="40" y1="{by-24}" x2="88" y2="{by-24}" stroke="{e['dark']}" stroke-width="1" opacity="0.4"/>
  <line x1="44" y1="{by-32}" x2="84" y2="{by-32}" stroke="{e['dark']}" stroke-width="0.5" opacity="0.3"/>'''
    if era_num == 12:  # Conselho Galáctico
        return f'''  <ellipse cx="64" cy="{by-8}" rx="52" ry="8" fill="{e['dark']}"/>
  <ellipse cx="64" cy="{by-32}" rx="40" ry="32" fill="none" stroke="{e['accent']}" stroke-width="1.5" opacity="0.5"/>
  <ellipse cx="64" cy="{by-32}" rx="28" ry="24" fill="{e['base']}" opacity="0.3"/>
  <ellipse cx="64" cy="{by-32}" rx="16" ry="16" fill="{e['accent']}" opacity="0.2"/>
  <circle cx="64" cy="{by-32}" r="6" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-32}" r="2" fill="#fff"/>
  <line x1="24" y1="{by-32}" x2="40" y2="{by-32}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>
  <line x1="88" y1="{by-32}" x2="104" y2="{by-32}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>'''

def gen_economic(era_num, e, by):
    if era_num == 1:  # Acampamento de Caça
        return f'''  <polygon points="40,{by} 56,{by-36} 72,{by}" fill="none" stroke="{e['dark']}" stroke-width="3"/>
  <polygon points="40,{by} 56,{by-36} 72,{by}" fill="{e['base']}" opacity="0.3"/>
  <line x1="56" y1="{by-36}" x2="56" y2="{by}" stroke="{e['dark']}" stroke-width="2"/>
  <circle cx="56" cy="{by-40}" r="4" fill="{e['accent']}"/>
  <line x1="48" y1="{by-12}" x2="64" y2="{by-12}" stroke="{e['accent']}" stroke-width="1" opacity="0.6"/>'''
    if era_num == 2:  # Celeiro
        return f'''  <rect x="36" y="{by-36}" width="56" height="36" fill="{e['base']}"/>
  <polygon points="32,{by-36} 96,{by-36} 88,{by-48} 40,{by-48}" fill="{e['dark']}"/>
  <line x1="36" y1="{by-36}" x2="92" y2="0" stroke="{e['dark']}" stroke-width="0.5" opacity="0.3"/>
  <line x1="92" y1="{by-36}" x2="36" y2="0" stroke="{e['dark']}" stroke-width="0.5" opacity="0.3"/>
  <rect x="56" y="{by-24}" width="16" height="24" fill="{e['dark']}" opacity="0.6"/>
  <line x1="36" y1="{by-36}" x2="92" y2="{by-36}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>'''
    if era_num == 3:  # Ágora
        return f'''  <rect x="28" y="{by-32}" width="72" height="32" fill="{e['base']}"/>
  <rect x="24" y="{by-36}" width="80" height="6" fill="{e['accent']}"/>
  <rect x="32" y="{by-24}" width="8" height="24" fill="{e['dark']}" opacity="0.4"/>
  <rect x="48" y="{by-24}" width="8" height="24" fill="{e['dark']}" opacity="0.4"/>
  <rect x="72" y="{by-24}" width="8" height="24" fill="{e['dark']}" opacity="0.4"/>
  <rect x="88" y="{by-24}" width="8" height="24" fill="{e['dark']}" opacity="0.4"/>
  <circle cx="64" cy="{by-16}" r="6" fill="{e['accent']}" opacity="0.5"/>
  <rect x="60" y="{by-8}" width="8" height="8" fill="{e['dark']}" opacity="0.5"/>'''
    if era_num == 4:  # Moinho de Vento
        return f'''  <rect x="56" y="{by-32}" width="16" height="32" fill="{e['base']}"/>
  <polygon points="32,{by-32} 56,{by-32} 44,{by-48}" fill="{e['dark']}"/>
  <polygon points="72,{by-32} 96,{by-32} 84,{by-48}" fill="{e['dark']}"/>
  <polygon points="56,{by-56} 72,{by-56} 64,{by-72}" fill="{e['dark']}"/>
  <polygon points="56,{by-8} 72,{by-8} 64,{by-24}" fill="{e['dark']}"/>
  <circle cx="64" cy="{by-32}" r="5" fill="{e['accent']}"/>
  <rect x="60" y="{by-20}" width="8" height="20" fill="{e['dark']}" opacity="0.5"/>'''
    if era_num == 5:  # Fábrica
        return f'''  <rect x="28" y="{by-44}" width="72" height="44" fill="{e['dark']}"/>
  <rect x="32" y="{by-40}" width="64" height="40" fill="{e['base']}"/>
  <rect x="36" y="{by-56}" width="12" height="16" fill="{e['dark']}"/>
  <rect x="56" y="{by-60}" width="12" height="20" fill="{e['dark']}"/>
  <rect x="76" y="{by-52}" width="12" height="12" fill="{e['dark']}"/>
  <circle cx="42" cy="{by-56}" r="2" fill="{e['accent']}" opacity="0.7"/>
  <circle cx="62" cy="{by-60}" r="2" fill="{e['accent']}" opacity="0.7"/>
  <rect x="40" y="{by-28}" width="10" height="10" fill="{e['accent']}" opacity="0.4"/>
  <rect x="56" y="{by-28}" width="10" height="10" fill="{e['accent']}" opacity="0.4"/>
  <rect x="72" y="{by-28}" width="10" height="10" fill="{e['accent']}" opacity="0.4"/>'''
    if era_num == 6:  # Usina
        return f'''  <rect x="32" y="{by-48}" width="64" height="48" fill="{e['dark']}"/>
  <rect x="36" y="{by-44}" width="56" height="44" fill="{e['base']}"/>
  <rect x="44" y="{by-60}" width="8" height="20" fill="{e['dark']}"/>
  <rect x="76" y="{by-60}" width="8" height="20" fill="{e['dark']}"/>
  <circle cx="48" cy="{by-60}" r="3" fill="{e['accent']}" opacity="0.6"/>
  <circle cx="80" cy="{by-60}" r="3" fill="{e['accent']}" opacity="0.6"/>
  <line x1="36" y1="{by-30}" x2="92" y2="{by-30}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>
  <line x1="36" y1="{by-20}" x2="92" y2="{by-20}" stroke="{e['accent']}" stroke-width="1" opacity="0.4"/>
  <rect x="56" y="{by-36}" width="16" height="16" fill="{e['accent']}" opacity="0.3"/>'''
    if era_num == 7:  # Fazenda Solar
        return f'''  <rect x="32" y="{by-16}" width="64" height="16" fill="{e['dark']}"/>
  <polygon points="36,{by-16} 56,{by-16} 48,{by-40}" fill="{e['accent']}" opacity="0.7"/>
  <polygon points="60,{by-16} 80,{by-16} 72,{by-44}" fill="{e['accent']}" opacity="0.7"/>
  <polygon points="84,{by-16} 96,{by-16} 90,{by-36}" fill="{e['accent']}" opacity="0.7"/>
  <line x1="48" y1="{by-40}" x2="48" y2="{by-16}" stroke="{e['dark']}" stroke-width="1"/>
  <line x1="72" y1="{by-44}" x2="72" y2="{by-16}" stroke="{e['dark']}" stroke-width="1"/>
  <line x1="90" y1="{by-36}" x2="90" y2="{by-16}" stroke="{e['dark']}" stroke-width="1"/>
  <circle cx="64" cy="{by-48}" r="4" fill="{e['accent']}"/>
  <line x1="64" y1="{by-48}" x2="64" y2="{by-44}" stroke="{e['accent']}" stroke-width="1"/>'''
    if era_num == 8:  # Usina de Fusão
        return f'''  <rect x="36" y="{by-44}" width="56" height="44" fill="{e['dark']}"/>
  <circle cx="64" cy="{by-28}" r="20" fill="none" stroke="{e['accent']}" stroke-width="2" opacity="0.7"/>
  <circle cx="64" cy="{by-28}" r="14" fill="{e['base']}" opacity="0.2"/>
  <circle cx="64" cy="{by-28}" r="8" fill="{e['accent']}" opacity="0.4"/>
  <circle cx="64" cy="{by-28}" r="3" fill="#fff" opacity="0.8"/>
  <line x1="44" y1="{by-28}" x2="52" y2="{by-28}" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="76" y1="{by-28}" x2="84" y2="{by-28}" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="64" y1="{by-44}" x2="64" y2="{by-40}" stroke="{e['accent']}" stroke-width="2"/>'''
    if era_num == 9:  # Complexo de Lançamento
        return f'''  <rect x="48" y="{by-24}" width="32" height="24" fill="{e['dark']}"/>
  <rect x="56" y="{by-72}" width="16" height="48" fill="{e['base']}"/>
  <polygon points="56,{by-72} 72,{by-72} 64,{by-84}" fill="{e['accent']}"/>
  <rect x="36" y="{by-40}" width="8" height="40" fill="{e['base']}"/>
  <rect x="84" y="{by-40}" width="8" height="40" fill="{e['base']}"/>
  <line x1="40" y1="{by-40}" x2="56" y2="{by-60}" stroke="{e['base']}" stroke-width="1"/>
  <line x1="88" y1="{by-40}" x2="72" y2="{by-60}" stroke="{e['base']}" stroke-width="1"/>
  <circle cx="64" cy="{by-12}" r="10" fill="{e['accent']}" opacity="0.3"/>'''
    if era_num == 10:  # Mineração de Asteroides
        return f'''  <polygon points="28,{by-20} 48,{by-32} 72,{by-28} 96,{by-16} 80,{by} 36,{by}" fill="{e['dark']}"/>
  <polygon points="36,{by-16} 52,{by-26} 68,{by-24} 84,{by-12} 72,{by} 44,{by}" fill="{e['base']}" opacity="0.6"/>
  <circle cx="56" cy="{by-20}" r="3" fill="{e['accent']}"/>
  <circle cx="72" cy="{by-16}" r="2" fill="{e['accent']}"/>
  <rect x="48" y="{by-40}" width="8" height="20" fill="{e['base']}"/>
  <rect x="68" y="{by-44}" width="8" height="24" fill="{e['base']}"/>
  <line x1="52" y1="{by-40}" x2="56" y2="{by-20}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>
  <line x1="72" y1="{by-44}" x2="72" y2="{by-16}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>'''
    if era_num == 11:  # Hub de Comércio Interestelar
        return f'''  <ellipse cx="64" cy="{by-8}" rx="48" ry="8" fill="{e['dark']}"/>
  <rect x="48" y="{by-40}" width="32" height="32" fill="{e['base']}"/>
  <rect x="52" y="{by-36}" width="24" height="28" fill="{e['accent']}" opacity="0.3"/>
  <polygon points="48,{by-40} 80,{by-40} 72,{by-52} 56,{by-52}" fill="{e['accent']}"/>
  <circle cx="58" cy="{by-28}" r="3" fill="{e['accent']}"/>
  <circle cx="70" cy="{by-28}" r="3" fill="{e['accent']}"/>
  <line x1="32" y1="{by-24}" x2="48" y2="{by-24}" stroke="{e['base']}" stroke-width="2"/>
  <line x1="80" y1="{by-24}" x2="96" y2="{by-24}" stroke="{e['base']}" stroke-width="2"/>
  <circle cx="32" cy="{by-24}" r="3" fill="{e['accent']}"/>
  <circle cx="96" cy="{by-24}" r="3" fill="{e['accent']}"/>'''
    if era_num == 12:  # Gerador de Buraco de Minhoca
        return f'''  <ellipse cx="64" cy="{by-8}" rx="40" ry="8" fill="{e['dark']}"/>
  <ellipse cx="64" cy="{by-36}" rx="32" ry="32" fill="none" stroke="{e['accent']}" stroke-width="2" opacity="0.5"/>
  <ellipse cx="64" cy="{by-36}" rx="24" ry="24" fill="{e['base']}" opacity="0.2"/>
  <ellipse cx="64" cy="{by-36}" rx="16" ry="16" fill="{e['accent']}" opacity="0.3"/>
  <ellipse cx="64" cy="{by-36}" rx="8" ry="8" fill="{e['accent']}" opacity="0.6"/>
  <circle cx="64" cy="{by-36}" r="3" fill="#fff"/>
  <line x1="32" y1="{by-36}" x2="24" y2="{by-36}" stroke="{e['accent']}" stroke-width="1" opacity="0.4"/>
  <line x1="96" y1="{by-36}" x2="104" y2="{by-36}" stroke="{e['accent']}" stroke-width="1" opacity="0.4"/>'''

# ── 4. Unidades (12) ─────────────────────────────────────────────────
def gen_unit(era_num):
    e = ERAS[era_num]
    w = h = 64
    by = 48
    body = f'  <ellipse cx="32" cy="{by+4}" rx="14" ry="4" fill="#000" opacity="0.3"/>\n'
    if era_num == 1:  # Guerreiro com Clava
        body += f'''  <circle cx="32" cy="{by-28}" r="8" fill="{e['base']}"/>
  <rect x="28" y="{by-20}" width="8" height="20" fill="{e['base']}"/>
  <rect x="24" y="{by-8}" width="4" height="12" fill="{e['dark']}"/>
  <rect x="36" y="{by-8}" width="4" height="12" fill="{e['dark']}"/>
  <line x1="36" y1="{by-16}" x2="52" y2="{by-28}" stroke="{e['dark']}" stroke-width="3"/>
  <circle cx="52" cy="{by-28}" r="4" fill="{e['accent']}"/>'''
    elif era_num == 2:  # Hoplita
        body += f'''  <circle cx="32" cy="{by-30}" r="7" fill="{e['base']}"/>
  <rect x="28" y="{by-22}" width="8" height="18" fill="{e['base']}"/>
  <circle cx="32" cy="{by-30}" r="9" fill="none" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="20" y1="{by-40}" x2="20" y2="{by-4}" stroke="{e['dark']}" stroke-width="2"/>
  <line x1="20" y1="{by-4}" x2="28" y2="{by-4}" stroke="{e['dark']}" stroke-width="2"/>
  <rect x="24" y="{by-10}" width="4" height="10" fill="{e['dark']}"/>
  <rect x="36" y="{by-10}" width="4" height="10" fill="{e['dark']}"/>'''
    elif era_num == 3:  # Legionário
        body += f'''  <circle cx="32" cy="{by-30}" r="7" fill="{e['base']}"/>
  <rect x="28" y="{by-22}" width="8" height="18" fill="{e['accent']}"/>
  <rect x="26" y="{by-30}" width="12" height="4" fill="{e['dark']}"/>
  <rect x="24" y="{by-10}" width="4" height="10" fill="{e['dark']}"/>
  <rect x="36" y="{by-10}" width="4" height="10" fill="{e['dark']}"/>
  <line x1="40" y1="{by-24}" x2="52" y2="{by-36}" stroke="{e['dark']}" stroke-width="2"/>
  <polygon points="52,{by-36} 56,{by-40} 52,{by-32}" fill="{e['dark']}"/>'''
    elif era_num == 4:  # Cavaleiro
        body += f'''  <ellipse cx="32" cy="{by-8}" rx="16" ry="6" fill="{e['dark']}"/>
  <rect x="20" y="{by-20}" width="24" height="12" fill="{e['base']}"/>
  <circle cx="32" cy="{by-32}" r="7" fill="{e['base']}"/>
  <rect x="26" y="{by-38}" width="12" height="8" fill="{e['accent']}"/>
  <polygon points="26,{by-38} 38,{by-38} 32,{by-46}" fill="{e['accent']}"/>
  <line x1="40" y1="{by-24}" x2="52" y2="{by-40}" stroke="{e['dark']}" stroke-width="2"/>
  <line x1="20" y1="{by-4}" x2="20" y2="{by+4}" stroke="{e['dark']}" stroke-width="2"/>
  <line x1="44" y1="{by-4}" x2="44" y2="{by+4}" stroke="{e['dark']}" stroke-width="2"/>'''
    elif era_num == 5:  # Fuzileiro
        body += f'''  <circle cx="32" cy="{by-28}" r="6" fill="{e['base']}"/>
  <rect x="28" y="{by-22}" width="8" height="18" fill="{e['dark']}"/>
  <rect x="26" y="{by-22}" width="12" height="4" fill="{e['accent']}"/>
  <rect x="24" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>
  <rect x="36" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>
  <line x1="36" y1="{by-16}" x2="52" y2="{by-20}" stroke="{e['dark']}" stroke-width="2"/>
  <rect x="48" y="{by-22}" width="6" height="4" fill="{e['dark']}"/>'''
    elif era_num == 6:  # Infantaria Motorizada
        body += f'''  <rect x="16" y="{by-24}" width="32" height="20" fill="{e['dark']}"/>
  <rect x="20" y="{by-20}" width="24" height="12" fill="{e['base']}"/>
  <rect x="24" y="{by-16}" width="16" height="8" fill="{e['accent']}" opacity="0.5"/>
  <circle cx="24" cy="{by-4}" r="4" fill="{e['dark']}"/>
  <circle cx="40" cy="{by-4}" r="4" fill="{e['dark']}"/>
  <line x1="48" y1="{by-18}" x2="56" y2="{by-24}" stroke="{e['dark']}" stroke-width="2"/>'''
    elif era_num == 7:  # Drone de Combate
        body += f'''  <ellipse cx="32" cy="{by-20}" rx="20" ry="6" fill="{e['dark']}"/>
  <circle cx="20" cy="{by-20}" r="8" fill="{e['base']}"/>
  <circle cx="44" cy="{by-20}" r="8" fill="{e['base']}"/>
  <rect x="28" y="{by-24}" width="8" height="8" fill="{e['accent']}"/>
  <circle cx="32" cy="{by-20}" r="3" fill="{e['accent']}"/>
  <line x1="20" y1="{by-12}" x2="20" y2="{by-4}" stroke="{e['accent']}" stroke-width="1" opacity="0.6"/>
  <line x1="44" y1="{by-12}" x2="44" y2="{by-4}" stroke="{e['accent']}" stroke-width="1" opacity="0.6"/>'''
    elif era_num == 8:  # Armadura de Potência
        body += f'''  <circle cx="32" cy="{by-30}" r="8" fill="{e['dark']}"/>
  <rect x="24" y="{by-22}" width="16" height="18" fill="{e['base']}"/>
  <rect x="20" y="{by-20}" width="4" height="12" fill="{e['base']}"/>
  <rect x="40" y="{by-20}" width="4" height="12" fill="{e['base']}"/>
  <rect x="26" y="{by-30}" width="12" height="4" fill="{e['accent']}"/>
  <circle cx="32" cy="{by-28}" r="2" fill="{e['accent']}"/>
  <rect x="24" y="{by-8}" width="6" height="10" fill="{e['dark']}"/>
  <rect x="34" y="{by-8}" width="6" height="10" fill="{e['dark']}"/>'''
    elif era_num == 9:  # Fuzileiro Espacial
        body += f'''  <circle cx="32" cy="{by-30}" r="8" fill="{e['dark']}"/>
  <rect x="26" y="{by-22}" width="12" height="18" fill="{e['base']}"/>
  <rect x="22" y="{by-20}" width="4" height="12" fill="{e['accent']}"/>
  <rect x="38" y="{by-20}" width="4" height="12" fill="{e['accent']}"/>
  <rect x="28" y="{by-30}" width="8" height="3" fill="{e['accent']}"/>
  <rect x="24" y="{by-8}" width="6" height="10" fill="{e['dark']}"/>
  <rect x="34" y="{by-8}" width="6" height="10" fill="{e['dark']}"/>
  <line x1="40" y1="{by-16}" x2="52" y2="{by-20}" stroke="{e['accent']}" stroke-width="2"/>'''
    elif era_num == 10:  # Mecha Planetário
        body += f'''  <rect x="24" y="{by-36}" width="16" height="12" fill="{e['dark']}"/>
  <rect x="20" y="{by-24}" width="24" height="20" fill="{e['base']}"/>
  <rect x="16" y="{by-22}" width="6" height="14" fill="{e['accent']}"/>
  <rect x="42" y="{by-22}" width="6" height="14" fill="{e['accent']}"/>
  <circle cx="32" cy="{by-30}" r="3" fill="{e['accent']}"/>
  <rect x="22" y="{by-8}" width="8" height="10" fill="{e['dark']}"/>
  <rect x="34" y="{by-8}" width="8" height="10" fill="{e['dark']}"/>
  <line x1="44" y1="{by-20}" x2="56" y2="{by-28}" stroke="{e['dark']}" stroke-width="3"/>'''
    elif era_num == 11:  # Nave Estelar
        body += f'''  <polygon points="32,{by-40} 44,{by-12} 32,{by-4} 20,{by-12}" fill="{e['base']}"/>
  <polygon points="32,{by-36} 40,{by-14} 32,{by-8} 24,{by-14}" fill="{e['accent']}" opacity="0.4"/>
  <circle cx="32" cy="{by-20}" r="4" fill="{e['accent']}"/>
  <line x1="20" y1="{by-12}" x2="12" y2="{by-4}" stroke="{e['base']}" stroke-width="2"/>
  <line x1="44" y1="{by-12}" x2="52" y2="{by-4}" stroke="{e['base']}" stroke-width="2"/>
  <polygon points="28,{by-4} 36,{by-4} 32,{by}" fill="{e['accent']}" opacity="0.6"/>'''
    elif era_num == 12:  # Encouraçado Galáctico
        body += f'''  <polygon points="16,{by-20} 48,{by-20} 56,{by-12} 48,{by-4} 16,{by-4} 8,{by-12}" fill="{e['dark']}"/>
  <polygon points="20,{by-18} 46,{by-18} 52,{by-12} 46,{by-6} 20,{by-6} 14,{by-12}" fill="{e['base']}"/>
  <rect x="28" y="{by-28}" width="8" height="10" fill="{e['accent']}"/>
  <circle cx="32" cy="{by-12}" r="4" fill="{e['accent']}"/>
  <line x1="48" y1="{by-16}" x2="60" y2="{by-16}" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="16" y1="{by-16}" x2="4" y2="{by-16}" stroke="{e['accent']}" stroke-width="2"/>'''
    return svg_wrap(w, h, body)

# ── 5. Interface (12) ───────────────────────────────────────────────
def gen_ui(element):
    if element == "panel_dark":
        w, h = 240, 160
        body = f'''  <rect x="0" y="0" width="{w}" height="{h}" rx="8" fill="#1a1a2e" stroke="#2d2d4e" stroke-width="2"/>
  <rect x="2" y="2" width="{w-4}" height="{h-4}" rx="6" fill="none" stroke="#3d3d5e" stroke-width="1" opacity="0.5"/>
  <rect x="0" y="0" width="{w}" height="24" rx="8" fill="#2d2d4e"/>
  <rect x="0" y="16" width="{w}" height="8" fill="#2d2d4e"/>'''
        return svg_wrap(w, h, body)
    if element == "panel_light":
        w, h = 240, 160
        body = f'''  <rect x="0" y="0" width="{w}" height="{h}" rx="8" fill="#e8e0d0" stroke="#c8b8a0" stroke-width="2"/>
  <rect x="2" y="2" width="{w-4}" height="{h-4}" rx="6" fill="none" stroke="#d8c8b0" stroke-width="1" opacity="0.5"/>
  <rect x="0" y="0" width="{w}" height="24" rx="8" fill="#d4c8b0"/>
  <rect x="0" y="16" width="{w}" height="8" fill="#d4c8b0"/>'''
        return svg_wrap(w, h, body)
    if element == "button_normal":
        w, h = 96, 32
        body = f'''  <rect x="0" y="0" width="{w}" height="{h}" rx="4" fill="#2d2d4e" stroke="#4d4d6e" stroke-width="1"/>
  <rect x="1" y="1" width="{w-2}" height="{h-2}" rx="3" fill="url(#g)"/>'''
        return svg_wrap(w, h, body)
    if element == "button_hover":
        w, h = 96, 32
        body = f'''  <rect x="0" y="0" width="{w}" height="{h}" rx="4" fill="#3d3d5e" stroke="#6d6d8e" stroke-width="1.5"/>
  <rect x="1" y="1" width="{w-2}" height="{h-2}" rx="3" fill="url(#g)"/>'''
        return svg_wrap(w, h, body)
    if element == "button_pressed":
        w, h = 96, 32
        body = f'''  <rect x="0" y="0" width="{w}" height="{h}" rx="4" fill="#1d1d3e" stroke="#3d3d5e" stroke-width="1"/>
  <rect x="1" y="2" width="{w-2}" height="{h-3}" rx="3" fill="url(#g)"/>'''
        return svg_wrap(w, h, body)
    if element == "icon_treasury":
        w = h = 32
        body = f'''  <circle cx="16" cy="16" r="14" fill="#D4AF37" stroke="#8B7355" stroke-width="1.5"/>
  <text x="16" y="22" font-size="16" font-weight="bold" text-anchor="middle" fill="#5A4A38">$</text>'''
        return svg_wrap(w, h, body)
    if element == "icon_stability":
        w = h = 32
        body = f'''  <polygon points="16,2 30,28 2,28" fill="#556B2F" stroke="#2F4F2F" stroke-width="1.5"/>
  <rect x="12" y="14" width="8" height="14" fill="#2F4F2F" opacity="0.4"/>
  <circle cx="16" cy="12" r="3" fill="#7B9B4F"/>'''
        return svg_wrap(w, h, body)
    if element == "icon_legitimacy":
        w = h = 32
        body = f'''  <polygon points="16,2 20,12 30,12 22,18 26,28 16,22 6,28 10,18 2,12 12,12" fill="#D4AF37" stroke="#8B7355" stroke-width="1.5"/>
  <circle cx="16" cy="16" r="3" fill="#8B0000"/>'''
        return svg_wrap(w, h, body)
    if element == "icon_population":
        w = h = 32
        body = f'''  <circle cx="11" cy="12" r="5" fill="#4682B4" stroke="#2F5F8F" stroke-width="1"/>
  <circle cx="21" cy="12" r="5" fill="#4682B4" stroke="#2F5F8F" stroke-width="1"/>
  <rect x="6" y="16" width="10" height="12" rx="2" fill="#4682B4" stroke="#2F5F8F" stroke-width="1"/>
  <rect x="16" y="16" width="10" height="12" rx="2" fill="#4682B4" stroke="#2F5F8F" stroke-width="1"/>'''
        return svg_wrap(w, h, body)
    if element == "icon_era":
        w = h = 32
        body = f'''  <circle cx="16" cy="16" r="14" fill="none" stroke="#D4AF37" stroke-width="2"/>
  <line x1="16" y1="16" x2="16" y2="6" stroke="#D4AF37" stroke-width="2"/>
  <line x1="16" y1="16" x2="24" y2="20" stroke="#D4AF37" stroke-width="2"/>
  <circle cx="16" cy="16" r="2" fill="#D4AF37"/>'''
        return svg_wrap(w, h, body)
    if element == "leader_frame":
        w = h = 96
        body = f'''  <rect x="4" y="4" width="88" height="88" rx="4" fill="#1a1a2e" stroke="#D4AF37" stroke-width="2"/>
  <rect x="8" y="8" width="80" height="80" rx="2" fill="#2d2d4e" stroke="#4d4d6e" stroke-width="1"/>
  <polygon points="4,4 20,4 4,20" fill="#D4AF37"/>
  <polygon points="92,92 76,92 92,76" fill="#D4AF37"/>
  <circle cx="48" cy="48" r="20" fill="#3d3d5e" opacity="0.5"/>
  <circle cx="48" cy="42" r="8" fill="#5d5d7e" opacity="0.6"/>
  <rect x="36" y="50" width="24" height="16" rx="8" fill="#5d5d7e" opacity="0.6"/>'''
        return svg_wrap(w, h, body)
    if element == "minimap_frame":
        w, h = 160, 120
        body = f'''  <rect x="2" y="2" width="156" height="116" rx="4" fill="#1a1a2e" stroke="#4d4d6e" stroke-width="2"/>
  <rect x="6" y="6" width="148" height="108" rx="2" fill="#0d0d1a" stroke="#3d3d5e" stroke-width="1"/>
  <rect x="8" y="8" width="144" height="104" fill="#1a2a3e" opacity="0.3"/>'''
        return svg_wrap(w, h, body)
    return ""

# ── 6. Efeitos de Evento (12) ────────────────────────────────────────
def gen_effect(effect_name):
    w = h = 128
    cx, cy = 64, 64
    if effect_name == "fire":
        body = f'''  <polygon points="{cx},{cy-40} {cx+20},{cy} {cx},{cy+20} {cx-20},{cy}" fill="#FF4500" opacity="0.8"/>
  <polygon points="{cx},{cy-30} {cx+12},{cy+4} {cx},{cy+16} {cx-12},{cy+4}" fill="#FFD700" opacity="0.7"/>
  <polygon points="{cx},{cy-20} {cx+8},{cy+4} {cx},{cy+10} {cx-8},{cy+4}" fill="#fff" opacity="0.5"/>
  <circle cx="{cx-16}" cy="{cy+20}" r="6" fill="#FF4500" opacity="0.5"/>
  <circle cx="{cx+18}" cy="{cy+18}" r="5" fill="#FF8C00" opacity="0.5"/>'''
    elif effect_name == "nuclear_explosion":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="50" fill="#FFFFFF" opacity="0.9"/>
  <circle cx="{cx}" cy="{cy}" r="40" fill="#FFD700" opacity="0.8"/>
  <circle cx="{cx}" cy="{cy}" r="30" fill="#FF8C00" opacity="0.7"/>
  <circle cx="{cx}" cy="{cy}" r="20" fill="#FF4500" opacity="0.6"/>
  <line x1="{cx}" y1="{cy-50}" x2="{cx}" y2="{cy-20}" stroke="#FFD700" stroke-width="4" opacity="0.6"/>
  <line x1="{cx-43}" y1="{cy-25}" x2="{cx-18}" y2="{cy-10}" stroke="#FFD700" stroke-width="3" opacity="0.5"/>
  <line x1="{cx+43}" y1="{cy-25}" x2="{cx+18}" y2="{cy-10}" stroke="#FFD700" stroke-width="3" opacity="0.5"/>
  <line x1="{cx-50}" y1="{cy}" x2="{cx-20}" y2="{cy}" stroke="#FFD700" stroke-width="3" opacity="0.5"/>
  <line x1="{cx+50}" y1="{cy}" x2="{cx+20}" y2="{cy}" stroke="#FFD700" stroke-width="3" opacity="0.5"/>'''
    elif effect_name == "fallout":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="40" fill="#4A7B3A" opacity="0.2"/>
  <circle cx="{cx}" cy="{cy}" r="30" fill="#6A9B5A" opacity="0.3"/>
  <circle cx="{cx}" cy="{cy}" r="20" fill="#8ABB7A" opacity="0.4"/>
  <text x="{cx}" y="{cy+8}" font-size="32" text-anchor="middle" fill="#2F4F2F" font-weight="bold">☢</text>'''
    elif effect_name == "plague":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="30" fill="#4A2B2B" opacity="0.3" stroke="#8B0000" stroke-width="2"/>
  <circle cx="{cx-12}" cy="{cy-8}" r="6" fill="#8B0000" opacity="0.6"/>
  <circle cx="{cx+10}" cy="{cy+6}" r="5" fill="#8B0000" opacity="0.6"/>
  <circle cx="{cx+4}" cy="{cy-12}" r="4" fill="#8B0000" opacity="0.5"/>
  <circle cx="{cx-8}" cy="{cy+10}" r="3" fill="#8B0000" opacity="0.5"/>
  <circle cx="{cx+14}" cy="{cy-4}" r="3" fill="#8B0000" opacity="0.4"/>'''
    elif effect_name == "riot":
        body = f'''  <polygon points="{cx},{cy-30} {cx+20},{cy-10} {cx+15},{cy+20} {cx-15},{cy+20} {cx-20},{cy-10}" fill="#8B0000" opacity="0.7"/>
  <rect x="{cx-4}" y="{cy-10}" width="8" height="20" fill="#FFD700" opacity="0.8"/>
  <polygon points="{cx-4},{cy-10} {cx+4},{cy-10} {cx},{cy-20}" fill="#FFD700"/>
  <circle cx="{cx-8}" cy="{cy+24}" r="3" fill="#FF4500" opacity="0.6"/>
  <circle cx="{cx+8}" cy="{cy+24}" r="3" fill="#FF4500" opacity="0.6"/>'''
    elif effect_name == "famine":
        body = f'''  <rect x="{cx-24}" y="{cy-20}" width="48" height="40" rx="4" fill="#8B7355" opacity="0.3" stroke="#5A4A38" stroke-width="2"/>
  <line x1="{cx-20}" y1="{cy-10}" x2="{cx+20}" y2="{cy-10}" stroke="#5A4A38" stroke-width="1" opacity="0.5"/>
  <line x1="{cx-20}" y1="{cy}" x2="{cx+20}" y2="{cy}" stroke="#5A4A38" stroke-width="1" opacity="0.5"/>
  <line x1="{cx-20}" y1="{cy+10}" x2="{cx+20}" y2="{cy+10}" stroke="#5A4A38" stroke-width="1" opacity="0.5"/>
  <text x="{cx}" y="{cy+8}" font-size="28" text-anchor="middle" fill="#5A4A38" opacity="0.7">↓</text>'''
    elif effect_name == "revolution":
        body = f'''  <polygon points="{cx},{cy-30} {cx+26},{cy+20} {cx-26},{cy+20}" fill="#8B0000" opacity="0.7"/>
  <rect x="{cx-4}" y="{cy-10}" width="8" height="24" fill="#FFD700"/>
  <polygon points="{cx-4},{cy-10} {cx+4},{cy-10} {cx},{cy-18}" fill="#FFD700"/>
  <circle cx="{cx}" cy="{cy+28}" r="4" fill="#FF4500" opacity="0.5"/>
  <line x1="{cx-20}" y1="{cy+10}" x2="{cx+20}" y2="{cy+10}" stroke="#FFD700" stroke-width="2" opacity="0.4"/>'''
    elif effect_name == "coup":
        body = f'''  <rect x="{cx-20}" y="{cy-20}" width="40" height="40" fill="#2F2F2F" opacity="0.4" stroke="#556B2F" stroke-width="2"/>
  <polygon points="{cx},{cy-30} {cx+16},{cy-10} {cx},{cy+10} {cx-16},{cy-10}" fill="#556B2F" opacity="0.7"/>
  <line x1="{cx}" y1="{cy-30}" x2="{cx}" y2="{cy+10}" stroke="#FFD700" stroke-width="2"/>
  <line x1="{cx-16}" y1="{cy-10}" x2="{cx+16}" y2="{cy-10}" stroke="#FFD700" stroke-width="2"/>'''
    elif effect_name == "earthquake":
        body = f'''  <path d="M {cx-40},{cy} L {cx-30},{cy-20} L {cx-20},{cy+10} L {cx-10},{cy-15} L {cx},{cy+5} L {cx+10},{cy-20} L {cx+20},{cy+10} L {cx+30},{cy-10} L {cx+40},{cy}" fill="none" stroke="#8B4513" stroke-width="3" opacity="0.7"/>
  <path d="M {cx-35},{cy+20} L {cx-25},{cy} L {cx-15},{cy+25} L {cx-5},{cy+5} L {cx+5},{cy+25} L {cx+15},{cy} L {cx+25},{cy+20} L {cx+35},{cy+5}" fill="none" stroke="#8B4513" stroke-width="2" opacity="0.5"/>'''
    elif effect_name == "volcano":
        body = f'''  <polygon points="{cx-30},{cy+30} {cx+30},{cy+30} {cx+20},{cy-10} {cx-20},{cy-10}" fill="#5A4A38" opacity="0.8"/>
  <polygon points="{cx-20},{cy-10} {cx+20},{cy-10} {cx+10},{cy-30} {cx-10},{cy-30}" fill="#FF4500" opacity="0.7"/>
  <polygon points="{cx-10},{cy-30} {cx+10},{cy-30} {cx},{cy-45}" fill="#FFD700" opacity="0.6"/>
  <circle cx="{cx-8}" cy="{cy-35}" r="3" fill="#FF8C00" opacity="0.5"/>
  <circle cx="{cx+10}" cy="{cy-32}" r="2" fill="#FF8C00" opacity="0.5"/>'''
    elif effect_name == "tech_advance":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="30" fill="none" stroke="#00CEDD" stroke-width="2" opacity="0.6"/>
  <circle cx="{cx}" cy="{cy}" r="20" fill="none" stroke="#00CEDD" stroke-width="1.5" opacity="0.5"/>
  <polygon points="{cx},{cy-20} {cx+14},{cy} {cx},{cy+20} {cx-14},{cy}" fill="#00CEDD" opacity="0.3"/>
  <circle cx="{cx}" cy="{cy}" r="6" fill="#00CEDD"/>
  <line x1="{cx}" y1="{cy}" x2="{cx}" y2="{cy-14}" stroke="#fff" stroke-width="2"/>
  <line x1="{cx}" y1="{cy}" x2="{cx+10}" y2="{cy+6}" stroke="#fff" stroke-width="2"/>'''
    elif effect_name == "religious_schism":
        body = f'''  <polygon points="{cx-30},{cy+20} {cx-10},{cy+20} {cx-20},{cy-20}" fill="#8B7355" opacity="0.6"/>
  <polygon points="{cx+10},{cy+20} {cx+30},{cy+20} {cx+20},{cy-20}" fill="#8B7355" opacity="0.6"/>
  <line x1="{cx}" y1="{cy-30}" x2="{cx}" y2="{cy+30}" stroke="#8B0000" stroke-width="3" opacity="0.7" stroke-dasharray="6,4"/>
  <circle cx="{cx-20}" cy="{cy}" r="4" fill="#D4AF37" opacity="0.5"/>
  <circle cx="{cx+20}" cy="{cy}" r="4" fill="#D4AF37" opacity="0.5"/>'''
    else:
        body = ""
    return svg_wrap(w, h, body)

# ── Geração ──────────────────────────────────────────────────────────
def main():
    count = 0

    # 1. Terreno Isométrico (27)
    for biome_key in BIOMAS:
        for level in ["flat", "low", "high"]:
            path = f"{OUTPUT}/terrain/iso/{biome_key}_{level}.svg"
            save_svg(path, gen_iso_tile(biome_key, level))
            count += 1

    # 2. Terreno Top-Down (9)
    for biome_key in BIOMAS:
        path = f"{OUTPUT}/terrain/topdown/{biome_key}.svg"
        save_svg(path, gen_topdown_tile(biome_key))
        count += 1

    # 3. Edifícios (36)
    building_names = {
        1:  ("palisade", "stone_circle", "hunting_camp"),
        2:  ("mud_wall", "ziggurat", "granary"),
        3:  ("stone_wall", "academy", "agora"),
        4:  ("castle", "cathedral", "windmill"),
        5:  ("bastion_fort", "town_hall", "factory"),
        6:  ("bunker", "parliament", "power_plant"),
        7:  ("sam_site", "data_center", "solar_farm"),
        8:  ("energy_shield", "ai_lab", "fusion_plant"),
        9:  ("orbital_defense", "space_colony", "rocket_launch"),
        10: ("defense_grid", "terraforming", "asteroid_mine"),
        11: ("fleet_station", "stellar_assembly", "trade_hub"),
        12: ("galactic_defense", "galactic_council", "wormhole_gen"),
    }
    for era_num in range(1, 13):
        era_name = ERAS[era_num]["name"]
        names = building_names[era_num]
        for i, btype in enumerate(["defense", "civic", "economic"]):
            path = f"{OUTPUT}/buildings/{era_name}/{names[i]}.svg"
            save_svg(path, gen_building(era_num, btype))
            count += 1

    # 4. Unidades (12)
    unit_names = {
        1: "stone_age_warrior", 2: "antiquity_hoplite", 3: "classical_legionary",
        4: "medieval_knight", 5: "industrial_rifleman", 6: "modern_infantry",
        7: "information_drone", 8: "high_tech_power_armor", 9: "space_marine",
        10: "interplanetary_mech", 11: "stellar_starship", 12: "intergalactic_dreadnought",
    }
    for era_num in range(1, 13):
        path = f"{OUTPUT}/units/{unit_names[era_num]}.svg"
        save_svg(path, gen_unit(era_num))
        count += 1

    # 5. Interface (12)
    ui_elements = [
        "panel_dark", "panel_light", "button_normal", "button_hover",
        "button_pressed", "icon_treasury", "icon_stability", "icon_legitimacy",
        "icon_population", "icon_era", "leader_frame", "minimap_frame",
    ]
    for elem in ui_elements:
        path = f"{OUTPUT}/ui/{elem}.svg"
        save_svg(path, gen_ui(elem))
        count += 1

    # 6. Efeitos (12)
    effects = [
        "fire", "nuclear_explosion", "fallout", "plague", "riot", "famine",
        "revolution", "coup", "earthquake", "volcano", "tech_advance", "religious_schism",
    ]
    for eff in effects:
        path = f"{OUTPUT}/effects/{eff}.svg"
        save_svg(path, gen_effect(eff))
        count += 1

    print(f"Gerados {count} arquivos SVG em {OUTPUT}/")

if __name__ == "__main__":
    main()
