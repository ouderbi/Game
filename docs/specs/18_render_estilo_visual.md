# PROJETO LEVIATÃ
## Documento 18 / 21 — Render & Estilo Visual 2D

> **Camada:** Interface & Experiência · **Status:** rascunho para revisão · **Série:** 21 documentos
> **Depende de:** 03 (Arquitetura), 04 (Mundo) · **Alimenta:** 19 (UI/UX)

Como o jogo se desenha. Implementa `render/`. Gráficos modestos de propósito — o investimento é na simulação, não em pixels.

---

### 1. Abordagem de renderização

- **pygame**, mapa **baseado em tiles** (quadrados, PDF 04).
- **Sprites** pra cidades, exércitos e ícones de evento.
- **Câmera** com *pan* e *zoom*.

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

*Pan* livre + *zoom* entre a escala **estratégica** (mundo inteiro) e mais perto (região). Os níveis de zoom casam com as escalas do PDF 02 §4: longe = agregado/abstrato; perto = mais detalhe (liga com o LOD, PDF 03 §9). Escalas regional/individual são futuras.

---

### 4. Estilo visual por era

A estética **muda conforme a civilização avança**: primitiva (pedra) → clássica → industrial → moderna → **retrofuturismo Fallout / sci-fi** no fim da árvore. Cada era tem paleta e conjunto de sprites próprios.

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

Sprites, tiles e fontes em `assets/`. Pra **fatia vertical**, arte-placeholder (formas/cores simples) — não travar o projeto esperando arte final.

---

### 8. Conexões

- **19 (UI/UX)** desenha por cima desta base.
- **04 (Mundo)** fornece tiles, biomas e regiões.
- **16 (Eventos)** fornece os efeitos visuais de crise.

---

*Fim do Documento 18 / 21.*
