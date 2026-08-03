#!/usr/bin/env python3
"""Gera 26 elementos de UI + 30 efeitos = 56 arquivos."""
from gerar_common import *

# ── UI (26) ───────────────────────────────────────────────────────────
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
    if element == "panel_thin":
        w, h = 240, 32
        body = f'''  <rect x="0" y="0" width="{w}" height="{h}" rx="4" fill="#1a1a2e" stroke="#2d2d4e" stroke-width="1"/>
  <rect x="1" y="1" width="{w-2}" height="{h-2}" rx="3" fill="url(#g)"/>'''
        return svg_wrap(w, h, body)
    if element == "panel_wide":
        w, h = 320, 160
        body = f'''  <rect x="0" y="0" width="{w}" height="{h}" rx="8" fill="#1a1a2e" stroke="#2d2d4e" stroke-width="2"/>
  <rect x="2" y="2" width="{w-4}" height="{h-4}" rx="6" fill="none" stroke="#3d3d5e" stroke-width="1" opacity="0.5"/>
  <rect x="0" y="0" width="{w}" height="24" rx="8" fill="#2d2d4e"/>
  <rect x="0" y="16" width="{w}" height="8" fill="#2d2d4e"/>'''
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
    if element == "button_small":
        w, h = 48, 24
        body = f'''  <rect x="0" y="0" width="{w}" height="{h}" rx="3" fill="#2d2d4e" stroke="#4d4d6e" stroke-width="1"/>
  <rect x="1" y="1" width="{w-2}" height="{h-2}" rx="2" fill="url(#g)"/>'''
        return svg_wrap(w, h, body)
    if element == "button_large":
        w, h = 160, 48
        body = f'''  <rect x="0" y="0" width="{w}" height="{h}" rx="6" fill="#2d2d4e" stroke="#4d4d6e" stroke-width="1.5"/>
  <rect x="1" y="1" width="{w-2}" height="{h-2}" rx="5" fill="url(#g)"/>'''
        return svg_wrap(w, h, body)
    if element == "button_icon":
        w, h = 32, 32
        body = f'''  <rect x="0" y="0" width="{w}" height="{h}" rx="4" fill="#2d2d4e" stroke="#4d4d6e" stroke-width="1"/>
  <rect x="1" y="1" width="{w-2}" height="{h-2}" rx="3" fill="url(#g)"/>'''
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
    if element == "icon_food":
        w = h = 32
        body = f'''  <circle cx="16" cy="16" r="14" fill="#6B8E23" stroke="#4A6B13" stroke-width="1.5"/>
  <path d="M 10,12 Q 16,8 22,12 Q 16,20 10,12" fill="#8FAB4F"/>
  <line x1="16" y1="12" x2="16" y2="22" stroke="#4A6B13" stroke-width="1"/>'''
        return svg_wrap(w, h, body)
    if element == "icon_military":
        w = h = 32
        body = f'''  <circle cx="16" cy="16" r="14" fill="#556B2F" stroke="#2F4F2F" stroke-width="1.5"/>
  <line x1="8" y1="8" x2="24" y2="24" stroke="#D4AF37" stroke-width="2.5"/>
  <line x1="24" y1="8" x2="8" y2="24" stroke="#D4AF37" stroke-width="2.5"/>
  <circle cx="16" cy="16" r="3" fill="#D4AF37"/>'''
        return svg_wrap(w, h, body)
    if element == "icon_science":
        w = h = 32
        body = f'''  <circle cx="16" cy="16" r="14" fill="#4682B4" stroke="#2F5F8F" stroke-width="1.5"/>
  <circle cx="16" cy="16" r="4" fill="#B0C4DE"/>
  <ellipse cx="16" cy="16" rx="12" ry="5" fill="none" stroke="#B0C4DE" stroke-width="1" transform="rotate(30 16 16)"/>
  <ellipse cx="16" cy="16" rx="12" ry="5" fill="none" stroke="#B0C4DE" stroke-width="1" transform="rotate(-30 16 16)"/>'''
        return svg_wrap(w, h, body)
    if element == "icon_culture":
        w = h = 32
        body = f'''  <circle cx="16" cy="16" r="14" fill="#8B4513" stroke="#5A2A03" stroke-width="1.5"/>
  <polygon points="16,6 20,14 28,14 22,20 24,28 16,24 8,28 10,20 4,14 12,14" fill="#D4AF37"/>'''
        return svg_wrap(w, h, body)
    if element == "icon_corruption":
        w = h = 32
        body = f'''  <circle cx="16" cy="16" r="14" fill="#2F2F2F" stroke="#1A1A1A" stroke-width="1.5"/>
  <circle cx="11" cy="13" r="2" fill="#8B0000"/>
  <circle cx="21" cy="13" r="2" fill="#8B0000"/>
  <path d="M 10,22 Q 16,18 22,22" fill="none" stroke="#8B0000" stroke-width="1.5"/>'''
        return svg_wrap(w, h, body)
    if element == "icon_diplomacy":
        w = h = 32
        body = f'''  <circle cx="16" cy="16" r="14" fill="#4682B4" stroke="#2F5F8F" stroke-width="1.5"/>
  <path d="M 8,16 Q 16,10 24,16 Q 16,22 8,16" fill="#D4AF37"/>
  <circle cx="16" cy="16" r="3" fill="#fff" opacity="0.7"/>'''
        return svg_wrap(w, h, body)
    if element == "icon_happiness":
        w = h = 32
        body = f'''  <circle cx="16" cy="16" r="14" fill="#D4AF37" stroke="#8B7355" stroke-width="1.5"/>
  <circle cx="11" cy="13" r="2" fill="#5A4A38"/>
  <circle cx="21" cy="13" r="2" fill="#5A4A38"/>
  <path d="M 10,20 Q 16,26 22,20" fill="none" stroke="#5A4A38" stroke-width="2"/>'''
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
    if element == "cursor_default":
        w, h = 24, 24
        body = '''  <polygon points="4,2 4,20 8,16 12,22 16,20 12,14 18,14" fill="#fff" stroke="#000" stroke-width="1"/>
  <polygon points="4,2 4,20 8,16 12,22 16,20 12,14 18,14" fill="none" stroke="#000" stroke-width="1"/>'''
        return svg_wrap(w, h, body)
    if element == "cursor_pointer":
        w, h = 24, 24
        body = '''  <polygon points="8,2 8,18 12,14 16,22 20,20 16,12 22,12" fill="#D4AF37" stroke="#000" stroke-width="1"/>'''
        return svg_wrap(w, h, body)
    return ""

