# PROJETO NOÓS
## Documento 03 / 20 — Arquitetura Técnica

> **Camada:** Fundamentos · **Status:** rascunho para revisão · **Série:** 20 documentos
> **Depende de:** 01 (Visão), 02 (Game Design) · **Alimenta:** 04 (Mundo), 06 (Modelo de Dados), 13–14 (Inteligência), 20 (Roadmap)

Documento mais técnico dos fundamentos. É a base que o Claude Code mais vai consultar. Regra de ouro que atravessa tudo: **o núcleo de simulação nunca espera a rede.**

---

### 1. Stack & por quê  ✅ decidido (revisado)

- **Engine:** **Godot 4** — multiplataforma de graça (Windows/Linux/Mac), export nativo, editor de cenas encaixa bem com o mapa e a UI, e escala melhor pro porte grande do projeto (12 eras, 4 escalas de mapa) do que uma stack montada à mão.
- **Linguagem:** **GDScript** para a maior parte do jogo (produtivo, tipado opcionalmente); partes de simulação muito pesadas (população em massa) podem migrar pra **C#** ou um **GDExtension** (C++/Rust) mais adiante, se o perfilamento pedir — não é decisão do dia 1.
- **Render 2D:** nativo do Godot — `TileMapLayer` pro terreno, `Sprite2D`/`AnimatedSprite2D` pra cidades, exércitos e ícones, `Camera2D` pra pan/zoom.
- **Empacotamento:** exportadores nativos do Godot (Windows, Linux, Mac) — sem PyInstaller, sem gambiarra de bundling.
- **LLM/rede:** nó `HTTPRequest` do Godot — assíncrono por natureza (baseado em sinal), chama Ollama local (`localhost:11434`) e, futuramente, a API da Anthropic.
- **Save:** `FileAccess` do Godot + serialização própria (JSON pra estado de alto nível, binário compacto pra população agregada).

**Por que Godot em vez da stack Python original:** o projeto cresceu de "fatia vertical pequena" pra escala tipo Spore (12 eras, mapa Cidade→País→Planeta→Galáxia). Godot dá multiplataforma de graça, um editor de cena que ajuda nas 4 lentes de zoom (PDF 24) e exporta sem dor — trade-off aceito: curva de aprendizado nova, mas paga-se uma vez só.

**Por que não trava a integração com LLM:** `HTTPRequest` é não-bloqueante por design (emite sinal quando a resposta chega) — o mesmo padrão "corpo nunca espera o cérebro" da Seção 4 sai de graça, sem precisar montar pool de threads manualmente como seria em Python síncrono.

---

### 2. Estrutura de pastas e módulos (projeto Godot)

Cada pasta é um módulo limpo, que o Claude Code pode tratar isolado:

```
noos/                       # raiz do projeto Godot
├── project.godot
├── main.tscn / main.gd     # ponto de entrada, monta e roda o loop
├── core/                   # CORPO: motor de simulação (tick)
│   ├── clock.gd            # relógio, fixed timestep, velocidades
│   ├── sim.gd              # orquestra o pipeline de um tick
│   └── lod.gd              # nível de detalhe / orçamento de tempo
├── world/                  # estado do mundo e entidades
│   ├── world_state.gd      # o WorldState (tudo que é salvo)
│   ├── population.gd       # população agregada por região (PackedArrays)
│   └── entities/           # polity.gd, leader.gd, faction.gd (classes)
├── brains/                 # CÉREBRO: camada de decisão
│   ├── decider.gd          # interface Decider.decide(briefing) -> Decision
│   ├── heuristic.gd        # motor de utility AI (instantâneo — ver PDF 25)
│   └── request_queue.gd    # fila de decisões pendentes de LLM (via HTTPRequest)
├── providers/               # adaptadores de IA (trocáveis) — ver PDF 14
│   ├── base_provider.gd     # interface comum
│   ├── ollama_provider.gd   # modelo local — PRIORITÁRIO no momento
│   ├── anthropic_provider.gd# Claude via API (futuro/opt-in, sem orçamento hoje)
│   └── distilled_provider.gd# rede destilada (fase futura)
├── events/                  # motor e catálogo de eventos — ver PDF 15–16
├── render/                  # cenas de mapa, câmera, lentes de zoom — ver PDF 18/24
├── ui/                      # painéis, controles, os "verbos" do jogador — PDF 19
├── persistence/              # save/load
├── config/                   # configurações e segredos (fora do controle de versão)
├── localization/             # PT-BR e EN desde o início — ver PDF 19
└── assets/                   # sprites, tiles, fontes (Kenney CC0 como placeholder — PDF 24)
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
[ persistence ]      ← save/load do world_state
```

- O **corpo** roda todo tick, sempre, sem bloquear.
- O **cérebro** entrega decisões: heurística na hora; LLM chega depois via sinal do `HTTPRequest`.
- **Render/UI** só *leem* o estado — nunca o alteram direto (alterações passam pela simulação).

---

### 4. O loop principal: tick vs frame  ✅ decidido (revisado pra Godot)

- **Simulação:** *fixed timestep* implementado por acumulador dentro de `_process(delta)` (não usamos `_physics_process` puro, pra manter controle total do passo) — determinístico e reproduzível (mesma semente → mesmo mundo).
- **Render:** frame variável do próprio Godot por cima, interpolando visual entre ticks.
- **Concorrência do LLM:** cada chamada de LLM é um nó `HTTPRequest` (ou uma fila deles) que dispara a requisição e emite um sinal (`request_completed`) quando a resposta chega — **nunca bloqueia** o loop principal. Se o provedor atrasar/cair, cai no fallback heurístico naquele tick (mesma regra de sempre).
- Tarefas pesadas de CPU (não-rede) que precisem rodar em paralelo usam o `WorkerThreadPool` nativo do Godot.

