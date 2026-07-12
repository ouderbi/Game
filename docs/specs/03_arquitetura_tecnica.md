# PROJETO LEVIATÃ
## Documento 03 / 20 — Arquitetura Técnica

> **Camada:** Fundamentos · **Status:** rascunho para revisão · **Série:** 20 documentos
> **Depende de:** 01 (Visão), 02 (Game Design) · **Alimenta:** 04 (Mundo), 06 (Modelo de Dados), 13–14 (Inteligência), 20 (Roadmap)

Documento mais técnico dos fundamentos. É a base que o Claude Code mais vai consultar. Regra de ouro que atravessa tudo: **o núcleo de simulação nunca espera a rede.**

---

### 1. Stack & por quê  ✅ decidido

- **Linguagem:** Python 3.11+ — onde a lógica de agente/IA é natural e onde o desenvolvedor já é forte.
- **Render 2D:** pygame — exigências gráficas modestas (tiles + sprites); leve e direto.
- **Empacotamento:** PyInstaller → `.exe` nativo de Windows.
- **Libs de apoio:** `numpy` (população em massa, vetorizada), SDK Anthropic + cliente Ollama (provedores de LLM), `zlib`/`msgpack` (save), `pydantic` ou dataclasses (schemas).

A stack serve a um jogo **pesado em lógica e leve em gráficos**. Não usamos engine dedicada (Godot) pra não pagar curva de aprendizado e atrito de integração com LLM.

---

### 2. Estrutura de pastas e módulos

Cada pasta é um módulo limpo, que o Claude Code pode tratar isolado:

```
leviata/
├── main.py              # ponto de entrada, monta e roda o loop
├── core/                # CORPO: motor de simulação (tick)
│   ├── clock.py         # relógio, fixed timestep, velocidades
│   ├── sim.py           # orquestra o pipeline de um tick
│   └── lod.py           # nível de detalhe / orçamento de tempo
├── world/               # estado do mundo e entidades
│   ├── state.py         # o WorldState (tudo que é salvo)
│   ├── population.py     # os milhões (arrays numpy / ECS-lite)
│   └── entities.py       # polities, líderes, facções (OOP)
├── brains/              # CÉREBRO: camada de decisão
│   ├── decider.py       # contrato Decider.decide(brief) -> Decision
│   ├── heuristic.py     # motor de regras (instantâneo)
│   └── queue.py         # fila assíncrona de decisões de LLM
├── providers/           # adaptadores de IA (trocáveis) — ver PDF 14
│   ├── base.py          # interface comum
│   ├── anthropic.py     # Claude via API
│   ├── ollama.py        # modelo local
│   └── distilled.py     # rede destilada (fase futura)
├── events/              # motor e catálogo de eventos — ver PDF 15–16
├── render/              # desenho 2D (pygame), câmera, zoom
├── ui/                  # painéis, controles, os "verbos" do jogador
├── persistence/         # save/load
├── config/              # configurações e segredos (fora do código)
└── assets/              # sprites, tiles, fontes
```

---

### 3. As camadas — cérebro/corpo no código

```
[ render / ui ]      ← apresentação (frame variável)
       ↑ lê estado
[ core / world ]     ← CORPO: simulação determinística (tick fixo)
       ↑ pede decisões            ↓ aplica decisões
[ brains ]           ← CÉREBRO: heurística (na hora) + fila de LLM (assíncrona)
       ↑
[ providers ]        ← adaptadores de IA trocáveis
[ persistence ]      ← save/load do world.state
```

- O **corpo** roda todo tick, sempre, sem bloquear.
- O **cérebro** entrega decisões: heurística na hora; LLM chega depois pela fila.
- **Render/UI** só *leem* o estado — nunca o alteram direto (alterações passam pela simulação).

---

### 4. O loop principal: tick vs frame  ✅ decidido (threads + fila)

