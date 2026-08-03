#!/usr/bin/env python3
"""
Gerador master de assets SVG para o jogo Noós.
Executa todos os módulos e gera 500 arquivos SVG no total.

Distribuição:
  1. Terreno isométrico:  27  (9 biomas × 3 níveis)
  2. Terreno top-down:     9  (9 biomas)
  3. Edifícios:           120 (10 por era × 12 eras)
  4. Unidades:             48  (4 por era × 12 eras)
  5. Líderes:              60  (5 por era × 12 eras)
  6. Tecnologias:          48  (4 por era × 12 eras)
  7. Governos:             48  (4 por era × 12 eras)
  8. Recursos:             24  (2 por era × 12 eras)
  9. Bandeiras:            24  (2 por era × 12 eras)
 10. Interface:            26
 11. Efeitos:              30
 Total:                   464 + 36 existentes = 500
"""
import sys
import os

# Garante que o diretório do script está no path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from gerar_terrain import generate_all as gen_terrain
from gerar_buildings import generate_all as gen_buildings
from gerar_units import generate_all as gen_units
from gerar_leaders import generate_all as gen_leaders
from gerar_misc import generate_all as gen_misc
from gerar_ui_effects import generate_all as gen_ui_effects
from gerar_extras import generate_all as gen_extras

def main():
    total = 0
    total += gen_terrain()
    print(f"  Terreno: {total}")
    n = gen_buildings()
    total += n
    print(f"  Edifícios: {n} (total: {total})")
    n = gen_units()
    total += n
    print(f"  Unidades: {n} (total: {total})")
    n = gen_leaders()
    total += n
    print(f"  Líderes: {n} (total: {total})")
    n = gen_misc()
    total += n
    print(f"  Misc (techs/govs/recursos/bandeiras): {n} (total: {total})")
    n = gen_ui_effects()
    total += n
    print(f"  UI + Efeitos: {n} (total: {total})")
    n = gen_extras()
    total += n
    print(f"  Extras (decorações/transições/marcos): {n} (total: {total})")
    print(f"\nTotal gerado: {total} arquivos SVG")

if __name__ == "__main__":
    main()
