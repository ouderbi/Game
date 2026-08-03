#!/usr/bin/env python3
"""Gera 36 ativos extras: 12 decorações de mapa + 12 transições de era + 12 marcos naturais = 500 total."""
from gerar_common import *

# ── Decorações de mapa (12: 1 por era) ────────────────────────────────
DECORATIONS = {
    1: ("totem_pole","Totem"),
    2: ("obelisk","Obelisco"),
    3: ("triumphal_arch","Arco do Triunfo"),
    4: ("wayside_cross","Cruz de Estrada"),
    5: ("statue_industrial","Estátua Industrial"),
    6: ("war_memorial","Memorial de Guerra"),
    7: ("digital_mural","Mural Digital"),
    8: ("holo_statue","Estátua Holográfica"),
    9: ("space_monument","Monumento Espacial"),
    10: ("planetary_beacon","Farol Planetário"),
    11: ("stellar_gateway","Portal Estelar"),
    12: ("cosmic_pillar","Pilar Cósmico"),
}

def gen_decoration(era_num, d_id, d_name):
    e = ERAS[era_num]
    w = h = 128
    by = 96
    body = f'  <ellipse cx="64" cy="{by+8}" rx="24" ry="6" fill="#000" opacity="0.2"/>\n'

    if era_num == 1:  # Totem
        body += f'''  <rect x="56" y="{by-72}" width="16" height="72" fill="{e['dark']}"/>
  <circle cx="64" cy="{by-64}" r="10" fill="{e['base']}"/>
  <circle cx="60" cy="{by-64}" r="2" fill="{e['dark']}"/>
  <circle cx="68" cy="{by-64}" r="2" fill="{e['dark']}"/>
  <rect x="56" y="{by-48}" width="16" height="4" fill="{e['accent']}"/>
  <rect x="56" y="{by-32}" width="16" height="4" fill="{e['accent']}"/>
  <polygon points="56,{by-72} 72,{by-72} 64,{by-80}" fill="{e['accent']}"/>'''
    elif era_num == 2:  # Obelisk
        body += f'''  <polygon points="52,{by} 76,{by} 72,{by-72} 56,{by-72}" fill="{e['base']}"/>
  <polygon points="56,{by-72} 72,{by-72} 64,{by-84}" fill="{e['accent']}"/>
  <line x1="56" y1="{by-60}" x2="72" y2="{by-60}" stroke="{e['dark']}" stroke-width="0.5" opacity="0.4"/>
  <line x1="56" y1="{by-40}" x2="72" y2="{by-40}" stroke="{e['dark']}" stroke-width="0.5" opacity="0.4"/>
  <line x1="56" y1="{by-20}" x2="72" y2="{by-20}" stroke="{e['dark']}" stroke-width="0.5" opacity="0.4"/>'''
    elif era_num == 3:  # Arco do Triunfo
        body += f'''  <rect x="36" y="{by-56}" width="56" height="56" fill="{e['base']}"/>
  <rect x="44" y="{by-40}" width="16" height="40" fill="{e['dark']}" opacity="0.4"/>
  <rect x="68" y="{by-40}" width="16" height="40" fill="{e['dark']}" opacity="0.4"/>
  <rect x="36" y="{by-56}" width="56" height="8" fill="{e['accent']}"/>
  <rect x="36" y="{by-8}" width="56" height="8" fill="{e['dark']}"/>
  <polygon points="56,{by-56} 72,{by-56} 64,{by-64}" fill="{e['accent']}"/>'''
    elif era_num == 4:  # Cruz de Estrada
        body += f'''  <rect x="60" y="{by-48}" width="8" height="48" fill="{e['dark']}"/>
  <rect x="48" y="{by-36}" width="32" height="8" fill="{e['dark']}"/>
  <circle cx="64" cy="{by-32}" r="4" fill="{e['accent']}" opacity="0.5"/>
  <rect x="56" y="{by-48}" width="16" height="4" fill="{e['base']}"/>'''
    elif era_num == 5:  # Estátua Industrial
        body += f'''  <rect x="56" y="{by-16}" width="16" height="16" fill="{e['dark']}"/>
  <rect x="52" y="{by-48}" width="24" height="32" fill="{e['base']}"/>
  <circle cx="64" cy="{by-56}" r="8" fill="{e['base']}"/>
  <rect x="56" y="{by-40}" width="16" height="4" fill="{e['accent']}"/>
  <line x1="52" y1="{by-32}" x2="40" y2="{by-24}" stroke="{e['base']}" stroke-width="3"/>
  <line x1="76" y1="{by-32}" x2="88" y2="{by-24}" stroke="{e['base']}" stroke-width="3"/>'''
    elif era_num == 6:  # Memorial de Guerra
        body += f'''  <polygon points="52,{by} 76,{by} 72,{by-48} 56,{by-48}" fill="{e['dark']}"/>
  <polygon points="56,{by-48} 72,{by-48} 64,{by-60}" fill="{e['accent']}"/>
  <rect x="60" y="{by-40}" width="8" height="20" fill="{e['base']}" opacity="0.5"/>
  <line x1="64" y1="{by-60}" x2="64" y2="{by-72}" stroke="{e['accent']}" stroke-width="1"/>'''
    elif era_num == 7:  # Mural Digital
        body += f'''  <rect x="40" y="{by-48}" width="48" height="48" fill="{e['dark']}"/>
  <rect x="44" y="{by-44}" width="40" height="40" fill="{e['base']}" opacity="0.3"/>
  <rect x="48" y="{by-40}" width="32" height="4" fill="{e['accent']}" opacity="0.6"/>
  <rect x="48" y="{by-32}" width="32" height="4" fill="{e['accent']}" opacity="0.4"/>
  <rect x="48" y="{by-24}" width="32" height="4" fill="{e['accent']}" opacity="0.6"/>
  <rect x="48" y="{by-16}" width="32" height="4" fill="{e['accent']}" opacity="0.4"/>'''
    elif era_num == 8:  # Estátua Holográfica
        body += f'''  <ellipse cx="64" cy="{by-4}" rx="20" ry="4" fill="{e['accent']}" opacity="0.3"/>
  <ellipse cx="64" cy="{by-32}" rx="16" ry="32" fill="{e['accent']}" opacity="0.15" stroke="{e['accent']}" stroke-width="1"/>
  <circle cx="64" cy="{by-48}" r="8" fill="{e['accent']}" opacity="0.3"/>
  <line x1="64" y1="{by-4}" x2="64" y2="{by-56}" stroke="{e['accent']}" stroke-width="0.5" opacity="0.4"/>'''
    elif era_num == 9:  # Monumento Espacial
        body += f'''  <ellipse cx="64" cy="{by-4}" rx="24" ry="6" fill="{e['dark']}"/>
  <rect x="56" y="{by-40}" width="16" height="36" fill="{e['base']}"/>
  <circle cx="64" cy="{by-48}" r="12" fill="{e['accent']}" opacity="0.4"/>
  <circle cx="64" cy="{by-48}" r="6" fill="{e['accent']}"/>
  <line x1="48" y1="{by-20}" x2="40" y2="{by-10}" stroke="{e['base']}" stroke-width="2"/>
  <line x1="80" y1="{by-20}" x2="88" y2="{by-10}" stroke="{e['base']}" stroke-width="2"/>'''
    elif era_num == 10:  # Farol Planetário
        body += f'''  <ellipse cx="64" cy="{by-4}" rx="28" ry="6" fill="{e['dark']}"/>
  <rect x="56" y="{by-56}" width="16" height="52" fill="{e['base']}"/>
  <circle cx="64" cy="{by-64}" r="12" fill="{e['accent']}" opacity="0.4"/>
  <circle cx="64" cy="{by-64}" r="6" fill="{e['accent']}"/>
  <line x1="64" y1="{by-76}" x2="64" y2="0" stroke="{e['accent']}" stroke-width="1" opacity="0.3"/>'''
    elif era_num == 11:  # Portal Estelar
        body += f'''  <ellipse cx="64" cy="{by-32}" rx="28" ry="36" fill="none" stroke="{e['accent']}" stroke-width="2" opacity="0.5"/>
  <ellipse cx="64" cy="{by-32}" rx="20" ry="28" fill="{e['base']}" opacity="0.2"/>
  <ellipse cx="64" cy="{by-32}" rx="12" ry="18" fill="{e['accent']}" opacity="0.2"/>
  <circle cx="64" cy="{by-32}" r="4" fill="{e['accent']}"/>
  <line x1="36" y1="{by-32}" x2="28" y2="{by-32}" stroke="{e['accent']}" stroke-width="1" opacity="0.4"/>
  <line x1="92" y1="{by-32}" x2="100" y2="{by-32}" stroke="{e['accent']}" stroke-width="1" opacity="0.4"/>'''
    elif era_num == 12:  # Pilar Cósmico
        body += f'''  <ellipse cx="64" cy="{by-4}" rx="24" ry="6" fill="{e['dark']}"/>
  <rect x="56" y="{by-80}" width="16" height="76" fill="{e['accent']}" opacity="0.2"/>
  <rect x="56" y="{by-80}" width="16" height="76" fill="none" stroke="{e['accent']}" stroke-width="1" opacity="0.4"/>
  <circle cx="64" cy="{by-88}" r="8" fill="{e['accent']}" opacity="0.4"/>
  <circle cx="64" cy="{by-88}" r="3" fill="#fff" opacity="0.6"/>
  <line x1="48" y1="{by-40}" x2="80" y2="{by-40}" stroke="{e['accent']}" stroke-width="0.5" opacity="0.3"/>'''
    return svg_wrap(w, h, body)

