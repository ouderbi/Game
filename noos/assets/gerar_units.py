#!/usr/bin/env python3
"""Gera 48 unidades (4 por era × 12 eras)."""
from gerar_common import *

def gen_unit(era_num, u_id, u_name, u_type):
    e = ERAS[era_num]
    w = h = 64
    by = 48
    body = f'  <ellipse cx="32" cy="{by+4}" rx="14" ry="4" fill="#000" opacity="0.3"/>\n'
    body += _gen(era_num, e, by, u_id, u_type)
    return svg_wrap(w, h, body)

def _gen(era, e, by, uid, utype):
    # Era 1
    if era == 1:
        if uid == "stone_age_warrior":
            return f'''  <circle cx="32" cy="{by-28}" r="8" fill="{e['base']}"/>
  <rect x="28" y="{by-20}" width="8" height="20" fill="{e['base']}"/>
  <rect x="24" y="{by-8}" width="4" height="12" fill="{e['dark']}"/>
  <rect x="36" y="{by-8}" width="4" height="12" fill="{e['dark']}"/>
  <line x1="36" y1="{by-16}" x2="52" y2="{by-28}" stroke="{e['dark']}" stroke-width="3"/>
  <circle cx="52" cy="{by-28}" r="4" fill="{e['accent']}"/>'''
        if uid == "stone_age_slinger":
            return f'''  <circle cx="32" cy="{by-28}" r="7" fill="{e['base']}"/>
  <rect x="28" y="{by-22}" width="8" height="18" fill="{e['base']}"/>
  <rect x="24" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>
  <rect x="36" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>
  <ellipse cx="48" cy="{by-24}" rx="6" ry="3" fill="{e['dark']}" opacity="0.6"/>
  <line x1="40" y1="{by-20}" x2="48" y2="{by-24}" stroke="{e['dark']}" stroke-width="1"/>'''
        if uid == "stone_age_scout":
            return f'''  <circle cx="32" cy="{by-30}" r="6" fill="{e['base']}"/>
  <rect x="28" y="{by-24}" width="8" height="18" fill="{e['base']}"/>
  <rect x="24" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>
  <rect x="36" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>
  <line x1="32" y1="{by-24}" x2="48" y2="{by-36}" stroke="{e['accent']}" stroke-width="1"/>
  <circle cx="48" cy="{by-36}" r="2" fill="{e['accent']}"/>'''
        if uid == "stone_age_shaman":
            return f'''  <circle cx="32" cy="{by-30}" r="8" fill="{e['dark']}"/>
  <rect x="28" y="{by-22}" width="8" height="18" fill="{e['base']}"/>
  <circle cx="28" cy="{by-30}" r="2" fill="{e['accent']}"/>
  <circle cx="36" cy="{by-30}" r="2" fill="{e['accent']}"/>
  <line x1="32" y1="{by-22}" x2="32" y2="{by-40}" stroke="{e['accent']}" stroke-width="1"/>
  <circle cx="32" cy="{by-40}" r="3" fill="{e['accent']}"/>'''
    # Era 2
    if era == 2:
        if uid == "antiquity_hoplite":
            return f'''  <circle cx="32" cy="{by-30}" r="7" fill="{e['base']}"/>
  <rect x="28" y="{by-22}" width="8" height="18" fill="{e['base']}"/>
  <circle cx="32" cy="{by-30}" r="9" fill="none" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="20" y1="{by-40}" x2="20" y2="{by-4}" stroke="{e['dark']}" stroke-width="2"/>
  <line x1="20" y1="{by-4}" x2="28" y2="{by-4}" stroke="{e['dark']}" stroke-width="2"/>
  <rect x="24" y="{by-10}" width="4" height="10" fill="{e['dark']}"/>
  <rect x="36" y="{by-10}" width="4" height="10" fill="{e['dark']}"/>'''
        if uid == "antiquity_archer":
            return f'''  <circle cx="32" cy="{by-30}" r="6" fill="{e['base']}"/>
  <rect x="28" y="{by-24}" width="8" height="18" fill="{e['base']}"/>
  <path d="M 44,{by-30} Q 52,{by-24} 44,{by-12}" fill="none" stroke="{e['dark']}" stroke-width="2"/>
  <line x1="44" y1="{by-30}" x2="44" y2="{by-12}" stroke="{e['accent']}" stroke-width="1"/>
  <rect x="24" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>
  <rect x="36" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>'''
        if uid == "antiquity_chariot":
            return f'''  <rect x="20" y="{by-16}" width="24" height="12" fill="{e['base']}"/>
  <circle cx="24" cy="{by-4}" r="4" fill="{e['dark']}"/>
  <circle cx="40" cy="{by-4}" r="4" fill="{e['dark']}"/>
  <circle cx="32" cy="{by-24}" r="6" fill="{e['base']}"/>
  <line x1="20" y1="{by-16}" x2="12" y2="{by-20}" stroke="{e['dark']}" stroke-width="2"/>
  <line x1="12" y1="{by-20}" x2="8" y2="{by-8}" stroke="{e['dark']}" stroke-width="1"/>'''
        if uid == "antiquity_siege_tower":
            return f'''  <rect x="20" y="{by-40}" width="24" height="40" fill="{e['dark']}"/>
  <rect x="24" y="{by-36}" width="16" height="36" fill="{e['base']}"/>
  <rect x="28" y="{by-32}" width="8" height="8" fill="{e['dark']}" opacity="0.4"/>
  <circle cx="24" cy="{by-4}" r="4" fill="{e['dark']}"/>
  <circle cx="40" cy="{by-4}" r="4" fill="{e['dark']}"/>'''
    # Era 3
    if era == 3:
        if uid == "classical_legionary":
            return f'''  <circle cx="32" cy="{by-30}" r="7" fill="{e['base']}"/>
  <rect x="28" y="{by-22}" width="8" height="18" fill="{e['accent']}"/>
  <rect x="26" y="{by-30}" width="12" height="4" fill="{e['dark']}"/>
  <rect x="24" y="{by-10}" width="4" height="10" fill="{e['dark']}"/>
  <rect x="36" y="{by-10}" width="4" height="10" fill="{e['dark']}"/>
  <line x1="40" y1="{by-24}" x2="52" y2="{by-36}" stroke="{e['dark']}" stroke-width="2"/>
  <polygon points="52,{by-36} 56,{by-40} 52,{by-32}" fill="{e['dark']}"/>'''
        if uid == "classical_cavalry":
            return f'''  <ellipse cx="32" cy="{by-8}" rx="16" ry="6" fill="{e['dark']}"/>
  <rect x="20" y="{by-20}" width="24" height="12" fill="{e['base']}"/>
  <circle cx="32" cy="{by-32}" r="7" fill="{e['base']}"/>
  <rect x="26" y="{by-38}" width="12" height="8" fill="{e['accent']}"/>
  <line x1="40" y1="{by-24}" x2="52" y2="{by-36}" stroke="{e['dark']}" stroke-width="2"/>'''
        if uid == "classical_trireme":
            return f'''  <polygon points="8,{by-8} 56,{by-8} 48,{by} 16,{by}" fill="{e['dark']}"/>
  <rect x="20" y="{by-20}" width="24" height="12" fill="{e['base']}"/>
  <line x1="32" y1="{by-20}" x2="32" y2="{by-40}" stroke="{e['dark']}" stroke-width="2"/>
  <polygon points="32,{by-40} 48,{by-32} 32,{by-32}" fill="{e['accent']}" opacity="0.6"/>
  <line x1="16" y1="{by-12}" x2="8" y2="{by-16}" stroke="{e['dark']}" stroke-width="2"/>'''
        if uid == "classical_ballista":
            return f'''  <rect x="16" y="{by-16}" width="32" height="12" fill="{e['dark']}"/>
  <circle cx="20" cy="{by-4}" r="4" fill="{e['dark']}"/>
  <circle cx="44" cy="{by-4}" r="4" fill="{e['dark']}"/>
  <line x1="16" y1="{by-16}" x2="48" y2="{by-28}" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="48" y1="{by-16}" x2="16" y2="{by-28}" stroke="{e['accent']}" stroke-width="2"/>'''
    # Era 4
    if era == 4:
        if uid == "medieval_knight":
            return f'''  <ellipse cx="32" cy="{by-8}" rx="16" ry="6" fill="{e['dark']}"/>
  <rect x="20" y="{by-20}" width="24" height="12" fill="{e['base']}"/>
  <circle cx="32" cy="{by-32}" r="7" fill="{e['base']}"/>
  <rect x="26" y="{by-38}" width="12" height="8" fill="{e['accent']}"/>
  <polygon points="26,{by-38} 38,{by-38} 32,{by-46}" fill="{e['accent']}"/>
  <line x1="40" y1="{by-24}" x2="52" y2="{by-40}" stroke="{e['dark']}" stroke-width="2"/>
  <line x1="20" y1="{by-4}" x2="20" y2="{by+4}" stroke="{e['dark']}" stroke-width="2"/>
  <line x1="44" y1="{by-4}" x2="44" y2="{by+4}" stroke="{e['dark']}" stroke-width="2"/>'''
        if uid == "medieval_archer":
            return f'''  <circle cx="32" cy="{by-30}" r="6" fill="{e['base']}"/>
  <rect x="28" y="{by-24}" width="8" height="18" fill="{e['base']}"/>
  <path d="M 44,{by-30} Q 54,{by-22} 44,{by-8}" fill="none" stroke="{e['dark']}" stroke-width="2"/>
  <line x1="44" y1="{by-30}" x2="44" y2="{by-8}" stroke="{e['accent']}" stroke-width="1"/>
  <rect x="24" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>
  <rect x="36" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>'''
        if uid == "medieval_galley":
            return f'''  <polygon points="8,{by-8} 56,{by-8} 48,{by} 16,{by}" fill="{e['dark']}"/>
  <rect x="16" y="{by-24}" width="32" height="16" fill="{e['base']}"/>
  <line x1="32" y1="{by-24}" x2="32" y2="{by-44}" stroke="{e['dark']}" stroke-width="2"/>
  <polygon points="20,{by-40} 44,{by-40} 32,{by-44}" fill="{e['accent']}"/>
  <polygon points="20,{by-40} 44,{by-40} 32,{by-24}" fill="{e['accent']}" opacity="0.4"/>'''
        if uid == "medieval_catapult":
            return f'''  <rect x="16" y="{by-12}" width="32" height="8" fill="{e['dark']}"/>
  <circle cx="20" cy="{by-4}" r="4" fill="{e['dark']}"/>
  <circle cx="44" cy="{by-4}" r="4" fill="{e['dark']}"/>
  <line x1="20" y1="{by-12}" x2="48" y2="{by-36}" stroke="{e['dark']}" stroke-width="3"/>
  <circle cx="48" cy="{by-36}" r="4" fill="{e['accent']}"/>'''
    # For eras 5-12, use the original art for unit 1 and parametric for the rest
    if uid == "industrial_rifleman":
        return f'''  <circle cx="32" cy="{by-28}" r="6" fill="{e['base']}"/>
  <rect x="28" y="{by-22}" width="8" height="18" fill="{e['dark']}"/>
  <rect x="26" y="{by-22}" width="12" height="4" fill="{e['accent']}"/>
  <rect x="24" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>
  <rect x="36" y="{by-8}" width="4" height="10" fill="{e['dark']}"/>
  <line x1="36" y1="{by-16}" x2="52" y2="{by-20}" stroke="{e['dark']}" stroke-width="2"/>
  <rect x="48" y="{by-22}" width="6" height="4" fill="{e['dark']}"/>'''
    if uid == "modern_infantry":
        return f'''  <rect x="16" y="{by-24}" width="32" height="20" fill="{e['dark']}"/>
  <rect x="20" y="{by-20}" width="24" height="12" fill="{e['base']}"/>
  <rect x="24" y="{by-16}" width="16" height="8" fill="{e['accent']}" opacity="0.5"/>
  <circle cx="24" cy="{by-4}" r="4" fill="{e['dark']}"/>
  <circle cx="40" cy="{by-4}" r="4" fill="{e['dark']}"/>
  <line x1="48" y1="{by-18}" x2="56" y2="{by-24}" stroke="{e['dark']}" stroke-width="2"/>'''
    if uid == "information_drone":
        return f'''  <ellipse cx="32" cy="{by-20}" rx="20" ry="6" fill="{e['dark']}"/>
  <circle cx="20" cy="{by-20}" r="8" fill="{e['base']}"/>
  <circle cx="44" cy="{by-20}" r="8" fill="{e['base']}"/>
  <rect x="28" y="{by-24}" width="8" height="8" fill="{e['accent']}"/>
  <circle cx="32" cy="{by-20}" r="3" fill="{e['accent']}"/>'''
    if uid == "high_tech_power_armor":
        return f'''  <circle cx="32" cy="{by-30}" r="8" fill="{e['dark']}"/>
  <rect x="24" y="{by-22}" width="16" height="18" fill="{e['base']}"/>
  <rect x="20" y="{by-20}" width="4" height="12" fill="{e['base']}"/>
  <rect x="40" y="{by-20}" width="4" height="12" fill="{e['base']}"/>
  <rect x="26" y="{by-30}" width="12" height="4" fill="{e['accent']}"/>
  <circle cx="32" cy="{by-28}" r="2" fill="{e['accent']}"/>
  <rect x="24" y="{by-8}" width="6" height="10" fill="{e['dark']}"/>
  <rect x="34" y="{by-8}" width="6" height="10" fill="{e['dark']}"/>'''
    if uid == "space_marine":
        return f'''  <circle cx="32" cy="{by-30}" r="8" fill="{e['dark']}"/>
  <rect x="26" y="{by-22}" width="12" height="18" fill="{e['base']}"/>
  <rect x="22" y="{by-20}" width="4" height="12" fill="{e['accent']}"/>
  <rect x="38" y="{by-20}" width="4" height="12" fill="{e['accent']}"/>
  <rect x="28" y="{by-30}" width="8" height="3" fill="{e['accent']}"/>
  <rect x="24" y="{by-8}" width="6" height="10" fill="{e['dark']}"/>
  <rect x="34" y="{by-8}" width="6" height="10" fill="{e['dark']}"/>'''
    if uid == "interplanetary_mech":
        return f'''  <rect x="24" y="{by-36}" width="16" height="12" fill="{e['dark']}"/>
  <rect x="20" y="{by-24}" width="24" height="20" fill="{e['base']}"/>
  <rect x="16" y="{by-22}" width="6" height="14" fill="{e['accent']}"/>
  <rect x="42" y="{by-22}" width="6" height="14" fill="{e['accent']}"/>
  <circle cx="32" cy="{by-30}" r="3" fill="{e['accent']}"/>
  <rect x="22" y="{by-8}" width="8" height="10" fill="{e['dark']}"/>
  <rect x="34" y="{by-8}" width="8" height="10" fill="{e['dark']}"/>
  <line x1="44" y1="{by-20}" x2="56" y2="{by-28}" stroke="{e['dark']}" stroke-width="3"/>'''
    if uid == "stellar_starship":
        return f'''  <polygon points="32,{by-40} 44,{by-12} 32,{by-4} 20,{by-12}" fill="{e['base']}"/>
  <polygon points="32,{by-36} 40,{by-14} 32,{by-8} 24,{by-14}" fill="{e['accent']}" opacity="0.4"/>
  <circle cx="32" cy="{by-20}" r="4" fill="{e['accent']}"/>
  <line x1="20" y1="{by-12}" x2="12" y2="{by-4}" stroke="{e['base']}" stroke-width="2"/>
  <line x1="44" y1="{by-12}" x2="52" y2="{by-4}" stroke="{e['base']}" stroke-width="2"/>
  <polygon points="28,{by-4} 36,{by-4} 32,{by}" fill="{e['accent']}" opacity="0.6"/>'''
    if uid == "intergalactic_dreadnought":
        return f'''  <polygon points="16,{by-20} 48,{by-20} 56,{by-12} 48,{by-4} 16,{by-4} 8,{by-12}" fill="{e['dark']}"/>
  <polygon points="20,{by-18} 46,{by-18} 52,{by-12} 46,{by-6} 20,{by-6} 14,{by-12}" fill="{e['base']}"/>
  <rect x="28" y="{by-28}" width="8" height="10" fill="{e['accent']}"/>
  <circle cx="32" cy="{by-12}" r="4" fill="{e['accent']}"/>
  <line x1="48" y1="{by-16}" x2="60" y2="{by-16}" stroke="{e['accent']}" stroke-width="2"/>
  <line x1="16" y1="{by-16}" x2="4" y2="{by-16}" stroke="{e['accent']}" stroke-width="2"/>'''
    # Parametric for remaining units
    return _gen_param_unit(era, e, by, uid, utype)

