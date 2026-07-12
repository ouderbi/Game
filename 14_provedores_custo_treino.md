# PROJETO NOÓS
## Documento 14 / 21 — Provedores de LLM, Custo & Treino/Destilação

> **Camada:** Inteligência · **Status:** rascunho para revisão · **Série:** 21 documentos
> **Depende de:** 03 (Arquitetura), 13 (Inteligência) · **Alimenta:** 20 (Roadmap), 26 (Modos de IA)

A camada que torna o "cérebro" **trocável**, controla o **custo** e abriga a estratégia futura de **treinar uma rede** (do jeito que dá certo). Implementa `providers/`.

---

### 1. A interface de provedor (contrato)

Todo motor de decisão implementa a mesma interface — trocar de motor **nunca** reescreve o jogo:

```gdscript
class_name Provider
func decide(briefing: Briefing) -> Decision:
    pass

# Implementações:
#   HeuristicProvider   → regras/Utility AI (PDF 25); grátis; instantâneo; SEMPRE disponível (fallback)
#   OllamaProvider      → modelo aberto local, via HTTPRequest; grátis; offline — PRIORITÁRIO agora
#   AnthropicProvider   → Claude via API; esperto + voz; custa; latência de rede — opt-in/futuro
#   DistilledProvider   → rede pequena destilada; grátis; rápido (FASE 3)
```

**Sem `OllamaCloudProvider`:** decisão explícita de usar só Ollama **local** — nada de nuvem de terceiros pro modelo aberto.

---

### 2. Tiering de modelos (qual cérebro para qual líder)  — revisado, Ollama-first

| Importância do líder | Motor sugerido hoje | Motor futuro (quando houver orçamento) |
|---|---|---|
| Potência pivotal (1 jogador + 3 líderes-NPC, PDF 04 §7/11) | modelo local via Ollama (o maior que rodar bem na máquina) | Claude (Opus 4.8) — mais esperto + melhor voz |
| Potência média | modelo local menor via Ollama | Claude (Sonnet 5) |
| Estado menor / fundo | heurística (Utility AI, PDF 25) | heurística (sem mudança — não compensa gastar em líderes de fundo) |

A **dificuldade** do jogo escala por aqui: modelos locais maiores/heurística com menos ruído = adversários mais espertos (PDF 02 §8), sem depender de API paga.

---

### 3. Referência de preços da API Anthropic (quando/se for usada)  ⚠️ verificar antes de usar

Hoje o desenvolvimento **não depende disso** (Seção 5) — a tabela abaixo é só referência pra quando/se a `AnthropicProvider` entrar em uso real:

- **Opus 4.8:** contexto de 1M tokens por padrão, saída até 128k. Preço de referência: US$5 / milhão de tokens de entrada, US$25 / milhão de saída (contexto longo acima de 200k de entrada tem preço à parte). Cache de prompt: mínimo de 1.024 tokens; leitura de cache ≈ 10% do custo de entrada.
- **Sonnet 5** e **Haiku 4.5:** modelos de tier médio/leve, mais baratos que o Opus — **confirme os preços atuais na página oficial da Anthropic antes de orçar**, em vez de usar números fixos aqui (mudam com o tempo).

---

### 4. Disciplina de custo (alavancas concretas, pra quando a API entrar em jogo)

- **Ollama local como padrão**; API paga só pros poucos líderes pivotais, e só depois que houver orçamento definido.
- **Cadência esparsa**: pensar por *turno*, não por *tick*.
- **Cache de prompt** da parte estável do briefing (corta a maior parte do custo de entrada).
- **Batch API** (assíncrono, mais barato) para decisões não-urgentes.
- **Teto de gasto** configurável + **fallback heurístico/Ollama** se estourar.

---

### 5. A realidade de cobrança (situação atual do projeto)

- **Hoje o projeto usa exclusivamente o Ollama local** — sem custo por token, rodando na própria máquina, sem depender de rede externa. É o provedor padrão de desenvolvimento e o padrão pro jogo publicado.
- **A `AnthropicProvider` fica implementada no contrato (Seção 1) mas não é ativada agora** — não há orçamento de API comprometido para o desenvolvimento neste momento. Quando isso mudar, é só configurar a chave (Seção abaixo) e trocar o provedor — nenhuma linha de jogo muda (PDF 03 §8).
- A chave de API, se um dia usada, fica **fora do controle de versão** (PDF 03 §10); o jogador escolhe o provedor na config.

---

### 6. A estratégia de treinar uma rede (do jeito que dá certo)

O instinto de custo/velocidade está certo — mas **fase 3**, não agora:

1. **Fase 1 — Heurística + Ollama local.** Funciona hoje, sem ML nenhum, sem custo de API.
2. **Fase 2 — Ajuste dos modelos locais** (tamanhos/prompts) conforme o hardware alvo.
3. **Fase 3 — Destilação.** Com o jogo rodando, grave milhares de pares **(briefing → decisão)** que o modelo (local ou, futuramente, via API) produz. Treine uma **rede pequena pra imitar** o LLM nas decisões repetitivas.

**Por que imitação e não RL do zero:**

| | Aprendizado por imitação (destilação) | RL do zero (estilo AlphaStar) |
|---|---|---|
| Precisa de recompensa? | Não (copia o LLM) | Sim — e nosso jogo **não tem "vencer" fixo** |
| Custo/infra | Baixo | Altíssimo (clusters de GPU) |
| Captura personalidade? | Sim (imita o estilo) | Difícil |
| Risco ao projeto | Baixo | Alto |

RL do zero também produziria líderes *ótimos* — o oposto da "burrice" que dá alma ao jogo.

---

### 7. O pipeline de dados (passivo)

Cada decisão de LLM durante o jogo normal é **logada** (briefing + decisão). Jogar = montar o dataset de treino sozinho. Quando houver dados suficientes, a Fase 3 destila — sem coleta extra.

---

### 8. Conexões

- **13 (Inteligência)** define o `Briefing` e a `Decision` que estes provedores consomem/produzem.
- **03 (Arquitetura)** hospeda o `HTTPRequest`/fila assíncrona e a config de segredos.
- **20 (Roadmap)** posiciona as Fases 1→3 no tempo.
- **26 (Modos de IA)** reafirma que o jogo é 100% jogável sem qualquer LLM.

---

*Fim do Documento 14 / 21.*