---

### 5. Pipeline de um tick

Ordem fixa dentro de cada passo de simulação:

1. **Atualizar pressões** (acúmulos que tornam eventos prováveis — ver PDF 15).
2. **População & economia** — agregado por região, barato (Seção 6).
3. **Disparar eventos** que cruzaram limiar.
4. **Coletar decisões de líderes:** heurística resolve na hora; decisões de LLM são *enfileiradas* e aplicadas quando o `HTTPRequest` devolve (um ou mais ticks depois).
5. **Aplicar efeitos** ao estado do mundo.
6. **Avançar relógio.**

---

### 6. Modelo de estado & entidades  ✅ decidido (agregado sempre)

- **Princípio de ouro (reafirmado do PDF 24):** a simulação roda **sempre agregada por região/cidade**, nunca por indivíduo ou por tile — isso vale mesmo nas escalas Planeta/Galáxia, onde simular célula a célula seria inviável.
- **População:** arrays agregados por região (`PackedFloat32Array`/`PackedInt32Array` do Godot: população total, humor médio, lealdade média, distribuição de riqueza, traços agregados…) — não uma entidade por cidadão. Indivíduos "importantes" (líderes, heróis, figuras notáveis) são **promovidos** a entidades próprias via LOD (Seção 9), mas isso é exceção, não a regra.
- **Entidades de alto nível (poucas):** classes normais (`Polity`, `Leader`, `Faction`) com comportamento rico. São dezenas/centenas por mundo, não milhões — clareza > performance bruta.

Tudo que importa pro save vive sob um único `WorldState` (Seção 7).

---

### 7. Save / load  ✅ decidido (híbrido)

- **Estado agregado de população/regiões:** binário compacto (arrays serializados) — rápido e pequeno mesmo em mapas grandes (Planeta/Galáxia).
- **Estado de alto nível** (polities, líderes, relações, era): **JSON legível** — fácil de inspecionar, versionar e depurar.
- Um save = uma pasta/arquivo com as duas partes + metadados (versão do schema, semente, tick atual).
- **Mundos congelados** são exatamente isto em disco; abrir = carregar; fechar = persistir.

---

### 8. Camada de provedores de IA (contrato)

Só o contrato aqui — implementação no **PDF 14**. Toda decisão "inteligente" passa por uma interface única:

```gdscript
class_name Decider
func decide(briefing: Briefing) -> Decision:
    pass  # implementado por cada provedor

# Implementações intercambiáveis:
#   HeuristicProvider   → regras/utility AI, instantâneo — SEMPRE disponível (fallback)
#   OllamaProvider      → modelo local, via HTTPRequest — PRIORITÁRIO hoje
#   AnthropicProvider   → Claude via API — opcional/futuro, sem orçamento comprometido agora
#   DistilledProvider   → rede destilada (fase futura)
```

Trocar de motor = trocar a implementação. **O jogo nunca é reescrito**; só o provedor muda.

---

### 9. Desempenho & nível de detalhe (LOD)

- **Detalhe por importância:** regiões/indivíduos relevantes (perto da câmera, ou narrativamente importantes) simulam fino; o resto roda agregado (estatístico) — vale em qualquer escala de mapa (PDF 24).
- **Só o mundo ativo é vivo;** congelados não consomem CPU.
- **Orçamento de tempo por tick:** se um passo estoura o orçamento, baixa o LOD antes de engasgar o frame.
- **Visualização ≠ simulação:** o LOD decide o detalhe do **desenho** (quantos sprites, que lente); a simulação por trás continua igual, sempre agregada (PDF 24 §3).

---

### 10. Empacotamento, config e segredos

- **Exportadores nativos do Godot** geram os binários (Windows, Linux, Mac) a partir dos *export presets* do projeto.
- **Chave de API fora do repositório:** arquivo de config local (`config/secrets.cfg`, fora do controle de versão) ou variável de ambiente — **nunca** commitada.
- O jogador escolhe o provedor (heurística / Ollama local / Claude API) na config, sem mexer em código.

---

### 11. Testes headless (vantagem prática do Godot)

Godot roda em modo `--headless` (sem janela, sem GPU) — essencial pra:

- **Testes em massa** (PDF 27): rodar centenas de simulações no CI ou em qualquer máquina sem display.
- **Verificação em ambientes de desenvolvimento remoto** (containers, CI) que não têm tela — permite validar lógica de simulação e até tirar screenshots via `--headless` + captura de viewport, sem precisar de Windows nem de monitor.

---

### 12. Conexões

- **04 (Mundo & Mapa)** e **06 (Modelo de Dados)** detalham o conteúdo do `WorldState`.
- **13–14 (Inteligência / Custo)** implementam `brains/` e `providers/`.
- **15–16 (Eventos)** implementam `events/` e as "pressões" da Seção 5.
- **18–19 (Render / UI)** implementam `render/` e `ui/`.
- **20 (Roadmap)** define a ordem de construção desses módulos.
- **24 (Multi-escala)** detalha como o princípio de ouro da Seção 6 sustenta as 4 lentes de zoom.

---

*Fim do Documento 03 / 20.*
