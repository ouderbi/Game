#!/usr/bin/env python3
"""Gera tecnologias (48), governos (48), recursos (24), bandeiras (24) = 144 arquivos."""
from gerar_common import *

# ── Tecnologias (48: 4 por era × 12) ──────────────────────────────────
def gen_tech(era_num, t_id, t_name, branch):
    e = ERAS[era_num]
    w = h = 64
    cx, cy = 32, 32
    rng = random.Random(hash((era_num, t_id)))
    body = f'  <circle cx="{cx}" cy="{cy}" r="28" fill="{e["dark"]}" opacity="0.8"/>\n'
    body += f'  <circle cx="{cx}" cy="{cy}" r="24" fill="{e["base"]}" opacity="0.3"/>\n'
    body += f'  <circle cx="{cx}" cy="{cy}" r="24" fill="none" stroke="{e["accent"]}" stroke-width="1.5" opacity="0.6"/>\n'

    if branch == "base":
        # Gear/atom icon
        for a in range(0, 360, 60):
            r = math.radians(a)
            x1 = cx + math.cos(r) * 16
            y1 = cy + math.sin(r) * 16
            x2 = cx + math.cos(r) * 22
            y2 = cy + math.sin(r) * 22
            body += f'  <line x1="{x1:.0f}" y1="{y1:.0f}" x2="{x2:.0f}" y2="{y2:.0f}" stroke="{e["accent"]}" stroke-width="2"/>\n'
        body += f'  <circle cx="{cx}" cy="{cy}" r="8" fill="{e["accent"]}" opacity="0.5"/>\n'
    elif branch == "military":
        # Crossed swords / shield
        body += f'  <line x1="{cx-12}" y1="{cy-12}" x2="{cx+12}" y2="{cy+12}" stroke="{e["accent"]}" stroke-width="2.5"/>\n'
        body += f'  <line x1="{cx+12}" y1="{cy-12}" x2="{cx-12}" y2="{cy+12}" stroke="{e["accent"]}" stroke-width="2.5"/>\n'
        body += f'  <circle cx="{cx}" cy="{cy}" r="4" fill="{e["accent"]}"/>\n'
    elif branch == "economy":
        # Coin / factory
        body += f'  <circle cx="{cx}" cy="{cy}" r="12" fill="{e["accent"]}" opacity="0.4"/>\n'
        body += f'  <circle cx="{cx}" cy="{cy}" r="8" fill="{e["accent"]}" opacity="0.6"/>\n'
        body += f'  <text x="{cx}" y="{cy+4}" font-size="10" text-anchor="middle" fill="{e["light"]}">$</text>\n'
    else:  # culture
        # Star / book
        points = ""
        for i in range(5):
            a = math.radians(-90 + i * 72)
            x = cx + math.cos(a) * 14
            y = cy + math.sin(a) * 14
            points += f"{x:.0f},{y:.0f} "
            a2 = math.radians(-90 + i * 72 + 36)
            x2 = cx + math.cos(a2) * 6
            y2 = cy + math.sin(a2) * 6
            points += f"{x2:.0f},{y2:.0f} "
        body += f'  <polygon points="{points}" fill="{e["accent"]}" opacity="0.6"/>\n'

    body += f'  <circle cx="{cx}" cy="{cy}" r="28" fill="none" stroke="{e["accent"]}" stroke-width="1" opacity="0.3"/>\n'
    return svg_wrap(w, h, body)

