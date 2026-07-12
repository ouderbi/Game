# PROJETO NOÓS
## Documento 25 / 28 — IA Heurística (Utility AI)

> **Camada:** Inteligência · **Status:** rascunho para revisão · **Série:** 28 documentos
> **Depende de:** 11 (Líderes), 13 (Decisão) · **Alimenta:** 14 (Escada de decisão)

O cérebro heurístico que move a **maioria** dos líderes — e o fallback **sempre disponível** quando não há LLM. Implementa a `HeuristicProvider`. A técnica escolhida é **Utility AI** (IA por utilidade/pontuação), que é como Civ e a Paradox fazem IA de verdade — não rede neural, não LLM.

---

### 1. Como funciona

Cada ação possível recebe uma **nota** calculada a partir do estado do mundo; o líder escolhe a de maior nota (ou sorteia entre as melhores). A nota vem de **considerações** — curvas que transformam estado em desejabilidade.

```
nota(ação) = Σ  consideração_i(estado) × peso_i(personalidade)   + ruído
escolha = argmax(nota)   # ou sorteio ponderado entre as melhores
```

Exemplos de consideração: "quanto menor o tesouro, mais desejável subir imposto"; "quanto mais forte o vizinho hostil, mais desejável buscar aliança".

---

### 2. Por que é a melhor escolha pro Noós

- **Pesa muitas variáveis ao mesmo tempo** (economia × militar × diplomacia) — a complexidade "tipo mundo real" que o projeto quer.
- **Personalidade = pesos.** Os `personality_traits` (PDF 11) **são** os pesos das considerações. As 45 formas de governo ganham comportamento distinto **sem código novo** — só números diferentes. Pilar 3 de graça.
- **Escala barata** pra dezenas de líderes, rodando a cada tick.
- **Troca limpa com o LLM:** produz o **mesmo objeto `Decision`** (PDF 13), do mesmo cardápio de ações. `HeuristicProvider` e `AnthropicProvider` ficam intercambiáveis — e **misturáveis** (heurística na maioria, LLM nos rivais que importam).

---

### 3. A "burrice" embutida e controlável  ★

A irracionalidade humana (PDF 07) entra aqui de forma natural:

- **Ruído** nas notas → o líder às vezes erra.
- **Informação imperfeita** → decide com dados incompletos.
- **Vieses de personalidade** distorcem (o paranoico superestima ameaças).

Isso **é** a burrice — e é a alavanca de dificuldade (PDF 02 §8): mais ruído = rivais mais fáceis.

---

### 4. As camadas de apoio

A Utility AI é o cérebro *estratégico* (decide "o quê"). Estas executam:

- **Árvore de comportamento / FSM** — sequencia o "como" do que a utility decidiu.
- **Mapas de influência** — pras decisões territoriais/militares (onde atacar/defender); a utility lê deles pra pontuar ações no mapa.
- **GOAP** (planejamento por objetivo) — evolução **futura**, pra encadear planos de vários passos. Mais complexo; depois.

---

### 5. Resumo da arquitetura

**Núcleo: Utility AI.** Execução: BT/FSM. Território: mapas de influência. Evolução futura: GOAP. O LLM é a camada de cima, **opcional**, só onde alma e voz fazem diferença.

---

### 6. Conexões

- **14** posiciona a `HeuristicProvider` como nível 1 da escada (sempre disponível).
- **11** fornece os pesos (personalidade) das considerações.
- **13** define o `Decision` que tanto a utility quanto o LLM produzem.

---

*Fim do Documento 25 / 28.*
