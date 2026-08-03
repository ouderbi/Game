# Análise Visual do Noós — Ativos por Era

## O Jogo

Noós é um simulador de grande estratégia 2D onde o jogador conduz uma civilização da Idade da Pedra até a era Intergaláctica. Os rivais são líderes com mente própria, movidos por LLM, que lembram, planejam e tramam. Pandemias, guerras nucleares, golpes, inflação e revoluções emergem de pressões acumuladas — nunca de scripts ou dados aleatórios.

## Loop de Jogo

Observar o mundo → Decidir ações → Simulação avança um tick → Consequências aparecem → Repete

O jogador age em tempo real com pausa (estilo HOI4), controlando uma polity entre 4 (1 jogador + 3 NPCs). O mundo nunca para de viver.

## Identidade Visual

- **Lente Cidade:** isométrico dimétrico 2:1 (estilo SimCity 2000), tiles em losango com edifícios 3D
- **Lente País:** top-down com regiões como nós coloridos por bioma e dono (estilo HOI4)
- **Lente Planeta:** top-down global, todas as polities visíveis
- **Lente Galáxia:** grafo de sistemas estelares conectados por rotas

A estética evolui por era:

1. **Pedra** — terroso, orgânico, primitivo
2. **Antiguidade** — desértico, monumental, barro/tijolo
3. **Clássica** — mármore, elegância, colunas
4. **Medieval** — pedra, fortificação, sombrio
5. **Industrial** — ferrugem, fuligem, mecânico
6. **Moderna** — militar, aço, concreto
7. **Informação** — vidro, cromo, limpo
8. **Alta Tecnologia** — neon, retrofuturista Fallout
9. **Espacial** — espaço, prata, clean
10. **Interplanetária** — industrial espacial, laranja/aço
11. **Estelar** — cósmico, majestoso, dourado
12. **Intergaláctica** — transcendente, iridescente

## Especificações Técnicas

### Isométrico (Lente Cidade)
- Tile plano: viewBox 128×64, losango 2:1
- Tile elevado: viewBox 128×96, paredes de 32px
- Tile alto: viewBox 128×128, paredes de 64px
- Edifício: viewBox 128×128, com altura e sombra
- Projeção: tela_x = (gx − gy) × 64, tela_y = (gx + gy) × 32 − nível × 16

### Top-Down (Lente País/Planeta)
- Tile: viewBox 64×64, quadrado texturizado por bioma
- Ícones de cidade/exército sobrepostos

### Galáxia
- Nós circulares (sistemas) conectados por linhas (rotas)

## Paletas de Cor por Era

| # | Era | Cor Base | Cor Accent | Cor Escura | Estilo |
|---|---|---|---|---|---|
| 1 | Pedra | #8B7355 | #6B8E23 | #5A4A38 | Terroso |
| 2 | Antiguidade | #D4A76A | #C17B3A | #8B5A2B | Desértico |
| 3 | Clássica | #E8E0D0 | #D4AF37 | #8B7355 | Mármore |
| 4 | Medieval | #8B8B7A | #8B0000 | #4A4A3A | Fortificado |
| 5 | Industrial | #8B4513 | #4A4A4A | #2F2F2F | Ferrugem |
| 6 | Moderna | #556B2F | #708090 | #2F4F2F | Militar |
| 7 | Informação | #4682B4 | #B0C4DE | #2F5F8F | Tecnológico |
| 8 | Alta Tecnologia | #00CEDD | #2F3437 | #1A1A2E | Retrofuturista |
| 9 | Espacial | #191970 | #D0D0D0 | #0D0D4F | Espacial |
| 10 | Interplanetária | #1A1A2E | #FF6B35 | #0D0D1A | Industrial espacial |
| 11 | Estelar | #2D1B4E | #FFD700 | #1A0D2E | Cósmico |
| 12 | Intergaláctica | #0D0D0D | #FF00FF | #000000 | Transcendente |

## Biomas (9)

| Bioma | Cor Base | Cor Escura | Textura |
|---|---|---|---|
| Oceano | #1B4B7A | #0D3560 | Ondas |
| Planície | #6FAE3A | #4D8A22 | Grama |
| Floresta | #2D6B1F | #1A4A12 | Copas de árvore |
| Deserto | #D4A85A | #B8923E | Dunas |
| Montanha | #7A7670 | #5A564F | Picos |
| Tundra | #C8D5DC | #A8B5BC | Rachaduras de gelo |
| Savana | #B8B44A | #8A8620 | Tufos de grama |
| Pântano | #4A6B3A | #2A4A1A | Manchas de água |
| Costa | #D4C58A | #B89A5A | Transição areia-água |

## Categorias de Ativos

| Categoria | Descrição | Quantidade |
|---|---|---|
| Terreno isométrico | Tiles por bioma × 3 níveis de elevação | 27 |
| Terreno top-down | Tiles por bioma | 9 |
| Edifícios | 3 por era (defensiva, cívica, econômica) × 12 eras | 36 |
| Unidades | 1 por era | 12 |
| Interface | Painéis, botões, ícones | 12 |
| Efeitos | Indicadores visuais de eventos | 12 |
| **Total** | | **108** |

## Formato

Todos os ativos são arquivos SVG (gráficos vetoriais escaláveis):
- Resolução infinita (alta fidelidade em qualquer zoom)
- Importáveis no Godot 4 como textures
- Leves e fáceis de versionar
- Estilo consistente e limpo