def _gen_param_unit(era, e, by, uid, utype):
    rng = random.Random(hash((era, uid)))
    parts = ""
    if utype == "land":
        # Humanoid figure
        parts += f'  <circle cx="32" cy="{by-28}" r="7" fill="{e["base"]}"/>\n'
        parts += f'  <rect x="28" y="{by-22}" width="8" height="18" fill="{e["base"]}"/>\n'
        parts += f'  <rect x="24" y="{by-8}" width="4" height="10" fill="{e["dark"]}"/>\n'
        parts += f'  <rect x="36" y="{by-8}" width="4" height="10" fill="{e["dark"]}"/>\n'
        # Weapon varies
        if rng.choice([True, False]):
            parts += f'  <line x1="36" y1="{by-16}" x2="52" y2="{by-24}" stroke="{e["dark"]}" stroke-width="2"/>\n'
        else:
            parts += f'  <rect x="38" y="{by-20}" width="12" height="3" fill="{e["dark"]}"/>\n'
        # Era accent
        if era >= 7:
            parts += f'  <circle cx="32" cy="{by-28}" r="2" fill="{e["accent"]}"/>\n'
    elif utype == "naval":
        # Ship/boat
        parts += f'  <polygon points="8,{by-8} 56,{by-8} 48,{by} 16,{by}" fill="{e["dark"]}"/>\n'
        parts += f'  <rect x="16" y="{by-20}" width="32" height="12" fill="{e["base"]}"/>\n'
        if era <= 4:
            parts += f'  <line x1="32" y1="{by-20}" x2="32" y2="{by-40}" stroke="{e["dark"]}" stroke-width="2"/>\n'
            parts += f'  <polygon points="20,{by-36} 44,{by-36} 32,{by-40}" fill="{e["accent"]}"/>\n'
        else:
            parts += f'  <rect x="24" y="{by-28}" width="16" height="8" fill="{e["accent"]}" opacity="0.5"/>\n'
            parts += f'  <line x1="32" y1="{by-28}" x2="32" y2="{by-36}" stroke="{e["accent"]}" stroke-width="2"/>\n'
    elif utype == "air":
        # Aircraft/drone
        parts += f'  <polygon points="32,{by-36} 48,{by-12} 32,{by-4} 16,{by-12}" fill="{e["base"]}"/>\n'
        parts += f'  <polygon points="32,{by-32} 44,{by-14} 32,{by-8} 20,{by-14}" fill="{e["accent"]}" opacity="0.4"/>\n'
        parts += f'  <circle cx="32" cy="{by-20}" r="3" fill="{e["accent"]}"/>\n'
        if era >= 8:
            parts += f'  <line x1="16" y1="{by-12}" x2="8" y2="{by-8}" stroke="{e["base"]}" stroke-width="2"/>\n'
            parts += f'  <line x1="48" y1="{by-12}" x2="56" y2="{by-8}" stroke="{e["base"]}" stroke-width="2"/>\n'
    else:  # special
        parts += f'  <circle cx="32" cy="{by-24}" r="10" fill="{e["dark"]}"/>\n'
        parts += f'  <circle cx="32" cy="{by-24}" r="6" fill="{e["accent"]}" opacity="0.5"/>\n'
        parts += f'  <circle cx="32" cy="{by-24}" r="2" fill="{e["accent"]}"/>\n'
        parts += f'  <rect x="28" y="{by-14}" width="8" height="14" fill="{e["base"]}"/>\n'
        parts += f'  <rect x="24" y="{by-4}" width="4" height="6" fill="{e["dark"]}"/>\n'
        parts += f'  <rect x="36" y="{by-4}" width="4" height="6" fill="{e["dark"]}"/>\n'
    return parts

def generate_all():
    count = 0
    for era_num in range(1, 13):
        for u_id, u_name, u_type in UNITS[era_num]:
            save_svg(f"{OUTPUT}/units/{u_id}.svg", gen_unit(era_num, u_id, u_name, u_type))
            count += 1
    return count
