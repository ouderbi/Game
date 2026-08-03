# Manifesto Completo de Ativos — Noós

500 arquivos SVG cobrindo todas as eras, biomas, sistemas e elementos visuais do jogo.

---

## Distribuição por Categoria

| # | Categoria | Quantidade | Localização |
|---|---|---|---|
| 1 | Terreno isométrico | 27 | `terrain/iso/` |
| 2 | Terreno top-down | 9 | `terrain/topdown/` |
| 3 | Edifícios | 120 | `buildings/<era>/` |
| 4 | Unidades | 48 | `units/` |
| 5 | Líderes | 60 | `leaders/` |
| 6 | Tecnologias | 48 | `techs/` |
| 7 | Governos | 48 | `governments/` |
| 8 | Recursos | 24 | `resources/` |
| 9 | Bandeiras | 24 | `flags/` |
| 10 | Interface (UI) | 26 | `ui/` |
| 11 | Efeitos de evento | 30 | `effects/` |
| 12 | Decorações de mapa | 12 | `decorations/` |
| 13 | Transições de era | 12 | `transitions/` |
| 14 | Marcos naturais | 12 | `landmarks/` |
| | **Total** | **500** | |

---

## 1. Terreno Isométrico (27) — Lente Cidade

9 biomas × 3 níveis de elevação (plano, baixo, alto).

Arquivos: `terrain/iso/<bioma>_{flat,low,high}.svg`

Biomas: ocean, plains, forest, desert, mountain, tundra, savanna, swamp, coast.

## 2. Terreno Top-Down (9) — Lente País/Planeta

Arquivos: `terrain/topdown/<bioma>.svg`

## 3. Edifícios (120) — 10 por era × 12 eras

Cada era tem 10 edifícios únicos cobrindo 9 categorias: defense, civic, economic, cultural, religious, infrastructure, housing, military, special.

Arquivos: `buildings/<era>/<id>.svg`

| Era | Diretório | Exemplos |
|---|---|---|
| 1 Pedra | `buildings/stone_age/` | palisade, stone_circle, hunting_camp, fire_pit, shaman_hut |
| 2 Antiguidade | `buildings/antiquity/` | mud_wall, ziggurat, granary, market_stall, scribes_school |
| 3 Clássica | `buildings/classical/` | stone_wall, academy, agora, amphitheater, pantheon |
| 4 Medieval | `buildings/medieval/` | castle, cathedral, windmill, tavern, monastery |
| 5 Industrial | `buildings/industrial/` | bastion_fort, town_hall, factory, opera_house, arsenal |
| 6 Moderna | `buildings/modern/` | bunker, parliament, power_plant, cinema, airport |
| 7 Informação | `buildings/information/` | sam_site, data_center, solar_farm, stadium, university_modern |
| 8 Alta Tecnologia | `buildings/high_tech/` | energy_shield, ai_lab, fusion_plant, holo_theater, arcology |
| 9 Espacial | `buildings/space/` | orbital_defense, space_colony, rocket_launch, space_elevator |
| 10 Interplanetária | `buildings/interplanetary/` | defense_grid, terraforming, asteroid_mine, mech_factory |
| 11 Estelar | `buildings/stellar/` | fleet_station, stellar_assembly, trade_hub, warp_gate |
| 12 Intergaláctica | `buildings/intergalactic/` | galactic_defense, galactic_council, wormhole_gen, dyson_sphere |

## 4. Unidades (48) — 4 por era × 12 eras

Arquivos: `units/<id>.svg`

Tipos: land, naval, air, special. Cada era tem uma unidade terrestre, uma de apoio, uma naval/aérea e uma especial.

## 5. Líderes (60) — 5 por era × 12 eras

Arquivos: `leaders/<id>.svg`

Cada líder tem um retrato único com traços faciais, acessórios por era (coroa, laurel, visor, etc.) e arquétipo (sabio, agressor, autocrata, diplomata, mistico, republicano, pragmatico).

## 6. Tecnologias (48) — 4 por era × 12 eras

Arquivos: `techs/<id>.svg`

4 ramos: base, military, economy, culture. Cada tecnologia tem um ícone circular com símbolo único.

## 7. Governos (48) — 4 por era × 12 eras

Arquivos: `governments/<id>.svg`

Ícones representando a estrutura de governo de cada era (pirâmide, colunas, cúpula, torre, estação orbital).

## 8. Recursos (24) — 2 por era × 12 eras

Arquivos: `resources/<id>.svg`

Do sílex e couros da Idade da Pedra aos cristais do vazio e fragmentos de realidade da era Intergaláctica.

## 9. Bandeiras (24) — 2 por era × 12 eras

Arquivos: `flags/<id>.svg`

Estandartes e bandeiras evolutivas, de totens tribais a flâmulas dimensionais.

## 10. Interface (26)

Arquivos: `ui/<elemento>.svg`

Painéis (dark, light, thin, wide), botões (normal, hover, pressed, small, large, icon), ícones (tesouro, estabilidade, legitimidade, população, era, comida, militar, ciência, cultura, corrupção, diplomacia, felicidade), molduras (retrato, minimapa), cursores.

## 11. Efeitos de Evento (30)

Arquivos: `effects/<nome>.svg`

Eventos originais (12): fire, nuclear_explosion, fallout, plague, riot, famine, revolution, coup, earthquake, volcano, tech_advance, religious_schism.

Novos eventos (18): boom_economy, depression, gold_rush, cultural_renaissance, golden_age, dark_age, civil_war, independence, trade_boom, embargo, flood, meteor_impact, alien_contact, ai_awakening, space_race, pandemic_modern, cyber_attack, dimensional_rift.

## 12. Decorações de Mapa (12) — 1 por era

Arquivos: `decorations/<id>.svg`

Monumentos e marcos visuais que enriquecem o mapa: totem, obelisco, arco do triunfo, cruz de estrada, estátua industrial, memorial de guerra, mural digital, estátua holográfica, monumento espacial, farol planetário, portal estelar, pilar cósmico.

## 13. Transições de Era (12) — 1 por era

Arquivos: `transitions/<id>.svg`

Animações visuais de progressão entre eras, com seta ascendente e raios.

## 14. Marcos Naturais (12)

Arquivos: `landmarks/<id>.svg`

Recife de coral, rio sinuoso, árvore ancestral, oásis, pico sagrado, iceberg, baobá, mangue, arco natural, vulcão ativo, gêiser, lago de cratera.

---

## Integração com o Jogo

Os ativos estão integrados ao código GDScript:

- **`catalogo_construcoes.gd`** — 120 construções com custo, manutenção e bônus
- **`catalogo_tecnologias.gd`** — 48 tecnologias com bônus por ramo
- **`catalogo_lideres.gd`** — 60 líderes com traços de personalidade
- **`Regiao`** — agora tem campos `construcoes` e `recursos`
- **`EstadoDoMundo`** — agora tem catálogos de construções, tecnologias e recursos

## Formato

Todos os ativos são SVG (gráficos vetoriais escaláveis):
- Resolução infinita (alta fidelidade em qualquer zoom)
- Importáveis no Godot 4 como textures
- Leves e fáceis de versionar
- Estilo consistente e limpo
- Paletas de cor únicas por era e bioma
