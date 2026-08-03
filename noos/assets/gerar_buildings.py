#!/usr/bin/env python3
"""Gera 120 edifícios (10 por era × 12 eras). Cada edifício tem estilo único."""
from gerar_common import *

def _shadow(by):
    return f'  <ellipse cx="64" cy="{by+8}" rx="40" ry="10" fill="#000" opacity="0.25"/>\n'

def _base_rect(e, by, x, y_off, w, h, fill_key="base"):
    y = by - y_off
    return f'  <rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{e[fill_key]}"/>\n'

def _roof_tri(e, by, x1, x2, peak_h, fill_key="accent"):
    yb = by - peak_h
    return f'  <polygon points="{x1},{by} {x2},{by} {(x1+x2)/2},{yb}" fill="{e[fill_key]}"/>\n'

def _door(e, by, x, w, h, fill_key="dark"):
    y = by - h
    return f'  <rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{e[fill_key]}" opacity="0.6"/>\n'

def _window(e, by, x, y_off, w, h):
    y = by - y_off
    return f'  <rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{e['light']}" opacity="0.5"/>\n'

def gen_building(era_num, b_id, b_name, category):
    e = ERAS[era_num]
    w = h = 128
    by = 96
    body = _shadow(by)
    cat = category
    # Dispatch by era+category with unique art per building
    body += _gen(era_num, e, by, b_id, cat)
    return svg_wrap(w, h, body)

