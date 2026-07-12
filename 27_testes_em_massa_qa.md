# PROJETO NOÓS
## Documento 27 / 28 — Testes em Massa & QA

> **Camada:** Orquestração · **Status:** rascunho para revisão · **Série:** 28 documentos
> **Depende de:** 03 (Render desacoplado, determinismo), 14 (Provedor trocável) · **Alimenta:** 14 (dados de destilação)

Como testar o jogo em escala — milhares de partidas, séculos de jogo em segundos. Possível porque o jogo já foi **projetado** pra isso. Implementa `tests/mass_sim.gd`.

---

### 1. Rodar sem desenhar (headless)

Como `render/` é separado de `core/` (PDF 03), roda-se **só a simulação**, sem janela, na velocidade máxima da CPU. "Horas jogadas" viram **segundos reais** — séculos num piscar. É o alicerce de tudo.

---

### 2. Determinismo + sementes = superpoder

Tick fixo + semente → toda partida é **reproduzível**. Com isso:

- **Milhares de partidas** com sementes diferentes (cobre milhares de mundos).
- **Reprodução exata de bug:** semente + nº do tick refazem o bug. Sem isso, bug de simulação vira fantasma.
- **Paralelismo:** partidas independentes rodam em paralelo (uma semente por núcleo).

---

### 3. Trocar o cérebro nos testes  ★

Testar em massa com o **LLM de verdade é inviável** (custo e latência). Então use a **heurística** (ou modelo local), via a camada do PDF 14. Testa-se a **simulação** em escala com cérebros baratos; o **comportamento do LLM** se testa à parte, em poucas partidas dirigidas.

---

### 4. O que medir/verificar

| Categoria | Exemplos |
|---|---|
| **Quebras** | N partidas × M séculos sem exceção? (robustez) |
| **Invariantes** | população ≥ 0, contas do tesouro fecham, nada de NaN, medidores em [0,1], nenhum id órfão |
| **Balanceamento** | taxa de sobrevivência por governo, tempo médio até colapso, variedade entre sementes |
| **Saúde da emergência** | coisas interessantes acontecem? (nem estático, nem sempre explodindo) |
| **Desempenho** | ticks/segundo; memória ao longo do tempo (vazamentos?) |

Um sim onde **nada emerge** é tão quebrado quanto um que sempre explode.

---

### 5. Bônus: alimenta a destilação

Cada partida headless **loga** os pares (briefing → decisão). Rodar testes em massa monta, **de graça**, o dataset da Fase 3 (PDF 14). Dois coelhos numa cajadada.

---

### 6. O harness

`tests/mass_sim.gd`: recebe um intervalo de sementes → roda cada uma headless com heurística na velocidade máxima por X séculos → checa invariantes a cada tick → registra métricas → reporta falhas com **semente + tick**.

Mais: **testes de soak** (uma partida por milhões de ticks, pra pegar vazamentos lentos) e **de regressão** (um conjunto fixo de sementes rodado a cada mudança de código — se o resultado muda sem querer, pegou um regresso).

---

### 7. Conexões

- **03** fornece o headless e o determinismo.
- **14** fornece o cérebro barato pros testes e recebe os dados de destilação.

---

*Fim do Documento 27 / 28.*
