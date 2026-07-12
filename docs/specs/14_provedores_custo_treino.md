# PROJETO LEVIATÃ
## Documento 14 / 21 — Provedores de LLM, Custo & Treino/Destilação

> **Camada:** Inteligência · **Status:** rascunho para revisão · **Série:** 21 documentos
> **Depende de:** 03 (Arquitetura), 13 (Inteligência) · **Alimenta:** 20 (Roadmap)

A camada que torna o "cérebro" **trocável**, controla o **custo** e abriga a estratégia futura de **treinar uma rede** (do jeito que dá certo). Implementa `providers/`.

---

### 1. A interface de provedor (contrato)

Todo motor de decisão implementa a mesma interface — trocar de motor **nunca** reescreve o jogo:

```python
class Provider:
    def decide(self, briefing: Briefing) -> Decision: ...

# Implementações:
#   HeuristicProvider   → regras; grátis; instantâneo; SEMPRE disponível (fallback)
#   AnthropicProvider   → Claude via API; esperto + voz; custa; latência de rede
#   OllamaProvider      → modelo aberto local; grátis; rápido; offline
#   OllamaCloudProvider → modelo aberto na nuvem; varia
#   DistilledProvider   → rede pequena destilada; grátis; rápido (FASE 3)
```

---

### 2. Tiering de modelos (qual cérebro para qual líder)

| Importância do líder | Motor sugerido | Por quê |
|---|---|---|
| Potência pivotal | Opus 4.8 | mais esperto + melhor voz |
| Potência média | Sonnet 4.6 / Haiku 4.5 ou local | equilíbrio custo/qualidade |
| Estado menor / fundo | modelo local pequeno ou heurística | grátis e rápido |

A **dificuldade** do jogo escala por aqui: rivais em tiers melhores = adversários mais espertos (PDF 02 §8).

---

### 3. Os limites e preços do Opus 4.8 (referência)

- **Contexto:** 1M tokens por padrão. **Saída:** até 128k tokens.
- **Preço:** US$5 / milhão de tokens de entrada, US$25 / milhão de saída (preço de contexto longo acima de 200k de entrada).
- **Cache de prompt:** mínimo de 1.024 tokens; leitura de cache ≈ 10% do custo de entrada.
- **Modo rápido** (preview): ~2,5x mais veloz, a US$10/US$50.

Outros tiers, pra referência: Sonnet 4.6 US$3/US$15, Haiku 4.5 US$1/US$5.

---

### 4. Disciplina de custo (alavancas concretas)

- **Heurística/local como padrão**; Opus só pros poucos líderes pivotais.
- **Cadência esparsa**: pensar por *turno*, não por *tick*.
- **Cache de prompt** da parte estável do briefing (corta a maior parte do custo de entrada).
- **Batch API** (assíncrono, ~50% mais barato) para decisões não-urgentes.
- **Teto de gasto** configurável + **fallback heurístico** se estourar.

---

### 5. A realidade de cobrança (importante)

- O jogo, ao chamar a API em tempo de execução, usa **créditos de API** (pré-pagos no Console) — **cobrados à parte da assinatura Max**. O Max cobre você *construindo* o jogo; não cobre o jogo *rodando*.
- **Modelo local (Ollama)** = **custo zero por token**, rodando na máquina do jogador. É o caminho pra escala sem medo da conta.
- A chave de API fica **fora do código** (PDF 03 §10); o jogador escolhe o provedor na config.

---

### 6. A estratégia de treinar uma rede (do jeito que dá certo)

O instinto de custo/velocidade está certo — mas **fase 3**, não agora:

1. **Fase 1 — Heurística + LLM.** Funciona hoje, sem ML nenhum.
2. **Fase 2 — Trocar LLM por modelo local pequeno** (Ollama). Custo/velocidade sem treinar nada.
3. **Fase 3 — Destilação.** Com o jogo rodando, grave milhares de pares **(briefing → decisão)** que o LLM produz. Treine uma **rede pequena pra imitar** o LLM nas decisões repetitivas.

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
- **03 (Arquitetura)** hospeda a fila assíncrona e a config de segredos.
- **20 (Roadmap)** posiciona as Fases 1→3 no tempo.

---

*Fim do Documento 14 / 21.*