def _gen(era, e, by, bid, cat):
    # Stone Age (era 1)
    if era == 1:
        if bid == "palisade":
            return f'''  <rect x="32" y="{by-40}" width="8" height="40" fill="{e['dark']}"/>
  <rect x="44" y="{by-48}" width="8" height="48" fill="{e['base']}"/>
  <rect x="56" y="{by-44}" width="8" height="44" fill="{e['dark']}"/>
  <rect x="68" y="{by-50}" width="8" height="50" fill="{e['base']}"/>
  <rect x="80" y="{by-42}" width="8" height="42" fill="{e['dark']}"/>
  <polygon points="44,{by-48} 52,{by-48} 48,{by-54}" fill="{e['accent']}"/>
  <polygon points="68,{by-50} 76,{by-50} 72,{by-56}" fill="{e['accent']}"/>'''
        if bid == "stone_circle":
            s = ""
            for a in range(0, 360, 45):
                r = math.radians(a)
                x = 64 + math.cos(r) * 28
                y = by - 16 + math.sin(r) * 14
                s += f'  <ellipse cx="{x:.0f}" cy="{y:.0f}" rx="6" ry="10" fill="{e["base"]}"/>\n  <ellipse cx="{x:.0f}" cy="{y-3:.0f}" rx="5" ry="8" fill="{e["light"]}" opacity="0.6"/>\n'
            return s + f'  <circle cx="64" cy="{by-16}" r="8" fill="{e["dark"]}" opacity="0.5"/>'
        if bid == "hunting_camp":
            return f'''  <polygon points="40,{by} 56,{by-36} 72,{by}" fill="none" stroke="{e['dark']}" stroke-width="3"/>
  <polygon points="40,{by} 56,{by-36} 72,{by}" fill="{e['base']}" opacity="0.3"/>
  <line x1="56" y1="{by-36}" x2="56" y2="{by}" stroke="{e['dark']}" stroke-width="2"/>
  <circle cx="56" cy="{by-40}" r="4" fill="{e['accent']}"/>
  <line x1="48" y1="{by-12}" x2="64" y2="{by-12}" stroke="{e['accent']}" stroke-width="1" opacity="0.6"/>'''
        if bid == "fire_pit":
            return f'''  <ellipse cx="64" cy="{by-8}" rx="20" ry="6" fill="{e['dark']}"/>
  <polygon points="56,{by-8} 72,{by-8} 64,{by-32}" fill="#FF4500" opacity="0.8"/>
  <polygon points="60,{by-8} 68,{by-8} 64,{by-24}" fill="#FFD700" opacity="0.7"/>
  <circle cx="58" cy="{by-16}" r="2" fill="#FF8C00" opacity="0.6"/>
  <circle cx="70" cy="{by-14}" r="1.5" fill="#FF8C00" opacity="0.5"/>
  <rect x="48" y="{by-4}" width="6" height="4" fill="{e['base']}"/>
  <rect x="74" y="{by-4}" width="6" height="4" fill="{e['base']}"/>'''
        if bid == "shaman_hut":
            return f'''  <polygon points="40,{by} 88,{by} 80,{by-32} 48,{by-32}" fill="{e['dark']}"/>
  <polygon points="48,{by-32} 80,{by-32} 72,{by-44} 56,{by-44}" fill="{e['base']}"/>
  <circle cx="64" cy="{by-38}" r="4" fill="{e['accent']}"/>
  <line x1="56" y1="{by-20}" x2="72" y2="{by-20}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>
  <line x1="60" y1="{by-14}" x2="68" y2="{by-14}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>'''
        if bid == "tool_workshop":
            return f'''  <rect x="44" y="{by-28}" width="40" height="28" fill="{e['base']}"/>
  <polygon points="40,{by-28} 88,{by-28} 80,{by-40} 48,{by-40}" fill="{e['dark']}"/>
  <rect x="56" y="{by-20}" width="16" height="20" fill="{e['dark']}" opacity="0.5"/>
  <line x1="52" y1="{by-12}" x2="60" y2="{by-12}" stroke="{e['accent']}" stroke-width="1"/>
  <line x1="68" y1="{by-12}" x2="76" y2="{by-12}" stroke="{e['accent']}" stroke-width="1"/>'''
        if bid == "hut_cluster":
            huts = ""
            for hx, hy, hs in [(40, by-20, 16), (72, by-16, 14), (56, by-28, 18)]:
                huts += f'  <polygon points="{hx},{by} {hx+hs},{by} {hx+hs/2:.0f},{hy}" fill="{e["base"]}"/>\n'
                huts += f'  <polygon points="{hx+2},{by} {hx+hs-2},{by} {hx+hs/2:.0f},{hy+4}" fill="{e["dark"]}" opacity="0.3"/>\n'
            return huts
        if bid == "watch_tower_primitive":
            return f'''  <rect x="58" y="{by-48}" width="12" height="48" fill="{e['dark']}"/>
  <rect x="52" y="{by-56}" width="24" height="12" fill="{e['base']}"/>
  <polygon points="52,{by-56} 76,{by-56} 64,{by-64}" fill="{e['accent']}"/>
  <rect x="60" y="{by-52}" width="8" height="6" fill="{e['dark']}" opacity="0.5"/>'''
        if bid == "burial_mound":
            return f'''  <ellipse cx="64" cy="{by-4}" rx="36" ry="10" fill="{e['dark']}"/>
  <ellipse cx="64" cy="{by-12}" rx="28" ry="8" fill="{e['base']}"/>
  <ellipse cx="64" cy="{by-18}" rx="18" ry="5" fill="{e['light']}" opacity="0.6"/>
  <rect x="60" y="{by-28}" width="8" height="16" fill="{e['dark']}"/>
  <polygon points="56,{by-28} 72,{by-28} 64,{by-36}" fill="{e['accent']}"/>'''
        if bid == "gatherers_camp":
            return f'''  <polygon points="36,{by} 52,{by-24} 68,{by}" fill="none" stroke="{e['dark']}" stroke-width="2"/>
  <polygon points="60,{by} 76,{by-20} 88,{by}" fill="none" stroke="{e['dark']}" stroke-width="2"/>
  <polygon points="36,{by} 52,{by-24} 68,{by}" fill="{e['base']}" opacity="0.2"/>
  <polygon points="60,{by} 76,{by-20} 88,{by}" fill="{e['base']}" opacity="0.2"/>
  <circle cx="48" cy="{by-8}" r="2" fill="{e['accent']}"/>
  <circle cx="76" cy="{by-8}" r="2" fill="{e['accent']}"/>'''

    # Antiquity (era 2)
    if era == 2:
        if bid == "mud_wall":
            return f'''  <rect x="28" y="{by-50}" width="72" height="50" fill="{e['base']}"/>
  <rect x="28" y="{by-50}" width="72" height="6" fill="{e['dark']}"/>
  <rect x="40" y="{by-30}" width="12" height="30" fill="{e['dark']}" opacity="0.6"/>
  <rect x="64" y="{by-30}" width="12" height="30" fill="{e['dark']}" opacity="0.6"/>
  <polygon points="28,{by-50} 100,{by-50} 96,{by-56} 32,{by-56}" fill="{e['accent']}" opacity="0.7"/>'''
        if bid == "ziggurat":
            return f'''  <polygon points="32,{by} 96,{by} 80,{by-16} 48,{by-16}" fill="{e['dark']}"/>
  <polygon points="40,{by-16} 88,{by-16} 76,{by-32} 52,{by-32}" fill="{e['base']}"/>
  <polygon points="48,{by-32} 80,{by-32} 72,{by-48} 56,{by-48}" fill="{e['light']}"/>
  <rect x="60" y="{by-48}" width="8" height="12" fill="{e['dark']}"/>
  <line x1="32" y1="{by}" x2="96" y2="{by}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>'''
        if bid == "granary":
            return f'''  <rect x="36" y="{by-36}" width="56" height="36" fill="{e['base']}"/>
  <polygon points="32,{by-36} 96,{by-36} 88,{by-48} 40,{by-48}" fill="{e['dark']}"/>
  <line x1="36" y1="{by-36}" x2="92" y2="0" stroke="{e['dark']}" stroke-width="0.5" opacity="0.3"/>
  <line x1="92" y1="{by-36}" x2="36" y2="0" stroke="{e['dark']}" stroke-width="0.5" opacity="0.3"/>
  <rect x="56" y="{by-24}" width="16" height="24" fill="{e['dark']}" opacity="0.6"/>'''
        if bid == "market_stall":
            return f'''  <rect x="40" y="{by-24}" width="48" height="24" fill="{e['base']}"/>
  <polygon points="36,{by-24} 92,{by-24} 84,{by-40} 44,{by-40}" fill="{e['accent']}"/>
  <line x1="40" y1="{by-24}" x2="40" y2="{by}" stroke="{e['dark']}" stroke-width="2"/>
  <line x1="88" y1="{by-24}" x2="88" y2="{by}" stroke="{e['dark']}" stroke-width="2"/>
  <rect x="48" y="{by-16}" width="8" height="8" fill="{e['dark']}" opacity="0.4"/>
  <rect x="64" y="{by-16}" width="8" height="8" fill="{e['dark']}" opacity="0.4"/>'''
        if bid == "scribes_school":
            return f'''  <rect x="36" y="{by-36}" width="56" height="36" fill="{e['base']}"/>
  <polygon points="32,{by-36} 96,{by-36} 88,{by-48} 40,{by-48}" fill="{e['dark']}"/>
  <rect x="44" y="{by-28}" width="8" height="12" fill="{e['dark']}" opacity="0.4"/>
  <rect x="56" y="{by-28}" width="8" height="12" fill="{e['dark']}" opacity="0.4"/>
  <rect x="68" y="{by-28}" width="8" height="12" fill="{e['dark']}" opacity="0.4"/>
  <rect x="80" y="{by-28}" width="8" height="12" fill="{e['dark']}" opacity="0.4"/>
  <line x1="36" y1="{by-20}" x2="92" y2="{by-20}" stroke="{e['accent']}" stroke-width="1" opacity="0.4"/>'''
        if bid == "pottery_kiln":
            return f'''  <rect x="48" y="{by-32}" width="32" height="32" fill="{e['dark']}"/>
  <rect x="52" y="{by-28}" width="24" height="28" fill="{e['base']}"/>
  <rect x="56" y="{by-24}" width="16" height="8" fill="{e['accent']}" opacity="0.5"/>
  <circle cx="64" cy="{by-36}" r="6" fill="{e['accent']}" opacity="0.4"/>
  <circle cx="64" cy="{by-36}" r="3" fill="{e['accent']}" opacity="0.6"/>'''
        if bid == "mud_houses":
            h = ""
            for hx, hw, hh in [(32, 24, 28), (64, 28, 32), (96, 20, 24)]:
                h += f'  <rect x="{hx}" y="{by-hh}" width="{hw}" height="{hh}" fill="{e["base"]}"/>\n'
                h += f'  <polygon points="{hx},{by-hh} {hx+hw},{by-hh} {hx+hw/2:.0f},{by-hh-8}" fill="{e["dark"]}"/>\n'
            return h
        if bid == "chariot_workshop":
            return f'''  <rect x="36" y="{by-32}" width="56" height="32" fill="{e['base']}"/>
  <polygon points="32,{by-32} 96,{by-32} 88,{by-44} 40,{by-44}" fill="{e['dark']}"/>
  <circle cx="52" cy="{by-8}" r="6" fill="{e['dark']}" opacity="0.5"/>
  <circle cx="76" cy="{by-8}" r="6" fill="{e['dark']}" opacity="0.5"/>
  <line x1="52" y1="{by-8}" x2="76" y2="{by-8}" stroke="{e['accent']}" stroke-width="1" opacity="0.4"/>'''
        if bid == "irrigation_channel":
            return f'''  <rect x="20" y="{by-8}" width="88" height="8" fill="{e['dark']}"/>
  <rect x="20" y="{by-6}" width="88" height="4" fill="{e['accent']}" opacity="0.4"/>
  <line x1="20" y1="{by-4}" x2="108" y2="{by-4}" stroke="{e['light']}" stroke-width="1" opacity="0.5"/>
  <rect x="28" y="{by-16}" width="4" height="8" fill="{e['base']}"/>
  <rect x="60" y="{by-16}" width="4" height="8" fill="{e['base']}"/>
  <rect x="92" y="{by-16}" width="4" height="8" fill="{e['base']}"/>'''
        if bid == "temple_altar":
            return f'''  <rect x="48" y="{by-16}" width="32" height="16" fill="{e['base']}"/>
  <rect x="52" y="{by-28}" width="24" height="12" fill="{e['dark']}"/>
  <polygon points="52,{by-28} 76,{by-28} 64,{by-40}" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-34}" r="3" fill="{e['light']}" opacity="0.7"/>
  <line x1="48" y1="{by-16}" x2="80" y2="{by-16}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>'''

    # Classical (era 3)
    if era == 3:
        if bid == "stone_wall":
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
        if bid == "academy":
            return f'''  <rect x="32" y="{by-40}" width="64" height="40" fill="{e['base']}"/>
  <polygon points="24,{by-40} 104,{by-40} 96,{by-52} 32,{by-52}" fill="{e['accent']}"/>
  <polygon points="24,{by-40} 104,{by-40} 96,{by-48} 32,{by-48}" fill="{e['light']}" opacity="0.6"/>
  <rect x="40" y="{by-36}" width="6" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="82" y="{by-36}" width="6" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="56" y="{by-28}" width="16" height="28" fill="{e['dark']}" opacity="0.5"/>
  <polygon points="56,{by-28} 72,{by-28} 64,{by-36}" fill="{e['dark']}" opacity="0.6"/>'''
        if bid == "agora":
            return f'''  <rect x="28" y="{by-32}" width="72" height="32" fill="{e['base']}"/>
  <rect x="24" y="{by-36}" width="80" height="6" fill="{e['accent']}"/>
  <rect x="32" y="{by-24}" width="8" height="24" fill="{e['dark']}" opacity="0.4"/>
  <rect x="48" y="{by-24}" width="8" height="24" fill="{e['dark']}" opacity="0.4"/>
  <rect x="72" y="{by-24}" width="8" height="24" fill="{e['dark']}" opacity="0.4"/>
  <rect x="88" y="{by-24}" width="8" height="24" fill="{e['dark']}" opacity="0.4"/>
  <circle cx="64" cy="{by-16}" r="6" fill="{e['accent']}" opacity="0.5"/>
  <rect x="60" y="{by-8}" width="8" height="8" fill="{e['dark']}" opacity="0.5"/>'''
        if bid == "amphitheater":
            return f'''  <ellipse cx="64" cy="{by-8}" rx="48" ry="12" fill="{e['dark']}"/>
  <ellipse cx="64" cy="{by-12}" rx="40" ry="10" fill="{e['base']}"/>
  <ellipse cx="64" cy="{by-16}" rx="32" ry="8" fill="{e['dark']}" opacity="0.4"/>
  <ellipse cx="64" cy="{by-20}" rx="24" ry="6" fill="{e['base']}" opacity="0.5"/>
  <ellipse cx="64" cy="{by-24}" rx="16" ry="4" fill="{e['accent']}" opacity="0.4"/>
  <rect x="56" y="{by-28}" width="16" height="4" fill="{e['dark']}"/>'''
        if bid == "pantheon":
            return f'''  <rect x="36" y="{by-36}" width="56" height="36" fill="{e['base']}"/>
  <polygon points="32,{by-36} 96,{by-36} 64,{by-56}" fill="{e['accent']}"/>
  <rect x="40" y="{by-32}" width="6" height="32" fill="{e['dark']}" opacity="0.4"/>
  <rect x="52" y="{by-32}" width="6" height="32" fill="{e['dark']}" opacity="0.4"/>
  <rect x="70" y="{by-32}" width="6" height="32" fill="{e['dark']}" opacity="0.4"/>
  <rect x="82" y="{by-32}" width="6" height="32" fill="{e['dark']}" opacity="0.4"/>
  <rect x="58" y="{by-20}" width="12" height="20" fill="{e['dark']}" opacity="0.5"/>'''
        if bid == "aqueduct":
            return f'''  <rect x="20" y="{by-40}" width="88" height="40" fill="{e['base']}"/>
  <rect x="28" y="{by-32}" width="12" height="32" fill="{e['dark']}"/>
  <rect x="52" y="{by-32}" width="12" height="32" fill="{e['dark']}"/>
  <rect x="76" y="{by-32}" width="12" height="32" fill="{e['dark']}"/>
  <rect x="20" y="{by-40}" width="88" height="8" fill="{e['accent']}" opacity="0.5"/>
  <rect x="24" y="{by-36}" width="80" height="4" fill="{e['light']}" opacity="0.4"/>'''
        if bid == "villa":
            return f'''  <rect x="32" y="{by-32}" width="64" height="32" fill="{e['base']}"/>
  <polygon points="28,{by-32} 100,{by-32} 92,{by-44} 36,{by-44}" fill="{e['accent']}"/>
  <rect x="40" y="{by-24}" width="8" height="8" fill="{e['dark']}" opacity="0.4"/>
  <rect x="56" y="{by-24}" width="8" height="8" fill="{e['dark']}" opacity="0.4"/>
  <rect x="72" y="{by-24}" width="8" height="8" fill="{e['dark']}" opacity="0.4"/>
  <rect x="84" y="{by-24}" width="8" height="8" fill="{e['dark']}" opacity="0.4"/>
  <rect x="56" y="{by-12}" width="16" height="12" fill="{e['dark']}" opacity="0.5"/>'''
        if bid == "barracks_classical":
            return f'''  <rect x="32" y="{by-36}" width="64" height="36" fill="{e['base']}"/>
  <polygon points="28,{by-36} 100,{by-36} 92,{by-48} 36,{by-48}" fill="{e['dark']}"/>
  <rect x="40" y="{by-28}" width="8" height="16" fill="{e['dark']}" opacity="0.4"/>
  <rect x="56" y="{by-28}" width="8" height="16" fill="{e['dark']}" opacity="0.4"/>
  <rect x="72" y="{by-28}" width="8" height="16" fill="{e['dark']}" opacity="0.4"/>
  <rect x="84" y="{by-28}" width="8" height="16" fill="{e['dark']}" opacity="0.4"/>
  <rect x="56" y="{by-12}" width="16" height="12" fill="{e['accent']}" opacity="0.5"/>'''
        if bid == "harbor_docks":
            return f'''  <rect x="20" y="{by-12}" width="88" height="12" fill="{e['dark']}"/>
  <rect x="24" y="{by-16}" width="80" height="4" fill="{e['base']}"/>
  <rect x="28" y="{by-24}" width="8" height="12" fill="{e['dark']}"/>
  <rect x="52" y="{by-24}" width="8" height="12" fill="{e['dark']}"/>
  <rect x="76" y="{by-24}" width="8" height="12" fill="{e['dark']}"/>
  <rect x="96" y="{by-24}" width="8" height="12" fill="{e['dark']}"/>
  <line x1="32" y1="{by-24}" x2="48" y2="{by-24}" stroke="{e['accent']}" stroke-width="2" opacity="0.4"/>
  <line x1="56" y1="{by-24}" x2="72" y2="{by-24}" stroke="{e['accent']}" stroke-width="2" opacity="0.4"/>'''
        if bid == "library":
            return f'''  <rect x="36" y="{by-40}" width="56" height="40" fill="{e['base']}"/>
  <polygon points="32,{by-40} 96,{by-40} 88,{by-52} 40,{by-52}" fill="{e['accent']}"/>
  <rect x="44" y="{by-32}" width="40" height="24" fill="{e['dark']}" opacity="0.3"/>
  <line x1="44" y1="{by-28}" x2="84" y2="{by-28}" stroke="{e['dark']}" stroke-width="0.5" opacity="0.4"/>
  <line x1="44" y1="{by-22}" x2="84" y2="{by-22}" stroke="{e['dark']}" stroke-width="0.5" opacity="0.4"/>
  <line x1="44" y1="{by-16}" x2="84" y2="{by-16}" stroke="{e['dark']}" stroke-width="0.5" opacity="0.4"/>'''

    # For eras 4-12, use the original art for the first 3 buildings,
    # and parametric art for the 7 new ones
    return _gen_extended(era, e, by, bid, cat)