# ── Efeitos (30) ──────────────────────────────────────────────────────
def gen_effect(name):
    w = h = 128
    cx, cy = 64, 64
    rng = random.Random(hash(name))

    if name == "fire":
        body = f'''  <polygon points="{cx},{cy-40} {cx+20},{cy} {cx},{cy+20} {cx-20},{cy}" fill="#FF4500" opacity="0.8"/>
  <polygon points="{cx},{cy-30} {cx+12},{cy+4} {cx},{cy+16} {cx-12},{cy+4}" fill="#FFD700" opacity="0.7"/>
  <polygon points="{cx},{cy-20} {cx+8},{cy+4} {cx},{cy+10} {cx-8},{cy+4}" fill="#fff" opacity="0.5"/>
  <circle cx="{cx-16}" cy="{cy+20}" r="6" fill="#FF4500" opacity="0.5"/>
  <circle cx="{cx+18}" cy="{cy+18}" r="5" fill="#FF8C00" opacity="0.5"/>'''
    elif name == "nuclear_explosion":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="50" fill="#FFFFFF" opacity="0.9"/>
  <circle cx="{cx}" cy="{cy}" r="40" fill="#FFD700" opacity="0.8"/>
  <circle cx="{cx}" cy="{cy}" r="30" fill="#FF8C00" opacity="0.7"/>
  <circle cx="{cx}" cy="{cy}" r="20" fill="#FF4500" opacity="0.6"/>
  <line x1="{cx}" y1="{cy-50}" x2="{cx}" y2="{cy-20}" stroke="#FFD700" stroke-width="4" opacity="0.6"/>
  <line x1="{cx-43}" y1="{cy-25}" x2="{cx-18}" y2="{cy-10}" stroke="#FFD700" stroke-width="3" opacity="0.5"/>
  <line x1="{cx+43}" y1="{cy-25}" x2="{cx+18}" y2="{cy-10}" stroke="#FFD700" stroke-width="3" opacity="0.5"/>'''
    elif name == "fallout":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="40" fill="#4A7B3A" opacity="0.2"/>
  <circle cx="{cx}" cy="{cy}" r="30" fill="#6A9B5A" opacity="0.3"/>
  <circle cx="{cx}" cy="{cy}" r="20" fill="#8ABB7A" opacity="0.4"/>
  <text x="{cx}" y="{cy+8}" font-size="32" text-anchor="middle" fill="#2F4F2F" font-weight="bold">☢</text>'''
    elif name == "plague":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="30" fill="#4A2B2B" opacity="0.3" stroke="#8B0000" stroke-width="2"/>
  <circle cx="{cx-12}" cy="{cy-8}" r="6" fill="#8B0000" opacity="0.6"/>
  <circle cx="{cx+10}" cy="{cy+6}" r="5" fill="#8B0000" opacity="0.6"/>
  <circle cx="{cx+4}" cy="{cy-12}" r="4" fill="#8B0000" opacity="0.5"/>
  <circle cx="{cx-8}" cy="{cy+10}" r="3" fill="#8B0000" opacity="0.5"/>'''
    elif name == "riot":
        body = f'''  <polygon points="{cx},{cy-30} {cx+20},{cy-10} {cx+15},{cy+20} {cx-15},{cy+20} {cx-20},{cy-10}" fill="#8B0000" opacity="0.7"/>
  <rect x="{cx-4}" y="{cy-10}" width="8" height="20" fill="#FFD700" opacity="0.8"/>
  <polygon points="{cx-4},{cy-10} {cx+4},{cy-10} {cx},{cy-20}" fill="#FFD700"/>
  <circle cx="{cx-8}" cy="{cy+24}" r="3" fill="#FF4500" opacity="0.6"/>
  <circle cx="{cx+8}" cy="{cy+24}" r="3" fill="#FF4500" opacity="0.6"/>'''
    elif name == "famine":
        body = f'''  <rect x="{cx-24}" y="{cy-20}" width="48" height="40" rx="4" fill="#8B7355" opacity="0.3" stroke="#5A4A38" stroke-width="2"/>
  <line x1="{cx-20}" y1="{cy-10}" x2="{cx+20}" y2="{cy-10}" stroke="#5A4A38" stroke-width="1" opacity="0.5"/>
  <line x1="{cx-20}" y1="{cy}" x2="{cx+20}" y2="{cy}" stroke="#5A4A38" stroke-width="1" opacity="0.5"/>
  <line x1="{cx-20}" y1="{cy+10}" x2="{cx+20}" y2="{cy+10}" stroke="#5A4A38" stroke-width="1" opacity="0.5"/>
  <text x="{cx}" y="{cy+8}" font-size="28" text-anchor="middle" fill="#5A4A38" opacity="0.7">↓</text>'''
    elif name == "revolution":
        body = f'''  <polygon points="{cx},{cy-30} {cx+26},{cy+20} {cx-26},{cy+20}" fill="#8B0000" opacity="0.7"/>
  <rect x="{cx-4}" y="{cy-10}" width="8" height="24" fill="#FFD700"/>
  <polygon points="{cx-4},{cy-10} {cx+4},{cy-10} {cx},{cy-18}" fill="#FFD700"/>
  <line x1="{cx-20}" y1="{cy+10}" x2="{cx+20}" y2="{cy+10}" stroke="#FFD700" stroke-width="2" opacity="0.4"/>'''
    elif name == "coup":
        body = f'''  <rect x="{cx-20}" y="{cy-20}" width="40" height="40" fill="#2F2F2F" opacity="0.4" stroke="#556B2F" stroke-width="2"/>
  <polygon points="{cx},{cy-30} {cx+16},{cy-10} {cx},{cy+10} {cx-16},{cy-10}" fill="#556B2F" opacity="0.7"/>
  <line x1="{cx}" y1="{cy-30}" x2="{cx}" y2="{cy+10}" stroke="#FFD700" stroke-width="2"/>
  <line x1="{cx-16}" y1="{cy-10}" x2="{cx+16}" y2="{cy-10}" stroke="#FFD700" stroke-width="2"/>'''
    elif name == "earthquake":
        body = f'''  <path d="M {cx-40},{cy} L {cx-30},{cy-20} L {cx-20},{cy+10} L {cx-10},{cy-15} L {cx},{cy+5} L {cx+10},{cy-20} L {cx+20},{cy+10} L {cx+30},{cy-10} L {cx+40},{cy}" fill="none" stroke="#8B4513" stroke-width="3" opacity="0.7"/>
  <path d="M {cx-35},{cy+20} L {cx-25},{cy} L {cx-15},{cy+25} L {cx-5},{cy+5} L {cx+5},{cy+25} L {cx+15},{cy} L {cx+25},{cy+20} L {cx+35},{cy+5}" fill="none" stroke="#8B4513" stroke-width="2" opacity="0.5"/>'''
    elif name == "volcano":
        body = f'''  <polygon points="{cx-30},{cy+30} {cx+30},{cy+30} {cx+20},{cy-10} {cx-20},{cy-10}" fill="#5A4A38" opacity="0.8"/>
  <polygon points="{cx-20},{cy-10} {cx+20},{cy-10} {cx+10},{cy-30} {cx-10},{cy-30}" fill="#FF4500" opacity="0.7"/>
  <polygon points="{cx-10},{cy-30} {cx+10},{cy-30} {cx},{cy-45}" fill="#FFD700" opacity="0.6"/>
  <circle cx="{cx-8}" cy="{cy-35}" r="3" fill="#FF8C00" opacity="0.5"/>'''
    elif name == "tech_advance":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="30" fill="none" stroke="#00CEDD" stroke-width="2" opacity="0.6"/>
  <circle cx="{cx}" cy="{cy}" r="20" fill="none" stroke="#00CEDD" stroke-width="1.5" opacity="0.5"/>
  <polygon points="{cx},{cy-20} {cx+14},{cy} {cx},{cy+20} {cx-14},{cy}" fill="#00CEDD" opacity="0.3"/>
  <circle cx="{cx}" cy="{cy}" r="6" fill="#00CEDD"/>
  <line x1="{cx}" y1="{cy}" x2="{cx}" y2="{cy-14}" stroke="#fff" stroke-width="2"/>'''
    elif name == "religious_schism":
        body = f'''  <polygon points="{cx-30},{cy+20} {cx-10},{cy+20} {cx-20},{cy-20}" fill="#8B7355" opacity="0.6"/>
  <polygon points="{cx+10},{cy+20} {cx+30},{cy+20} {cx+20},{cy-20}" fill="#8B7355" opacity="0.6"/>
  <line x1="{cx}" y1="{cy-30}" x2="{cx}" y2="{cy+30}" stroke="#8B0000" stroke-width="3" opacity="0.7" stroke-dasharray="6,4"/>
  <circle cx="{cx-20}" cy="{cy}" r="4" fill="#D4AF37" opacity="0.5"/>
  <circle cx="{cx+20}" cy="{cy}" r="4" fill="#D4AF37" opacity="0.5"/>'''
    elif name == "boom_economy":
        body = f'''  <polygon points="{cx},{cy+30} {cx-24},{cy-10} {cx+24},{cy-10}" fill="#556B2F" opacity="0.7"/>
  <rect x="{cx-4}" y="{cy-20}" width="8" height="10" fill="#556B2F"/>
  <polygon points="{cx-8},{cy-10} {cx+8},{cy-10} {cx},{cy-30}" fill="#556B2F"/>
  <text x="{cx}" y="{cy-4}" font-size="20" text-anchor="middle" fill="#FFD700">$</text>'''
    elif name == "depression":
        body = f'''  <polygon points="{cx},{cy-30} {cx+24},{cy+10} {cx-24},{cy+10}" fill="#2F2F2F" opacity="0.6"/>
  <text x="{cx}" y="{cy+4}" font-size="24" text-anchor="middle" fill="#8B0000">↓</text>
  <line x1="{cx-20}" y1="{cy+20}" x2="{cx+20}" y2="{cy+20}" stroke="#2F2F2F" stroke-width="2" opacity="0.4"/>'''
    elif name == "gold_rush":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="30" fill="#D4AF37" opacity="0.3"/>
  <polygon points="{cx},{cy-20} {cx+16},{cy} {cx},{cy+20} {cx-16},{cy}" fill="#D4AF37" opacity="0.6"/>
  <polygon points="{cx},{cy-12} {cx+8},{cy} {cx},{cy+12} {cx-8},{cy}" fill="#FFD700" opacity="0.8"/>
  <circle cx="{cx}" cy="{cy}" r="3" fill="#fff" opacity="0.7"/>'''
    elif name == "cultural_renaissance":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="28" fill="#8B4513" opacity="0.2" stroke="#D4AF37" stroke-width="2"/>
  <polygon points="{cx},{cy-16} {cx+12},{cy-4} {cx+8},{cy+12} {cx-8},{cy+12} {cx-12},{cy-4}" fill="#D4AF37" opacity="0.5"/>
  <circle cx="{cx}" cy="{cy}" r="4" fill="#D4AF37"/>'''
    elif name == "golden_age":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="36" fill="#FFD700" opacity="0.15"/>
  <circle cx="{cx}" cy="{cy}" r="24" fill="#FFD700" opacity="0.2"/>
  <circle cx="{cx}" cy="{cy}" r="12" fill="#FFD700" opacity="0.4"/>
  <circle cx="{cx}" cy="{cy}" r="4" fill="#fff" opacity="0.8"/>
  <line x1="{cx}" y1="{cy-36}" x2="{cx}" y2="{cy-24}" stroke="#FFD700" stroke-width="2" opacity="0.5"/>
  <line x1="{cx}" y1="{cy+24}" x2="{cx}" y2="{cy+36}" stroke="#FFD700" stroke-width="2" opacity="0.5"/>'''
    elif name == "dark_age":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="36" fill="#1a1a2e" opacity="0.4"/>
  <circle cx="{cx}" cy="{cy}" r="24" fill="#1a1a2e" opacity="0.5"/>
  <circle cx="{cx}" cy="{cy}" r="12" fill="#1a1a2e" opacity="0.6"/>
  <circle cx="{cx}" cy="{cy}" r="3" fill="#2F2F2F"/>
  <line x1="{cx-20}" y1="{cy-20}" x2="{cx+20}" y2="{cy+20}" stroke="#2F2F2F" stroke-width="2" opacity="0.5"/>'''
    elif name == "civil_war":
        body = f'''  <polygon points="{cx-30},{cy+20} {cx-10},{cy+20} {cx-20},{cy-20}" fill="#8B0000" opacity="0.6"/>
  <polygon points="{cx+10},{cy+20} {cx+30},{cy+20} {cx+20},{cy-20}" fill="#2F4F2F" opacity="0.6"/>
  <line x1="{cx}" y1="{cy-30}" x2="{cx}" y2="{cy+30}" stroke="#FFD700" stroke-width="3" opacity="0.7"/>
  <line x1="{cx-20}" y1="{cy-10}" x2="{cx+20}" y2="{cy+10}" stroke="#8B0000" stroke-width="2" opacity="0.5"/>'''
    elif name == "independence":
        body = f'''  <rect x="{cx-4}" y="{cy-20}" width="8" height="40" fill="#8B7355"/>
  <rect x="{cx-20}" y="{cy-20}" width="16" height="12" fill="#556B2F" opacity="0.7"/>
  <polygon points="{cx-20},{cy-20} {cx-4},{cy-20} {cx-12},{cy-28}" fill="#D4AF37"/>
  <circle cx="{cx+12}" cy="{cy-12}" r="4" fill="#D4AF37"/>'''
    elif name == "trade_boom":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="28" fill="#4682B4" opacity="0.2"/>
  <text x="{cx}" y="{cy+8}" font-size="28" text-anchor="middle" fill="#D4AF37">⇄</text>
  <circle cx="{cx-20}" cy="{cy}" r="6" fill="#D4AF37" opacity="0.5"/>
  <circle cx="{cx+20}" cy="{cy}" r="6" fill="#D4AF37" opacity="0.5"/>'''
    elif name == "embargo":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="28" fill="#8B0000" opacity="0.2" stroke="#8B0000" stroke-width="2"/>
  <line x1="{cx-20}" y1="{cy-20}" x2="{cx+20}" y2="{cy+20}" stroke="#8B0000" stroke-width="3" opacity="0.7"/>
  <line x1="{cx+20}" y1="{cy-20}" x2="{cx-20}" y2="{cy+20}" stroke="#8B0000" stroke-width="3" opacity="0.7"/>'''
    elif name == "flood":
        body = f'''  <path d="M {cx-40},{cy+10} Q {cx-20},{cy-10} {cx},{cy+10} Q {cx+20},{cy-10} {cx+40},{cy+10} L {cx+40},{cy+30} L {cx-40},{cy+30} Z" fill="#1B4B7A" opacity="0.5"/>
  <path d="M {cx-40},{cy+10} Q {cx-20},{cy-10} {cx},{cy+10} Q {cx+20},{cy-10} {cx+40},{cy+10}" fill="none" stroke="#3A8BC0" stroke-width="2" opacity="0.6"/>
  <rect x="{cx-16}" y="{cy-20}" width="32" height="24" fill="#5A4A38" opacity="0.4"/>'''
    elif name == "meteor_impact":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="30" fill="#FF4500" opacity="0.5"/>
  <circle cx="{cx}" cy="{cy}" r="20" fill="#FF8C00" opacity="0.6"/>
  <circle cx="{cx}" cy="{cy}" r="10" fill="#FFD700" opacity="0.7"/>
  <circle cx="{cx}" cy="{cy}" r="4" fill="#fff" opacity="0.8"/>
  <line x1="{cx-30}" y1="{cy-30}" x2="{cx-10}" y2="{cy-10}" stroke="#FF4500" stroke-width="2" opacity="0.5"/>
  <line x1="{cx+30}" y1="{cy-30}" x2="{cx+10}" y2="{cy-10}" stroke="#FF4500" stroke-width="2" opacity="0.5"/>'''
    elif name == "alien_contact":
        body = f'''  <ellipse cx="{cx}" cy="{cy-8}" rx="16" ry="20" fill="#4A6B4A" opacity="0.6"/>
  <circle cx="{cx-6}" cy="{cy-12}" r="4" fill="#fff" opacity="0.7"/>
  <circle cx="{cx+6}" cy="{cy-12}" r="4" fill="#fff" opacity="0.7"/>
  <circle cx="{cx-6}" cy="{cy-12}" r="2" fill="#000"/>
  <circle cx="{cx+6}" cy="{cy-12}" r="2" fill="#000"/>
  <ellipse cx="{cx}" cy="{cy+30}" rx="24" ry="4" fill="#4A6B4A" opacity="0.3"/>'''
    elif name == "ai_awakening":
        body = f'''  <rect x="{cx-24}" y="{cy-24}" width="48" height="48" rx="4" fill="#1a1a2e" opacity="0.7" stroke="#00CEDD" stroke-width="2"/>
  <circle cx="{cx}" cy="{cy}" r="12" fill="#00CEDD" opacity="0.3"/>
  <circle cx="{cx}" cy="{cy}" r="6" fill="#00CEDD" opacity="0.6"/>
  <circle cx="{cx}" cy="{cy}" r="2" fill="#fff"/>
  <line x1="{cx-16}" y1="{cy-16}" x2="{cx-8}" y2="{cy-8}" stroke="#00CEDD" stroke-width="1" opacity="0.5"/>
  <line x1="{cx+16}" y1="{cy-16}" x2="{cx+8}" y2="{cy-8}" stroke="#00CEDD" stroke-width="1" opacity="0.5"/>'''
    elif name == "space_race":
        body = f'''  <polygon points="{cx},{cy-30} {cx+8},{cy-10} {cx+8},{cy+10} {cx-8},{cy+10} {cx-8},{cy-10}" fill="#D0D0D0" opacity="0.7"/>
  <polygon points="{cx},{cy-30} {cx+4},{cy-24} {cx-4},{cy-24}" fill="#FF6B35"/>
  <line x1="{cx-8}" y1="{cy+10}" x2="{cx-16}" y2="{cy+24}" stroke="#D0D0D0" stroke-width="2"/>
  <line x1="{cx+8}" y1="{cy+10}" x2="{cx+16}" y2="{cy+24}" stroke="#D0D0D0" stroke-width="2"/>
  <circle cx="{cx}" cy="{cy+28}" r="3" fill="#FF6B35" opacity="0.5"/>'''
    elif name == "pandemic_modern":
        body = f'''  <circle cx="{cx}" cy="{cy}" r="30" fill="#4682B4" opacity="0.15" stroke="#4682B4" stroke-width="2"/>
  <circle cx="{cx-10}" cy="{cy-6}" r="5" fill="#4682B4" opacity="0.4"/>
  <circle cx="{cx+8}" cy="{cy+4}" r="4" fill="#4682B4" opacity="0.4"/>
  <circle cx="{cx+2}" cy="{cy-10}" r="3" fill="#4682B4" opacity="0.3"/>
  <line x1="{cx-10}" y1="{cy-6}" x2="{cx+2}" y2="{cy-10}" stroke="#4682B4" stroke-width="1" opacity="0.3"/>
  <line x1="{cx+2}" y1="{cy-10}" x2="{cx+8}" y2="{cy+4}" stroke="#4682B4" stroke-width="1" opacity="0.3"/>'''
    elif name == "cyber_attack":
        body = f'''  <rect x="{cx-24}" y="{cy-16}" width="48" height="32" rx="2" fill="#1a1a2e" opacity="0.7" stroke="#00CEDD" stroke-width="1.5"/>
  <line x1="{cx-20}" y1="{cy-8}" x2="{cx+20}" y2="{cy-8}" stroke="#FF4500" stroke-width="1" opacity="0.6"/>
  <line x1="{cx-20}" y1="{cy}" x2="{cx+20}" y2="{cy}" stroke="#FF4500" stroke-width="1" opacity="0.6"/>
  <line x1="{cx-20}" y1="{cy+8}" x2="{cx+20}" y2="{cy+8}" stroke="#FF4500" stroke-width="1" opacity="0.6"/>
  <text x="{cx}" y="{cy+4}" font-size="16" text-anchor="middle" fill="#FF4500">!</text>'''
    elif name == "dimensional_rift":
        body = f'''  <ellipse cx="{cx}" cy="{cy}" r="40" fill="none" stroke="#FF00FF" stroke-width="2" opacity="0.4"/>
  <ellipse cx="{cx}" cy="{cy}" r="28" fill="none" stroke="#FF00FF" stroke-width="1.5" opacity="0.5"/>
  <ellipse cx="{cx}" cy="{cy}" r="16" fill="#FF00FF" opacity="0.15"/>
  <ellipse cx="{cx}" cy="{cy}" r="8" fill="#FF00FF" opacity="0.3"/>
  <circle cx="{cx}" cy="{cy}" r="3" fill="#fff" opacity="0.6"/>
  <line x1="{cx-40}" y1="{cy-20}" x2="{cx-20}" y2="{cy}" stroke="#FF00FF" stroke-width="1" opacity="0.3"/>
  <line x1="{cx+40}" y1="{cy+20}" x2="{cx+20}" y2="{cy}" stroke="#FF00FF" stroke-width="1" opacity="0.3"/>'''
    else:
        body = f'  <circle cx="{cx}" cy="{cy}" r="30" fill="#888" opacity="0.3"/>'
    return svg_wrap(w, h, body)

def generate_all():
    count = 0
    for elem in UI_ELEMENTS:
        save_svg(f"{OUTPUT}/ui/{elem}.svg", gen_ui(elem))
        count += 1
    for eff in EFFECTS:
        save_svg(f"{OUTPUT}/effects/{eff}.svg", gen_effect(eff))
        count += 1
    return count