# ── Governos (48: 4 por era × 12) ─────────────────────────────────────
def gen_gov(era_num, g_id, g_name):
    e = ERAS[era_num]
    w = h = 64
    cx, cy = 32, 32
    body = f'  <rect x="4" y="4" width="56" height="56" rx="4" fill="{e["dark"]}" opacity="0.8"/>\n'
    body += f'  <rect x="6" y="6" width="52" height="52" rx="3" fill="{e["base"]}" opacity="0.2"/>\n'

    # Building icon representing government
    if era_num <= 2:
        # Pyramid/ziggurat
        body += f'  <polygon points="32,14 50,50 14,50" fill="{e["accent"]}" opacity="0.6"/>\n'
        body += f'  <polygon points="32,14 40,30 24,30" fill="{e["light"]}" opacity="0.4"/>\n'
    elif era_num <= 4:
        # Column building
        body += f'  <rect x="16" y="20" width="32" height="28" fill="{e["accent"]}" opacity="0.5"/>\n'
        body += f'  <rect x="14" y="18" width="36" height="4" fill="{e["accent"]}"/>\n'
        body += f'  <rect x="14" y="46" width="36" height="4" fill="{e["accent"]}"/>\n'
        body += f'  <rect x="20" y="24" width="4" height="22" fill="{e["dark"]}" opacity="0.4"/>\n'
        body += f'  <rect x="40" y="24" width="4" height="22" fill="{e["dark"]}" opacity="0.4"/>\n'
    elif era_num <= 6:
        # Capitol/dome
        body += f'  <rect x="14" y="30" width="36" height="20" fill="{e["accent"]}" opacity="0.5"/>\n'
        body += f'  <path d="M 14,30 Q 32,14 50,30" fill="{e["accent"]}" opacity="0.6"/>\n'
        body += f'  <rect x="30" y="18" width="4" height="8" fill="{e["accent"]}"/>\n'
    elif era_num <= 8:
        # Modern tower
        body += f'  <rect x="22" y="16" width="20" height="36" fill="{e["accent"]}" opacity="0.5"/>\n'
        body += f'  <rect x="24" y="18" width="16" height="4" fill="{e["light"]}" opacity="0.4"/>\n'
        body += f'  <rect x="24" y="26" width="16" height="4" fill="{e["light"]}" opacity="0.4"/>\n'
        body += f'  <rect x="24" y="34" width="16" height="4" fill="{e["light"]}" opacity="0.4"/>\n'
    else:
        # Space station / orbital
        body += f'  <circle cx="32" cy="32" r="16" fill="none" stroke="{e["accent"]}" stroke-width="1.5" opacity="0.5"/>\n'
        body += f'  <circle cx="32" cy="32" r="8" fill="{e["accent"]}" opacity="0.3"/>\n'
        body += f'  <circle cx="32" cy="32" r="3" fill="{e["accent"]}"/>\n'

    body += f'  <rect x="4" y="4" width="56" height="56" rx="4" fill="none" stroke="{e["accent"]}" stroke-width="1.5"/>\n'
    return svg_wrap(w, h, body)

# ── Recursos (24: 2 por era × 12) ─────────────────────────────────────
def gen_resource(era_num, r_id, r_name):
    e = ERAS[era_num]
    w = h = 48
    cx, cy = 24, 24
    rng = random.Random(hash((era_num, r_id)))
    body = f'  <circle cx="{cx}" cy="{cy}" r="20" fill="{e["dark"]}" opacity="0.7"/>\n'
    body += f'  <circle cx="{cx}" cy="{cy}" r="16" fill="{e["accent"]}" opacity="0.3"/>\n'

    # Shape varies by era
    if era_num <= 3:
        # Raw material: crystal/gem shape
        body += f'  <polygon points="{cx},{cy-10} {cx+8},{cy} {cx},{cy+10} {cx-8},{cy}" fill="{e["accent"]}" opacity="0.6"/>\n'
        body += f'  <polygon points="{cx},{cy-10} {cx+8},{cy} {cx},{cy-4}" fill="{e["light"]}" opacity="0.4"/>\n'
    elif era_num <= 6:
        # Ingot/bar
        body += f'  <rect x="{cx-10}" y="{cy-6}" width="20" height="12" fill="{e["accent"]}" opacity="0.6" rx="2"/>\n'
        body += f'  <rect x="{cx-8}" y="{cy-4}" width="16" height="8" fill="{e["light"]}" opacity="0.3" rx="1"/>\n'
    elif era_num <= 9:
        # Crystal cluster
        body += f'  <polygon points="{cx},{cy-12} {cx+6},{cy} {cx},{cy+4} {cx-6},{cy}" fill="{e["accent"]}" opacity="0.6"/>\n'
        body += f'  <polygon points="{cx+4},{cy-8} {cx+10},{cy} {cx+4},{cy+4}" fill="{e["light"]}" opacity="0.4"/>\n'
        body += f'  <polygon points="{cx-4},{cy-8} {cx-10},{cy} {cx-4},{cy+4}" fill="{e["light"]}" opacity="0.4"/>\n'
    else:
        # Energy sphere
        body += f'  <circle cx="{cx}" cy="{cy}" r="10" fill="{e["accent"]}" opacity="0.4"/>\n'
        body += f'  <circle cx="{cx}" cy="{cy}" r="6" fill="{e["accent"]}" opacity="0.6"/>\n'
        body += f'  <circle cx="{cx}" cy="{cy}" r="2" fill="#fff" opacity="0.8"/>\n'

    body += f'  <circle cx="{cx}" cy="{cy}" r="20" fill="none" stroke="{e["accent"]}" stroke-width="1" opacity="0.4"/>\n'
    return svg_wrap(w, h, body)