def _gen_extended(era, e, by, bid, cat):
    """Generate buildings for eras 4-12. First 3 use original art,
    buildings 4-10 use parametric art based on category + era palette."""
    # Original 3 buildings per era (from the 108-asset version)
    if era == 4 and bid == "castle":
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
    if era == 4 and bid == "cathedral":
        return f'''  <rect x="36" y="{by-44}" width="56" height="44" fill="{e['base']}"/>
  <polygon points="36,{by-44} 92,{by-44} 64,{by-64}" fill="{e['dark']}"/>
  <rect x="56" y="{by-64}" width="16" height="20" fill="{e['accent']}"/>
  <rect x="40" y="{by-36}" width="8" height="20" fill="{e['dark']}" opacity="0.5" rx="4"/>
  <rect x="80" y="{by-36}" width="8" height="20" fill="{e['dark']}" opacity="0.5" rx="4"/>
  <rect x="58" y="{by-30}" width="12" height="30" fill="{e['dark']}" opacity="0.6" rx="6"/>
  <polygon points="44,{by-44} 52,{by-44} 48,{by-50}" fill="{e['accent']}"/>
  <polygon points="76,{by-44} 84,{by-44} 80,{by-50}" fill="{e['accent']}"/>'''
    if era == 4 and bid == "windmill":
        return f'''  <rect x="56" y="{by-32}" width="16" height="32" fill="{e['base']}"/>
  <polygon points="32,{by-32} 56,{by-32} 44,{by-48}" fill="{e['dark']}"/>
  <polygon points="72,{by-32} 96,{by-32} 84,{by-48}" fill="{e['dark']}"/>
  <polygon points="56,{by-56} 72,{by-56} 64,{by-72}" fill="{e['dark']}"/>
  <polygon points="56,{by-8} 72,{by-8} 64,{by-24}" fill="{e['dark']}"/>
  <circle cx="64" cy="{by-32}" r="5" fill="{e['accent']}"/>
  <rect x="60" y="{by-20}" width="8" height="20" fill="{e['dark']}" opacity="0.5"/>'''
    if era == 5 and bid == "bastion_fort":
        return f'''  <polygon points="24,{by} 40,{by-40} 88,{by-40} 104,{by}" fill="{e['dark']}"/>
  <polygon points="32,{by} 44,{by-36} 84,{by-36} 96,{by}" fill="{e['base']}"/>
  <rect x="48" y="{by-52}" width="32" height="16" fill="{e['accent']}"/>
  <rect x="56" y="{by-48}" width="16" height="8" fill="{e['dark']}"/>
  <line x1="40" y1="{by-20}" x2="88" y2="{by-20}" stroke="{e['dark']}" stroke-width="1" opacity="0.4"/>'''
    if era == 5 and bid == "town_hall":
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
    if era == 5 and bid == "factory":
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
    if era == 6 and bid == "bunker":
        return f'''  <path d="M 28,{by} L 28,{by-32} Q 28,{by-44} 64,{by-44} Q 100,{by-44} 100,{by-32} L 100,{by} Z" fill="{e['dark']}"/>
  <path d="M 36,{by} L 36,{by-28} Q 36,{by-38} 64,{by-38} Q 92,{by-38} 92,{by-28} L 92,{by}" fill="{e['base']}"/>
  <rect x="52" y="{by-32}" width="24" height="10" fill="{e['dark']}" opacity="0.7" rx="2"/>
  <line x1="28" y1="{by-10}" x2="100" y2="{by-10}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>'''
    if era == 6 and bid == "parliament":
        return f'''  <rect x="28" y="{by-48}" width="72" height="48" fill="{e['base']}"/>
  <rect x="24" y="{by-52}" width="80" height="6" fill="{e['dark']}"/>
  <rect x="32" y="{by-36}" width="8" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="44" y="{by-36}" width="8" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="76" y="{by-36}" width="8" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="88" y="{by-36}" width="8" height="36" fill="{e['dark']}" opacity="0.4"/>
  <rect x="56" y="{by-28}" width="16" height="28" fill="{e['accent']}" opacity="0.6" rx="8"/>
  <circle cx="64" cy="{by-60}" r="6" fill="{e['accent']}"/>
  <rect x="62" y="{by-72}" width="4" height="12" fill="{e['accent']}"/>'''
    if era == 6 and bid == "power_plant":
        return f'''  <rect x="32" y="{by-48}" width="64" height="48" fill="{e['dark']}"/>
  <rect x="36" y="{by-44}" width="56" height="44" fill="{e['base']}"/>
  <rect x="44" y="{by-60}" width="8" height="20" fill="{e['dark']}"/>
  <rect x="76" y="{by-60}" width="8" height="20" fill="{e['dark']}"/>
  <circle cx="48" cy="{by-60}" r="3" fill="{e['accent']}" opacity="0.6"/>
  <circle cx="80" cy="{by-60}" r="3" fill="{e['accent']}" opacity="0.6"/>
  <line x1="36" y1="{by-30}" x2="92" y2="{by-30}" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>
  <line x1="36" y1="{by-20}" x2="92" y2="{by-20}" stroke="{e['accent']}" stroke-width="1" opacity="0.4"/>
  <rect x="56" y="{by-36}" width="16" height="16" fill="{e['accent']}" opacity="0.3"/>'''
    if era == 7 and bid == "sam_site":
        return f'''  <rect x="32" y="{by-32}" width="64" height="32" fill="{e['dark']}"/>
  <rect x="36" y="{by-36}" width="56" height="4" fill="{e['accent']}"/>
  <rect x="44" y="{by-56}" width="8" height="24" fill="{e['base']}"/>
  <rect x="60" y="{by-64}" width="8" height="32" fill="{e['base']}"/>
  <rect x="76" y="{by-52}" width="8" height="20" fill="{e['base']}"/>
  <polygon points="44,{by-56} 52,{by-56} 48,{by-64}" fill="{e['accent']}"/>
  <polygon points="60,{by-64} 68,{by-64} 64,{by-72}" fill="{e['accent']}"/>
  <polygon points="76,{by-52} 84,{by-52} 80,{by-60}" fill="{e['accent']}"/>'''
    if era == 7 and bid == "data_center":
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
    if era == 7 and bid == "solar_farm":
        return f'''  <rect x="32" y="{by-16}" width="64" height="16" fill="{e['dark']}"/>
  <polygon points="36,{by-16} 56,{by-16} 48,{by-40}" fill="{e['accent']}" opacity="0.7"/>
  <polygon points="60,{by-16} 80,{by-16} 72,{by-44}" fill="{e['accent']}" opacity="0.7"/>
  <polygon points="84,{by-16} 96,{by-16} 90,{by-36}" fill="{e['accent']}" opacity="0.7"/>
  <line x1="48" y1="{by-40}" x2="48" y2="{by-16}" stroke="{e['dark']}" stroke-width="1"/>
  <line x1="72" y1="{by-44}" x2="72" y2="{by-16}" stroke="{e['dark']}" stroke-width="1"/>
  <line x1="90" y1="{by-36}" x2="90" y2="{by-16}" stroke="{e['dark']}" stroke-width="1"/>
  <circle cx="64" cy="{by-48}" r="4" fill="{e['accent']}"/>'''
    if era == 8 and bid == "energy_shield":
        return f'''  <ellipse cx="64" cy="{by-20}" rx="44" ry="56" fill="{e['base']}" opacity="0.15" stroke="{e['base']}" stroke-width="2"/>
  <ellipse cx="64" cy="{by-20}" rx="36" ry="48" fill="{e['accent']}" opacity="0.1" stroke="{e['accent']}" stroke-width="1"/>
  <ellipse cx="64" cy="{by-20}" rx="28" ry="40" fill="{e['base']}" opacity="0.08"/>
  <rect x="56" y="{by-12}" width="16" height="12" fill="{e['dark']}"/>
  <circle cx="64" cy="{by-20}" r="3" fill="{e['accent']}"/>
  <line x1="64" y1="{by-44}" x2="64" y2="{by-36}" stroke="{e['accent']}" stroke-width="2"/>'''
    if era == 8 and bid == "ai_lab":
        return f'''  <rect x="36" y="{by-52}" width="56" height="52" fill="{e['dark']}"/>
  <rect x="40" y="{by-48}" width="48" height="44" fill="{e['base']}" opacity="0.3"/>
  <circle cx="64" cy="{by-28}" r="20" fill="none" stroke="{e['accent']}" stroke-width="2" opacity="0.6"/>
  <circle cx="64" cy="{by-28}" r="12" fill="none" stroke="{e['accent']}" stroke-width="1.5" opacity="0.8"/>
  <circle cx="64" cy="{by-28}" r="4" fill="{e['accent']}"/>
  <line x1="44" y1="{by-28}" x2="52" y2="{by-28}" stroke="{e['accent']}" stroke-width="1.5"/>
  <line x1="76" y1="{by-28}" x2="84" y2="{by-28}" stroke="{e['accent']}" stroke-width="1.5"/>'''
    if era == 8 and bid == "fusion_plant":
        return f'''  <rect x="36" y="{by-44}" width="56" height="44" fill="{e['dark']}"/>
  <circle cx="64" cy="{by-28}" r="20" fill="none" stroke="{e['accent']}" stroke-width="2" opacity="0.7"/>
  <circle cx="64" cy="{by-28}" r="14" fill="{e['base']}" opacity="0.2"/>
  <circle cx="64" cy="{by-28}" r="8" fill="{e['accent']}" opacity="0.4"/>
  <circle cx="64" cy="{by-28}" r="3" fill="#fff" opacity="0.8"/>
  <line x1="44" y1="{by-28}" x2="52" y2="{by-28}" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="76" y1="{by-28}" x2="84" y2="{by-28}" stroke="{e['accent']}" stroke-width="2"/>'''
    if era == 9 and bid == "orbital_defense":
        return f'''  <circle cx="64" cy="{by-40}" r="28" fill="none" stroke="{e['accent']}" stroke-width="2" opacity="0.6"/>
  <circle cx="64" cy="{by-40}" r="20" fill="{e['dark']}" opacity="0.8"/>
  <circle cx="64" cy="{by-40}" r="14" fill="{e['base']}" opacity="0.5"/>
  <circle cx="64" cy="{by-40}" r="6" fill="{e['accent']}"/>
  <line x1="36" y1="{by-40}" x2="20" y2="{by-40}" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="92" y1="{by-40}" x2="108" y2="{by-40}" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="64" y1="{by-12}" x2="64" y2="0" stroke="{e['accent']}" stroke-width="2" opacity="0.5"/>
  <circle cx="20" cy="{by-40}" r="4" fill="{e['base']}"/>
  <circle cx="108" cy="{by-40}" r="4" fill="{e['base']}"/>'''
    if era == 9 and bid == "space_colony":
        return f'''  <ellipse cx="64" cy="{by-8}" rx="44" ry="8" fill="{e['dark']}"/>
  <rect x="48" y="{by-48}" width="32" height="40" fill="{e['base']}"/>
  <rect x="52" y="{by-44}" width="24" height="36" fill="{e['accent']}" opacity="0.3"/>
  <ellipse cx="64" cy="{by-48}" rx="16" ry="4" fill="{e['accent']}"/>
  <circle cx="56" cy="{by-36}" r="3" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-36}" r="3" fill="{e['accent']}"/>
  <circle cx="72" cy="{by-36}" r="3" fill="{e['accent']}"/>'''
    if era == 9 and bid == "rocket_launch":
        return f'''  <rect x="48" y="{by-24}" width="32" height="24" fill="{e['dark']}"/>
  <rect x="56" y="{by-72}" width="16" height="48" fill="{e['base']}"/>
  <polygon points="56,{by-72} 72,{by-72} 64,{by-84}" fill="{e['accent']}"/>
  <rect x="36" y="{by-40}" width="8" height="40" fill="{e['base']}"/>
  <rect x="84" y="{by-40}" width="8" height="40" fill="{e['base']}"/>
  <line x1="40" y1="{by-40}" x2="56" y2="{by-60}" stroke="{e['base']}" stroke-width="1"/>
  <line x1="88" y1="{by-40}" x2="72" y2="{by-60}" stroke="{e['base']}" stroke-width="1"/>
  <circle cx="64" cy="{by-12}" r="10" fill="{e['accent']}" opacity="0.3"/>'''
    if era == 10 and bid == "defense_grid":
        return f'''  <circle cx="64" cy="{by-36}" r="32" fill="none" stroke="{e['accent']}" stroke-width="1" opacity="0.4"/>
  <circle cx="64" cy="{by-36}" r="24" fill="{e['dark']}" opacity="0.6"/>
  <circle cx="64" cy="{by-36}" r="16" fill="{e['base']}" opacity="0.4"/>
  <polygon points="64,{by-60} 72,{by-44} 56,{by-44}" fill="{e['accent']}"/>
  <polygon points="64,{by-12} 72,{by-28} 56,{by-28}" fill="{e['accent']}"/>
  <polygon points="36,{by-36} 52,{by-32} 52,{by-40}" fill="{e['accent']}"/>
  <polygon points="92,{by-36} 76,{by-32} 76,{by-40}" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-36}" r="4" fill="{e['accent']}"/>'''
    if era == 10 and bid == "terraforming":
        return f'''  <ellipse cx="64" cy="{by-8}" rx="40" ry="8" fill="{e['dark']}"/>
  <path d="M 28,{by-8} Q 28,{by-44} 64,{by-44} Q 100,{by-44} 100,{by-8}" fill="{e['base']}" opacity="0.6"/>
  <path d="M 36,{by-12} Q 36,{by-36} 64,{by-36} Q 92,{by-36} 92,{by-12}" fill="{e['accent']}" opacity="0.3"/>
  <circle cx="48" cy="{by-24}" r="4" fill="{e['accent']}"/>
  <circle cx="72" cy="{by-20}" r="3" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-32}" r="2" fill="{e['accent']}"/>'''
    if era == 10 and bid == "asteroid_mine":
        return f'''  <polygon points="28,{by-20} 48,{by-32} 72,{by-28} 96,{by-16} 80,{by} 36,{by}" fill="{e['dark']}"/>
  <polygon points="36,{by-16} 52,{by-26} 68,{by-24} 84,{by-12} 72,{by} 44,{by}" fill="{e['base']}" opacity="0.6"/>
  <circle cx="56" cy="{by-20}" r="3" fill="{e['accent']}"/>
  <circle cx="72" cy="{by-16}" r="2" fill="{e['accent']}"/>
  <rect x="48" y="{by-40}" width="8" height="20" fill="{e['base']}"/>
  <rect x="68" y="{by-44}" width="8" height="24" fill="{e['base']}"/>'''
    if era == 11 and bid == "fleet_station":
        return f'''  <rect x="48" y="{by-52}" width="32" height="8" fill="{e['accent']}"/>
  <rect x="56" y="{by-44}" width="16" height="40" fill="{e['dark']}"/>
  <rect x="52" y="{by-44}" width="4" height="40" fill="{e['base']}"/>
  <rect x="72" y="{by-44}" width="4" height="40" fill="{e['base']}"/>
  <circle cx="64" cy="{by-36}" r="6" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-36}" r="3" fill="{e['light']}"/>
  <rect x="40" y="{by-20}" width="8" height="16" fill="{e['base']}"/>
  <rect x="80" y="{by-20}" width="8" height="16" fill="{e['base']}"/>'''
    if era == 11 and bid == "stellar_assembly":
        return f'''  <ellipse cx="64" cy="{by-8}" rx="48" ry="8" fill="{e['dark']}"/>
  <polygon points="40,{by-8} 88,{by-8} 96,{by-40} 32,{by-40}" fill="{e['base']}"/>
  <polygon points="48,{by-40} 80,{by-40} 84,{by-56} 44,{by-56}" fill="{e['accent']}"/>
  <polygon points="56,{by-56} 72,{by-56} 64,{by-68}" fill="{e['light']}"/>
  <circle cx="64" cy="{by-48}" r="4" fill="{e['accent']}"/>
  <line x1="40" y1="{by-24}" x2="88" y2="{by-24}" stroke="{e['dark']}" stroke-width="1" opacity="0.4"/>'''
    if era == 11 and bid == "trade_hub":
        return f'''  <ellipse cx="64" cy="{by-8}" rx="48" ry="8" fill="{e['dark']}"/>
  <rect x="48" y="{by-40}" width="32" height="32" fill="{e['base']}"/>
  <rect x="52" y="{by-36}" width="24" height="28" fill="{e['accent']}" opacity="0.3"/>
  <polygon points="48,{by-40} 80,{by-40} 72,{by-52} 56,{by-52}" fill="{e['accent']}"/>
  <circle cx="58" cy="{by-28}" r="3" fill="{e['accent']}"/>
  <circle cx="70" cy="{by-28}" r="3" fill="{e['accent']}"/>
  <line x1="32" y1="{by-24}" x2="48" y2="{by-24}" stroke="{e['base']}" stroke-width="2"/>
  <line x1="80" y1="{by-24}" x2="96" y2="{by-24}" stroke="{e['base']}" stroke-width="2"/>'''
    if era == 12 and bid == "galactic_defense":
        return f'''  <circle cx="64" cy="{by-40}" r="40" fill="none" stroke="{e['accent']}" stroke-width="1" opacity="0.3"/>
  <circle cx="64" cy="{by-40}" r="28" fill="none" stroke="{e['accent']}" stroke-width="1" opacity="0.5"/>
  <circle cx="64" cy="{by-40}" r="16" fill="{e['dark']}"/>
  <circle cx="64" cy="{by-40}" r="8" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-40}" r="3" fill="#fff"/>
  <line x1="64" y1="{by-80}" x2="64" y2="0" stroke="{e['accent']}" stroke-width="0.5" opacity="0.4"/>
  <line x1="24" y1="{by-40}" x2="104" y2="{by-40}" stroke="{e['accent']}" stroke-width="0.5" opacity="0.4"/>'''
    if era == 12 and bid == "galactic_council":
        return f'''  <ellipse cx="64" cy="{by-8}" rx="52" ry="8" fill="{e['dark']}"/>
  <ellipse cx="64" cy="{by-32}" rx="40" ry="32" fill="none" stroke="{e['accent']}" stroke-width="1.5" opacity="0.5"/>
  <ellipse cx="64" cy="{by-32}" rx="28" ry="24" fill="{e['base']}" opacity="0.3"/>
  <ellipse cx="64" cy="{by-32}" rx="16" ry="16" fill="{e['accent']}" opacity="0.2"/>
  <circle cx="64" cy="{by-32}" r="6" fill="{e['accent']}"/>
  <circle cx="64" cy="{by-32}" r="2" fill="#fff"/>'''
    if era == 12 and bid == "wormhole_gen":
        return f'''  <ellipse cx="64" cy="{by-8}" rx="40" ry="8" fill="{e['dark']}"/>
  <ellipse cx="64" cy="{by-36}" rx="32" ry="32" fill="none" stroke="{e['accent']}" stroke-width="2" opacity="0.5"/>
  <ellipse cx="64" cy="{by-36}" rx="24" ry="24" fill="{e['base']}" opacity="0.2"/>
  <ellipse cx="64" cy="{by-36}" rx="16" ry="16" fill="{e['accent']}" opacity="0.3"/>
  <ellipse cx="64" cy="{by-36}" rx="8" ry="8" fill="{e['accent']}" opacity="0.6"/>
  <circle cx="64" cy="{by-36}" r="3" fill="#fff"/>'''

    # Buildings 4-10 for eras 4-12: parametric art
    return _gen_param(era, e, by, bid, cat)