# ── Transições de era (12: 1 por era) ─────────────────────────────────
ERA_TRANSITIONS = {
    1: ("to_antiquity","Para Antiguidade"),
    2: ("to_classical","Para Clássica"),
    3: ("to_medieval","Para Medieval"),
    4: ("to_industrial","Para Industrial"),
    5: ("to_modern","Para Moderna"),
    6: ("to_information","Para Informação"),
    7: ("to_high_tech","Para Alta Tecnologia"),
    8: ("to_space","Para Espacial"),
    9: ("to_interplanetary","Para Interplanetária"),
    10: ("to_stellar","Para Estelar"),
    11: ("to_intergalactic","Para Intergaláctica"),
    12: ("to_transcendence","Para Transcendência"),
}

def gen_era_transition(era_num, t_id, t_name):
    e = ERAS[era_num]
    w = h = 128
    cx, cy = 64, 64
    body = f'  <circle cx="{cx}" cy="{cy}" r="50" fill="none" stroke="{e["accent"]}" stroke-width="2" opacity="0.3"/>\n'
    body += f'  <circle cx="{cx}" cy="{cy}" r="36" fill="none" stroke="{e["accent"]}" stroke-width="1.5" opacity="0.4"/>\n'
    body += f'  <circle cx="{cx}" cy="{cy}" r="22" fill="{e["base"]}" opacity="0.15"/>\n'
    # Arrow pointing up (progress)
    body += f'  <polygon points="{cx},{cy-30} {cx+16},{cy-8} {cx+8},{cy-8} {cx+8},{cy+20} {cx-8},{cy+20} {cx-8},{cy-8} {cx-16},{cy-8}" fill="{e["accent"]}" opacity="0.6"/>\n'
    # Rays
    for a in range(0, 360, 45):
        r = math.radians(a)
        x1 = cx + math.cos(r) * 40
        y1 = cy + math.sin(r) * 40
        x2 = cx + math.cos(r) * 50
        y2 = cy + math.sin(r) * 50
        body += f'  <line x1="{x1:.0f}" y1="{y1:.0f}" x2="{x2:.0f}" y2="{y2:.0f}" stroke="{e["accent"]}" stroke-width="1.5" opacity="0.4"/>\n'
    return svg_wrap(w, h, body)