- **Simulação:** *fixed timestep* — passos determinísticos e reproduzíveis (mesma semente → mesmo mundo). Essencial pra debugar e pra eventos serem "justos".
- **Render:** frame variável por cima, interpolando o visual entre ticks.
- **Concorrência do LLM:** um **pool de threads em segundo plano** processa as chamadas de LLM e devolve os resultados por uma **fila**. O loop principal só consome o que já está pronto na fila — **nunca bloqueia** esperando a rede. (Escolhido sobre asyncio por casar melhor com o loop síncrono do pygame.)

---

### 5. Pipeline de um tick

Ordem fixa dentro de cada passo de simulação:

1. **Atualizar pressões** (acúmulos que tornam eventos prováveis — ver PDF 15).
2. **População & economia** — vetorizado (numpy), barato.
3. **Disparar eventos** que cruzaram limiar.
4. **Coletar decisões de líderes:** heurística resolve na hora; decisões de LLM são *enfileiradas* e aplicadas quando a fila as devolve (um ou mais ticks depois).
5. **Aplicar efeitos** ao estado do mundo.
6. **Avançar relógio.**

---

### 6. Modelo de estado & entidades  ✅ decidido (híbrido)

- **População (milhões):** abordagem **dados-orientada / ECS-lite** — arrays paralelos em `numpy` (idade[], humor[], lealdade[], …). Escala pra milhões e roda vetorizado.
- **Entidades de alto nível (poucas):** **OOP** normal — `Polity`, `Leader`, `Faction`, com comportamento rico. São dezenas/centenas, não milhões, então clareza > performance bruta.

Tudo que importa pro save vive sob um único `WorldState` (Seção 7).

---

### 7. Save / load  ✅ decidido (híbrido)

- **Massa da população:** **binário comprimido** (`numpy` + `zlib`/`msgpack`) — rápido e pequeno.
- **Estado de alto nível** (polities, líderes, relações, era): **JSON legível** — fácil de inspecionar, versionar e depurar.
- Um save = uma pasta/arquivo com as duas partes + metadados (versão do schema, semente, tick atual).
- **Mundos congelados** são exatamente isto em disco; abrir = carregar; fechar = persistir.

---

### 8. Camada de provedores de IA (contrato)

Só o contrato aqui — implementação no **PDF 14**. Toda decisão "inteligente" passa por uma interface única:

```python
class Decider:
    def decide(self, brief: Brief) -> Decision: ...

# Implementações intercambiáveis:
#   HeuristicDecider  → regras, instantâneo
#   AnthropicDecider  → Claude via API (assíncrono, pela fila)
#   OllamaDecider     → modelo local
#   DistilledDecider  → rede destilada (futuro)
```

Trocar de motor = trocar a implementação. **O jogo nunca é reescrito**; só o `Decider` muda.

---

### 9. Desempenho & nível de detalhe (LOD)

- **Detalhe por importância:** regiões e indivíduos relevantes simulam fino; o resto roda agregado (estatístico).
- **Só o mundo ativo é vivo;** congelados não consomem CPU.
- **Orçamento de tempo por tick:** se um passo estoura o orçamento, baixa o LOD antes de engasgar o frame.

---

### 10. Empacotamento, config e segredos

- **PyInstaller** gera o `.exe` (um diretório ou arquivo único).
- **Chave de API fora do código:** arquivo de config local ou variável de ambiente — **nunca** commitada, pra não vazar.
- O jogador escolhe o provedor (Claude / Ollama local / só heurística) na config, sem mexer no código.

---

### 11. Conexões

- **04 (Mundo & Mapa)** e **06 (Modelo de Dados)** detalham o conteúdo do `WorldState`.
- **13–14 (Inteligência / Custo)** implementam `brains/` e `providers/`.
- **15–16 (Eventos)** implementam `events/` e as "pressões" da Seção 5.
- **18–19 (Render / UI)** implementam `render/` e `ui/`.
- **20 (Roadmap)** define a ordem de construção desses módulos.

---

*Fim do Documento 03 / 20.*