def _gen_param(era, e, by, bid, cat):
    """Parametric building generator for the 7 new buildings per era 4-12.
    Uses category + era palette to create unique-looking structures."""
    rng = random.Random(hash((era, bid)))
    h_base = rng.randint(24, 48)
    w_base = rng.randint(48, 72)
    x_base = 64 - w_base // 2
    roof_h = rng.randint(8, 20)
    parts = ""
    # Base structure
    parts += f'  <rect x="{x_base}" y="{by-h_base}" width="{w_base}" height="{h_base}" fill="{e["base"]}"/>\n'
    # Roof varies by category
    if cat in ("defense", "military"):
        # Battlements
        for bx in range(x_base, x_base + w_base, 8):
            parts += f'  <rect x="{bx}" y="{by-h_base-4}" width="4" height="4" fill="{e["dark"]}"/>\n'
        parts += f'  <rect x="{x_base}" y="{by-h_base}" width="{w_base}" height="4" fill="{e["dark"]}"/>\n'
    elif cat in ("religious", "cultural"):
        # Triangular roof
        parts += f'  <polygon points="{x_base},{by-h_base} {x_base+w_base},{by-h_base} {64},{by-h_base-roof_h}" fill="{e["accent"]}"/>\n'
    elif cat in ("economic", "infrastructure"):
        # Flat roof with detail
        parts += f'  <rect x="{x_base-2}" y="{by-h_base-4}" width="{w_base+4}" height="6" fill="{e["dark"]}"/>\n'
        parts += f'  <rect x="{x_base-2}" y="{by-h_base-4}" width="{w_base+4}" height="2" fill="{e["accent"]}" opacity="0.5"/>\n'
    elif cat == "housing":
        # Sloped roof
        parts += f'  <polygon points="{x_base-4},{by-h_base} {x_base+w_base+4},{by-h_base} {x_base+w_base},{by-h_base-roof_h} {x_base},{by-h_base-roof_h}" fill="{e["dark"]}"/>\n'
    else:
        parts += f'  <rect x="{x_base}" y="{by-h_base-4}" width="{w_base}" height="6" fill="{e["dark"]}"/>\n'
    # Windows/doors
    num_win = rng.randint(2, 4)
    for _ in range(num_win):
        wx = rng.randint(x_base + 4, x_base + w_base - 10)
        wy = rng.randint(by - h_base + 6, by - 8)
        parts += f'  <rect x="{wx}" y="{wy}" width="6" height="6" fill="{e["light"]}" opacity="0.4"/>\n'
    # Door
    dx = 64 - 6
    parts += f'  <rect x="{dx}" y="{by-14}" width="12" height="14" fill="{e["dark"]}" opacity="0.6"/>\n'
    # Category-specific details
    if cat == "military":
        parts += f'  <circle cx="{x_base+w_base-8}" cy="{by-h_base-8}" r="3" fill="{e["accent"]}"/>\n'
    elif cat == "religious":
        parts += f'  <circle cx="64" cy="{by-h_base-roof_h//2}" r="3" fill="{e["light"]}" opacity="0.7"/>\n'
    elif cat == "economic":
        parts += f'  <rect x="{x_base+4}" y="{by-h_base+4}" width="{w_base-8}" height="2" fill="{e["accent"]}" opacity="0.4"/>\n'
    elif cat == "cultural":
        parts += f'  <polygon points="60,{by-h_base-roof_h-2} 68,{by-h_base-roof_h-2} 64,{by-h_base-roof_h-8}" fill="{e["accent"]}"/>\n'
    elif cat == "infrastructure":
        # Chimney/antenna
        parts += f'  <rect x="{x_base+w_base-12}" y="{by-h_base-12}" width="4" height="12" fill="{e["dark"]}"/>\n'
        if era >= 7:
            parts += f'  <circle cx="{x_base+w_base-10}" cy="{by-h_base-14}" r="2" fill="{e["accent"]}"/>\n'
    # Era-specific accents
    if era <= 3:
        parts += f'  <line x1="{x_base}" y1="{by-4}" x2="{x_base+w_base}" y2="{by-4}" stroke="{e["dark"]}" stroke-width="0.5" opacity="0.3"/>\n'
    elif era >= 8:
        parts += f'  <line x1="{x_base}" y1="{by-h_base+8}" x2="{x_base+w_base}" y2="{by-h_base+8}" stroke="{e["accent"]}" stroke-width="0.5" opacity="0.3"/>\n'
    return parts

def generate_all():
    count = 0
    for era_num in range(1, 13):
        era_name = ERAS[era_num]["name"]
        for b_id, b_name, b_cat in BUILDINGS[era_num]:
            save_svg(f"{OUTPUT}/buildings/{era_name}/{b_id}.svg",
                     gen_building(era_num, b_id, b_name, b_cat))
            count += 1
    return count