# ── Marcos naturais (12: 1 por bioma + 3 extras) ─────────────────────
NATURAL_LANDMARKS = [
    ("ocean_reef", "Recife de Coral", "ocean"),
    ("plains_river", "Rio Sinuoso", "plains"),
    ("forest_ancient_tree", "Árvore Ancestral", "forest"),
    ("desert_oasis", "Oásis", "desert"),
    ("mountain_peak", "Pico Sagrado", "mountain"),
    ("tundra_iceberg", "Iceberg", "tundra"),
    ("savana_baobab", "Baobá", "savanna"),
    ("swamp_mangrove", "Mangue", "swamp"),
    ("coast_arch", "Arco Natural", "coast"),
    ("volcano_active", "Vulcão Ativo", "mountain"),
    ("geyser", "Gêiser", "plains"),
    ("crater_lake", "Lago de Cratera", "mountain"),
]

def gen_landmark(l_id, l_name, biome_key):
    b = BIOMAS.get(biome_key, BIOMAS["plains"])
    w = h = 128
    by = 96
    body = f'  <ellipse cx="64" cy="{by+8}" rx="36" ry="8" fill="#000" opacity="0.2"/>\n'

    if l_id == "ocean_reef":
        body += f'''  <ellipse cx="64" cy="{by-8}" rx="40" ry="12" fill="{b['dark']}" opacity="0.5"/>
  <ellipse cx="64" cy="{by-16}" rx="32" ry="10" fill="{b['base']}" opacity="0.4"/>
  <circle cx="48" cy="{by-20}" r="6" fill="{b['light']}" opacity="0.5"/>
  <circle cx="64" cy="{by-24}" r="8" fill="{b['light']}" opacity="0.4"/>
  <circle cx="80" cy="{by-20}" r="5" fill="{b['light']}" opacity="0.5"/>
  <circle cx="56" cy="{by-28}" r="3" fill="#FF6B35" opacity="0.4"/>
  <circle cx="72" cy="{by-30}" r="2" fill="#FFD700" opacity="0.4"/>'''
    elif l_id == "plains_river":
        body += f'''  <path d="M 16,{by-8} Q 32,{by-20} 48,{by-12} T 80,{by-16} T 112,{by-8}" fill="none" stroke="{b['dark']}" stroke-width="6" opacity="0.6"/>
  <path d="M 16,{by-8} Q 32,{by-20} 48,{by-12} T 80,{by-16} T 112,{by-8}" fill="none" stroke="{b['light']}" stroke-width="3" opacity="0.4"/>
  <ellipse cx="64" cy="{by-16}" rx="8" ry="3" fill="{b['light']}" opacity="0.3"/>'''
    elif l_id == "forest_ancient_tree":
        body += f'''  <rect x="58" y="{by-40}" width="12" height="40" fill="{b['dark']}"/>
  <circle cx="64" cy="{by-52}" r="24" fill="{b['base']}" opacity="0.7"/>
  <circle cx="48" cy="{by-44}" r="16" fill="{b['base']}" opacity="0.6"/>
  <circle cx="80" cy="{by-44}" r="16" fill="{b['base']}" opacity="0.6"/>
  <circle cx="64" cy="{by-60}" r="16" fill="{b['detail']}" opacity="0.5"/>'''
    elif l_id == "desert_oasis":
        body += f'''  <ellipse cx="64" cy="{by-8}" rx="28" ry="10" fill="{b['dark']}" opacity="0.5"/>
  <ellipse cx="64" cy="{by-12}" rx="20" ry="6" fill="#1B4B7A" opacity="0.6"/>
  <circle cx="48" cy="{by-24}" r="8" fill="{b['base']}" opacity="0.5"/>
  <circle cx="80" cy="{by-20}" r="6" fill="{b['base']}" opacity="0.5"/>
  <line x1="48" y1="{by-24}" x2="48" y2="{by-12}" stroke="{b['dark']}" stroke-width="2"/>
  <line x1="80" y1="{by-20}" x2="80" y2="{by-12}" stroke="{b['dark']}" stroke-width="2"/>'''
    elif l_id == "mountain_peak":
        body += f'''  <polygon points="24,{by} 64,{by-72} 104,{by}" fill="{b['dark']}" opacity="0.8"/>
  <polygon points="64,{by-72} 80,{by-40} 48,{by-40}" fill="{b['light']}" opacity="0.5"/>
  <polygon points="56,{by-56} 72,{by-56} 64,{by-64}" fill="#fff" opacity="0.6"/>'''
    elif l_id == "tundra_iceberg":
        body += f'''  <polygon points="40,{by} 56,{by-48} 72,{by-32} 88,{by}" fill="{b['light']}" opacity="0.7"/>
  <polygon points="56,{by-48} 72,{by-32} 64,{by-40}" fill="{b['base']}" opacity="0.5"/>
  <polygon points="48,{by} 56,{by-32} 64,{by-20} 56,{by}" fill="{b['light']}" opacity="0.4"/>
  <ellipse cx="64" cy="{by-4}" rx="32" ry="6" fill="{b['dark']}" opacity="0.3"/>'''
    elif l_id == "savanna_baobab":
        body += f'''  <rect x="58" y="{by-32}" width="12" height="32" fill="{b['dark']}"/>
  <ellipse cx="64" cy="{by-40}" rx="28" ry="12" fill="{b['base']}" opacity="0.6"/>
  <ellipse cx="48" cy="{by-36}" rx="14" ry="8" fill="{b['detail']}" opacity="0.5"/>
  <ellipse cx="80" cy="{by-36}" rx="14" ry="8" fill="{b['detail']}" opacity="0.5"/>'''
    elif l_id == "swamp_mangrove":
        body += f'''  <rect x="48" y="{by-28}" width="6" height="28" fill="{b['dark']}"/>
  <rect x="74" y="{by-24}" width="6" height="24" fill="{b['dark']}"/>
  <ellipse cx="52" cy="{by-32}" rx="14" ry="8" fill="{b['base']}" opacity="0.6"/>
  <ellipse cx="78" cy="{by-28}" rx="14" ry="8" fill="{b['base']}" opacity="0.6"/>
  <ellipse cx="64" cy="{by-4}" rx="36" ry="6" fill="{b['dark']}" opacity="0.4"/>'''
    elif l_id == "coast_arch":
        body += f'''  <polygon points="32,{by} 32,{by-32} 48,{by-48} 80,{by-48} 96,{by-32} 96,{by}" fill="{b['dark']}" opacity="0.7"/>
  <polygon points="32,{by-32} 48,{by-48} 80,{by-48} 96,{by-32}" fill="none" stroke="{b['base']}" stroke-width="2" opacity="0.5"/>
  <ellipse cx="64" cy="{by-4}" rx="28" ry="6" fill="#1B4B7A" opacity="0.3"/>'''
    elif l_id == "volcano_active":
        body += f'''  <polygon points="20,{by} 64,{by-56} 108,{by}" fill="#5A4A38" opacity="0.8"/>
  <polygon points="48,{by-56} 80,{by-56} 64,{by-72}" fill="#FF4500" opacity="0.7"/>
  <polygon points="56,{by-56} 72,{by-56} 64,{by-68}" fill="#FFD700" opacity="0.6"/>
  <circle cx="58" cy="{by-62}" r="3" fill="#FF8C00" opacity="0.5"/>
  <circle cx="70" cy="{by-60}" r="2" fill="#FF8C00" opacity="0.5"/>'''
    elif l_id == "geyser":
        body += f'''  <ellipse cx="64" cy="{by-4}" rx="24" ry="6" fill="{b['dark']}" opacity="0.5"/>
  <polygon points="56,{by-4} 72,{by-4} 68,{by-40} 60,{by-40}" fill="#B0C4DE" opacity="0.5"/>
  <polygon points="60,{by-40} 68,{by-40} 64,{by-56}" fill="#fff" opacity="0.4"/>
  <circle cx="64" cy="{by-48}" r="3" fill="#fff" opacity="0.5"/>
  <circle cx="60" cy="{by-52}" r="2" fill="#B0C4DE" opacity="0.4"/>'''
    elif l_id == "crater_lake":
        body += f'''  <polygon points="20,{by} 40,{by-24} 88,{by-24} 108,{by}" fill="#7A7670" opacity="0.6"/>
  <ellipse cx="64" cy="{by-20}" rx="28" ry="8" fill="#1B4B7A" opacity="0.5"/>
  <ellipse cx="64" cy="{by-22}" rx="20" ry="5" fill="#3A8BC0" opacity="0.3"/>
  <polygon points="40,{by-24} 88,{by-24} 80,{by-28} 48,{by-28}" fill="#5A564F" opacity="0.4"/>'''
    return svg_wrap(w, h, body)

def generate_all():
    count = 0
    for era_num in range(1, 13):
        d_id, d_name = DECORATIONS[era_num]
        save_svg(f"{OUTPUT}/decorations/{d_id}.svg", gen_decoration(era_num, d_id, d_name))
        count += 1
    for era_num in range(1, 13):
        t_id, t_name = ERA_TRANSITIONS[era_num]
        save_svg(f"{OUTPUT}/transitions/{t_id}.svg", gen_era_transition(era_num, t_id, t_name))
        count += 1
    for l_id, l_name, biome_key in NATURAL_LANDMARKS:
        save_svg(f"{OUTPUT}/landmarks/{l_id}.svg", gen_landmark(l_id, l_name, biome_key))
        count += 1
    return count
