#!/usr/bin/env python3
"""Gera 60 retratos de líderes (5 por era × 12 eras)."""
from gerar_common import *

# Cores de pele variadas
SKIN_TONES = ["#E8C4A0", "#D4A76A", "#C4956A", "#A87A4A", "#8B6B3A", "#F0D0B0"]
HAIR_COLORS = ["#2A1A0A", "#4A3520", "#6B5030", "#8B7040", "#A08050", "#C0A060", "#404040", "#808080"]
EYE_COLORS = ["#4A6B8A", "#2A4B6A", "#6A4B2A", "#4A6B4A", "#2A2A2A", "#5A3A2A"]

def gen_leader(era_num, l_id, l_name, archetype):
    e = ERAS[era_num]
    w = h = 96
    cx, cy = 48, 48
    rng = random.Random(hash((era_num, l_id)))
    skin = rng.choice(SKIN_TONES)
    hair = rng.choice(HAIR_COLORS)
    eye = rng.choice(EYE_COLORS)

    body = f'''  <rect x="4" y="4" width="88" height="88" rx="4" fill="{e['dark']}" opacity="0.9"/>
  <rect x="8" y="8" width="80" height="80" rx="2" fill="{shade(skin, 0.85)}" opacity="0.95"/>'''

    # Background pattern by era
    if era_num <= 3:
        body += f'\n  <line x1="8" y1="72" x2="88" y2="72" stroke="{e["accent"]}" stroke-width="1" opacity="0.3"/>'
    elif era_num <= 6:
        body += f'\n  <rect x="8" y="72" width="80" height="16" fill="{e["accent"]}" opacity="0.15"/>'
    else:
        body += f'\n  <circle cx="48" cy="48" r="36" fill="none" stroke="{e["accent"]}" stroke-width="0.5" opacity="0.2"/>'

    # Face shape
    face_w = rng.randint(28, 36)
    face_h = rng.randint(32, 40)
    fx = cx - face_w // 2
    fy = cy - face_h // 2 - 4
    body += f'\n  <ellipse cx="{cx}" cy="{cy-4}" rx="{face_w//2}" ry="{face_h//2}" fill="{skin}"/>'

    # Hair
    if archetype in ("agressor", "autocrata"):
        # Short/cropped hair
        body += f'\n  <path d="M {fx},{cy-4} Q {cx},{fy-6} {fx+face_w},{cy-4} L {fx+face_w},{fy+4} L {fx},{fy+4} Z" fill="{hair}"/>'
    elif archetype in ("mistico", "sabio"):
        # Longer hair / hood
        body += f'\n  <path d="M {fx-2},{cy+4} Q {cx},{fy-10} {fx+face_w+2},{cy+4} L {fx+face_w+2},{fy+2} L {fx-2},{fy+2} Z" fill="{hair}"/>'
        if archetype == "mistico":
            body += f'\n  <path d="M {fx-4},{cy+8} Q {cx},{fy-12} {fx+face_w+4},{cy+8} L {fx+face_w+4},{fy} L {fx-4},{fy} Z" fill="{e["dark"]}" opacity="0.6"/>'
    elif archetype == "diplomata":
        # Styled hair
        body += f'\n  <path d="M {fx},{cy-2} Q {cx},{fy-8} {fx+face_w},{cy-2} L {fx+face_w},{fy+6} Q {cx},{fy+2} {fx},{fy+6} Z" fill="{hair}"/>'
    else:
        # Standard
        body += f'\n  <path d="M {fx+2},{cy-2} Q {cx},{fy-4} {fx+face_w-2},{cy-2} L {fx+face_w-2},{fy+6} L {fx+2},{fy+6} Z" fill="{hair}"/>'

    # Eyes
    eye_y = cy - 6
    eye_dx = 6
    body += f'\n  <circle cx="{cx-eye_dx}" cy="{eye_y}" r="2.5" fill="#fff"/>'
    body += f'\n  <circle cx="{cx+eye_dx}" cy="{eye_y}" r="2.5" fill="#fff"/>'
    body += f'\n  <circle cx="{cx-eye_dx}" cy="{eye_y}" r="1.5" fill="{eye}"/>'
    body += f'\n  <circle cx="{cx+eye_dx}" cy="{eye_y}" r="1.5" fill="{eye}"/>'

    # Eyebrows vary by archetype
    if archetype == "agressor":
        body += f'\n  <line x1="{cx-eye_dx-3}" y1="{eye_y-5}" x2="{cx-eye_dx+3}" y2="{eye_y-3}" stroke="{hair}" stroke-width="1.5"/>'
        body += f'\n  <line x1="{cx+eye_dx-3}" y1="{eye_y-3}" x2="{cx+eye_dx+3}" y2="{eye_y-5}" stroke="{hair}" stroke-width="1.5"/>'
    else:
        body += f'\n  <line x1="{cx-eye_dx-3}" y1="{eye_y-4}" x2="{cx-eye_dx+3}" y2="{eye_y-4}" stroke="{hair}" stroke-width="1"/>'
        body += f'\n  <line x1="{cx+eye_dx-3}" y1="{eye_y-4}" x2="{cx+eye_dx+3}" y2="{eye_y-4}" stroke="{hair}" stroke-width="1"/>'

    # Nose
    body += f'\n  <line x1="{cx}" y1="{eye_y+2}" x2="{cx}" y2="{cy+2}" stroke="{shade(skin, 0.8)}" stroke-width="1"/>'

    # Mouth varies by archetype
    mouth_y = cy + 8
    if archetype in ("agressor", "autocrata"):
        body += f'\n  <line x1="{cx-6}" y1="{mouth_y}" x2="{cx+6}" y2="{mouth_y}" stroke="{shade(skin, 0.6)}" stroke-width="2"/>'
    elif archetype == "diplomata":
        body += f'\n  <path d="M {cx-6},{mouth_y} Q {cx},{mouth_y+3} {cx+6},{mouth_y}" fill="none" stroke="{shade(skin, 0.6)}" stroke-width="1.5"/>'
    else:
        body += f'\n  <line x1="{cx-4}" y1="{mouth_y}" x2="{cx+4}" y2="{mouth_y}" stroke="{shade(skin, 0.6)}" stroke-width="1"/>'

    # Era-specific accessories
    if era_num <= 2:
        # Primitive/ancient: bone/bronze jewelry
        if rng.choice([True, False]):
            body += f'\n  <circle cx="{cx-eye_dx-4}" cy="{eye_y+1}" r="1.5" fill="{e["accent"]}"/>'
            body += f'\n  <circle cx="{cx+eye_dx+4}" cy="{eye_y+1}" r="1.5" fill="{e["accent"]}"/>'
    elif era_num == 3:
        # Classical: laurel wreath
        body += f'\n  <path d="M {fx+4},{fy+4} Q {cx},{fy-2} {fx+face_w-4},{fy+4}" fill="none" stroke="{e["accent"]}" stroke-width="1.5"/>'
        body += f'\n  <circle cx="{fx+8}" cy="{fy+3}" r="2" fill="{e["accent"]}" opacity="0.6"/>'
        body += f'\n  <circle cx="{fx+face_w-8}" cy="{fy+3}" r="2" fill="{e["accent"]}" opacity="0.6"/>'
    elif era_num == 4:
        # Medieval: crown
        body += f'\n  <polygon points="{fx+6},{fy+2} {fx+face_w-6},{fy+2} {fx+face_w-10},{fy-6} {fx+face_w//2},{fy-2} {fx+10},{fy-6}" fill="{e["accent"]}"/>'
        body += f'\n  <circle cx="{fx+face_w//2}" cy="{fy-2}" r="2" fill="{e["light"]}" opacity="0.7"/>'
    elif era_num == 5:
        # Industrial: top hat or monocle
        if archetype in ("autocrata", "agressor"):
            body += f'\n  <rect x="{fx+6}" y="{fy-8}" width="{face_w-12}" height="8" fill="{e["dark"]}"/>'
            body += f'\n  <rect x="{fx+4}" y="{fy}" width="{face_w-8}" height="3" fill="{e["dark"]}"/>'
        else:
            body += f'\n  <circle cx="{cx+eye_dx}" cy="{eye_y}" r="4" fill="none" stroke="{e["accent"]}" stroke-width="1"/>'
    elif era_num == 6:
        # Modern: suit collar
        body += f'\n  <polygon points="{fx+8},{cy+face_h//2} {cx},{cy+face_h//2-4} {fx+face_w-8},{cy+face_h//2}" fill="{e["dark"]}"/>'
        body += f'\n  <polygon points="{cx-4},{cy+face_h//2} {cx+4},{cy+face_h//2} {cx},{cy+face_h//2+8}" fill="{e["light"]}" opacity="0.5"/>'
    elif era_num == 7:
        # Information: glasses
        body += f'\n  <circle cx="{cx-eye_dx}" cy="{eye_y}" r="4" fill="none" stroke="{e["accent"]}" stroke-width="1"/>'
        body += f'\n  <circle cx="{cx+eye_dx}" cy="{eye_y}" r="4" fill="none" stroke="{e["accent"]}" stroke-width="1"/>'
        body += f'\n  <line x1="{cx-2}" y1="{eye_y}" x2="{cx+2}" y2="{eye_y}" stroke="{e["accent"]}" stroke-width="1"/>'
    elif era_num == 8:
        # High tech: cybernetic implant
        body += f'\n  <line x1="{cx+eye_dx-4}" y1="{eye_y-4}" x2="{cx+eye_dx+4}" y2="{eye_y+4}" stroke="{e["accent"]}" stroke-width="1" opacity="0.7"/>'
        body += f'\n  <circle cx="{cx+eye_dx}" cy="{eye_y}" r="3" fill="none" stroke="{e["accent"]}" stroke-width="0.5"/>'
    elif era_num == 9:
        # Space: visor
        body += f'\n  <rect x="{fx+4}" y="{eye_y-4}" width="{face_w-8}" height="8" fill="{e["dark"]}" opacity="0.6" rx="2"/>'
        body += f'\n  <line x1="{fx+6}" y1="{eye_y}" x2="{fx+face_w-6}" y2="{eye_y}" stroke="{e["accent"]}" stroke-width="1" opacity="0.5"/>'
    elif era_num == 10:
        # Interplanetary: exosuit collar
        body += f'\n  <rect x="{fx-2}" y="{cy+face_h//2-4}" width="{face_w+4}" height="8" fill="{e["accent"]}" opacity="0.3" rx="2"/>'
        body += f'\n  <line x1="{cx}" y1="{cy+face_h//2-4}" x2="{cx}" y2="{cy+face_h//2+4}" stroke="{e["accent"]}" stroke-width="1"/>'
    elif era_num == 11:
        # Stellar: glowing eyes
        body += f'\n  <circle cx="{cx-eye_dx}" cy="{eye_y}" r="3" fill="{e["accent"]}" opacity="0.5"/>'
        body += f'\n  <circle cx="{cx+eye_dx}" cy="{eye_y}" r="3" fill="{e["accent"]}" opacity="0.5"/>'
    elif era_num == 12:
        # Intergalactic: transcendent glow
        body += f'\n  <circle cx="{cx}" cy="{cy-4}" r="{face_w//2+4}" fill="none" stroke="{e["accent"]}" stroke-width="1" opacity="0.3"/>'
        body += f'\n  <circle cx="{cx}" cy="{cy-4}" r="{face_w//2+8}" fill="none" stroke="{e["accent"]}" stroke-width="0.5" opacity="0.2"/>'

    # Frame
    body += f'\n  <rect x="4" y="4" width="88" height="88" rx="4" fill="none" stroke="{e["accent"]}" stroke-width="2"/>'
    body += f'\n  <polygon points="4,4 20,4 4,20" fill="{e["accent"]}"/>'
    body += f'\n  <polygon points="92,92 76,92 92,76" fill="{e["accent"]}"/>'

    return svg_wrap(w, h, body)

def generate_all():
    count = 0
    for era_num in range(1, 13):
        for l_id, l_name, archetype in LEADERS[era_num]:
            save_svg(f"{OUTPUT}/leaders/{l_id}.svg", gen_leader(era_num, l_id, l_name, archetype))
            count += 1
    return count
