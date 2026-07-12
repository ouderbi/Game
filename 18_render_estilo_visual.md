# PROJETO NOÓS
## Documento 18 / 21 — Render & Estilo Visual 2D

> **Camada:** Interface & Experiência · **Status:** rascunho para revisão · **Série:** 21 documentos
> **Depende de:** 03 (Arquitetura), 04 (Mundo) · **Alimenta:** 19 (UI/UX)

Como o jogo se desenha. Implementa `render/`. Gráficos modestos de propósito — o investimento é na simulação, não em pixels.

---

### 1. Abordagem de renderização

- **Godot 4** (PDF 03): `TileMapLayer` pro mapa **baseado em tiles** (quadrados, PDF 04).
- **Sprites** (`Sprite2D`/`AnimatedSprite2D`) pra cidades, exércitos e ícones de evento.
- **Câmera** (`Camera2D`) com *pan* e *zoom*, transitando entre as 4 lentes do PDF 24.

---

### 2. A visão do mapa (camadas, de baixo pra cima)

```
1. Terreno (tiles por bioma)
2. Regiões / fronteiras (cores de posse)
3. Cidades / exércitos (sprites)
4. Eventos / efeitos (fogo, fallout, pânico)
5. Sobreposição de UI (PDF 19)
```

---

### 3. Câmera e zoom

*Pan* livre + *zoom* contínuo entre as quatro lentes do PDF 24 (Cidade → País → Planeta → Galáxia): longe = agregado/abstrato; perto = mais detalhe (liga com o LOD, PDF 03 §9). Transição suave entre lentes (PDF 24 §5).

---

### 4. Estilo visual por era

A estética **muda conforme a civilização avança** pelas 12 eras (PDF 05): primitiva (pedra) → clássica → industrial → moderna → **retrofuturismo Fallout** (Alta Tecnologia) → sci-fi espacial/galáctico (Espacial → Intergaláctica) no fim da árvore. Cada era tem paleta e conjunto de sprites próprios.

---

### 5. Linguagem visual do estado

O jogador **vê a crise de relance**, sem abrir menu: tons e ícones pra fome, revolta, guerra; animações pra eventos fortes (um ataque nuclear arrasa visualmente a região). Isso torna o sistema emergente **legível**.

---

### 6. Desempenho

- **Culling:** só desenha os tiles visíveis.
- Só o **mundo ativo** é renderizado.
- **Interpolação** entre ticks pra movimento suave (frame variável sobre tick fixo, PDF 03).

---

### 7. Assets e arte-placeholder

Sprites, tiles e fontes em `assets/`. **Placeholder de alta qualidade desde já**: pacotes CC0 (Kenney) entram nos primeiros marcos (PDF 20, PDF 24 §5) — não travar o projeto esperando arte final, mas também não começar com formas/cores simples demais, já que a resolução da engine de render é alta desde o início.

---

### 8. Conexões

- **19 (UI/UX)** desenha por cima desta base.
- **04 (Mundo)** fornece tiles, biomas e regiões.
- **16 (Eventos)** fornece os efeitos visuais de crise.
- **24 (Multi-escala)** detalha as quatro lentes e a lente Cidade isométrica.

---

*Fim do Documento 18 / 21.*