# ── Bandeiras (24: 2 por era × 12) ────────────────────────────────────
def gen_flag(era_num, f_id, f_name):
    e = ERAS[era_num]
    w, h = 64, 80
    rng = random.Random(hash((era_num, f_id)))
    body = f'  <rect x="28" y="8" width="4" height="68" fill="{e["dark"]}"/>\n'

    # Flag shape varies by era
    if era_num <= 3:
        # Rectangular cloth
        body += f'  <rect x="32" y="12" width="28" height="20" fill="{e["base"]}" opacity="0.8"/>\n'
        body += f'  <rect x="32" y="12" width="28" height="20" fill="none" stroke="{e["dark"]}" stroke-width="1"/>\n'
        # Symbol
        body += f'  <circle cx="46" cy="22" r="4" fill="{e["accent"]}"/>\n'
    elif era_num <= 6:
        # Swallow-tail
        body += f'  <polygon points="32,12 60,12 56,22 60,32 32,32" fill="{e["base"]}" opacity="0.8"/>\n'
        body += f'  <polygon points="32,12 60,12 56,22 60,32 32,32" fill="none" stroke="{e["dark"]}" stroke-width="1"/>\n'
        body += f'  <rect x="40" y="18" width="8" height="8" fill="{e["accent"]}"/>\n'
    else:
        # Modern flag
        body += f'  <rect x="32" y="12" width="28" height="20" fill="{e["base"]}" opacity="0.7"/>\n'
        body += f'  <rect x="32" y="12" width="28" height="20" fill="none" stroke="{e["accent"]}" stroke-width="1"/>\n'
        # Star or emblem
        points = ""
        for i in range(5):
            a = math.radians(-90 + i * 72)
            x = 46 + math.cos(a) * 5
            y = 22 + math.sin(a) * 5
            points += f"{x:.0f},{y:.0f} "
            a2 = math.radians(-90 + i * 72 + 36)
            x2 = 46 + math.cos(a2) * 2
            y2 = 22 + math.sin(a2) * 2
            points += f"{x2:.0f},{y2:.0f} "
        body += f'  <polygon points="{points}" fill="{e["accent"]}"/>\n'

    # Pole top
    body += f'  <circle cx="30" cy="8" r="3" fill="{e["accent"]}"/>\n'
    return svg_wrap(w, h, body)

def generate_all():
    count = 0
    for era_num in range(1, 13):
        for t_id, t_name, branch in TECHS[era_num]:
            save_svg(f"{OUTPUT}/techs/{t_id}.svg", gen_tech(era_num, t_id, t_name, branch))
            count += 1
    for era_num in range(1, 13):
        for g_id, g_name in GOVS[era_num]:
            save_svg(f"{OUTPUT}/governments/{g_id}.svg", gen_gov(era_num, g_id, g_name))
            count += 1
    for era_num in range(1, 13):
        for r_id, r_name in RESOURCES[era_num]:
            save_svg(f"{OUTPUT}/resources/{r_id}.svg", gen_resource(era_num, r_id, r_name))
            count += 1
    for era_num in range(1, 13):
        for f_id, f_name in FLAGS[era_num]:
            save_svg(f"{OUTPUT}/flags/{f_id}.svg", gen_flag(era_num, f_id, f_name))
            count += 1
    return count
