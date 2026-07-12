# PROJETO LEVIATÃ
## Documento 13 / 21 — Camada de Inteligência dos Líderes

> **Camada:** Inteligência · **Status:** rascunho para revisão · **Série:** 21 documentos
> **Depende de:** 03 (Arquitetura), 06 (Dados), 10–12 (Governança) · **Alimenta:** 14 (Provedores/Custo)
> **Realiza:** o Pilar 1 (adversários que pensam de verdade).

Como um líder pensa. Implementa `brains/`. Regra soberana: **o LLM propõe; a simulação valida e aplica.** A engine é a autoridade final — nunca confia cego na saída do modelo.

---

### 1. O ciclo de decisão (cérebro/corpo)

```
estado do mundo → monta BRIEFING → Decider.decide() → DECISÃO (JSON)
      → engine VALIDA → aplica efeitos no WorldState
```

- **Heurística:** resolve na hora.
- **LLM:** resolve assíncrono (pela fila do PDF 03); a decisão entra um ou mais ticks depois.

---

### 2. O Briefing (entrada do líder)

Montado a cada decisão, **enxuto de propósito** (custo). Nunca dados crus dos milhões — só resumos agregados:

```
Briefing
├── eu          # governo, arquétipo, personalidade, objetivos
├── nação       # resumo: economia, estabilidade, legitimidade, era, facções
├── eventos     # acontecimentos recentes relevantes
├── relações    # opiniões, tratados, ameaças (PDF 12)
├── memória     # recordações recuperadas (rancores, alianças)
├── ações       # o que posso fazer agora (limitado por governo + era)
└── pressões    # pressões atuais (PDF 15)
```

A parte estável (regras, personalidade) é **cacheada** entre chamadas (ver PDF 14).

---

### 3. O schema da Decisão (saída estruturada)

O líder **deve** responder em JSON validável:

```json
{
  "thoughts": "Estou cercado e em desvantagem. Preciso de aliados rápido.",
  "actions": [
    {"type": "propose_alliance", "target": 7},
    {"type": "raise_taxes", "amount": 0.05},
    {"type": "shift_research", "branch": "militar"}
  ],
  "diplomacy": [
    {"to": 7, "message": "Temos um inimigo em comum. Unamo-nos."}
  ],
  "memory_update": ["Polity 3 ameaçou minhas fronteiras no inverno"],
  "posture": "defensivo"
}
```

- `thoughts` — raciocínio interno (vira "vida" e log).
- `actions` — o que executar (a engine valida cada uma).
- `diplomacy` — a **voz** do líder (mensagens a outros).
- `memory_update` — o que guardar pra depois.
- `posture` — humor estratégico atual.

---

### 4. Condicionamento de personalidade

Governo (PDF 10) + arquétipo + traços (PDF 11) viram o **system prompt** do líder. Esboço:

- *Déspota paranoico:* "Você governa pela força. Valoriza lealdade acima de tudo e desconfia de aliados. Ações brutais são aceitáveis se garantem controle."
- *República mercante:* "Você responde ao povo e às eleições. Prefere comércio e alianças à guerra; precisa de consenso pra grandes decisões."

A mesma situação gera decisões opostas — é isso que faz cada partida viva.

---

### 5. Memória e reflexão

Inspirado em *Generative Agents* (Stanford):

- **Fluxo de memória** por líder: eventos, decisões, rancores, alianças.
- **Recuperação:** só as memórias relevantes ao briefing atual entram (RAG-lite), pra não estourar o contexto.
- **Reflexão:** periodicamente o sistema resume memórias antigas em sínteses ("o Reino de Vael me traiu duas vezes"), mantendo a memória **limitada** e barata.

---

### 6. Cadência, paralelismo e fallback

- Líderes pensam **a cada N ticks** ou quando um evento os obriga.
- Pensam **em paralelo** (pool de threads, PDF 03).
- Se o provedor atrasar/cair, o líder usa **heurística** naquele turno — o jogo nunca trava.

---

### 7. Vivendo dentro dos limites do Opus 4.8

O Opus 4.8 oferece **1M tokens de contexto** e **128k de saída** — folga enorme pro nosso uso. As restrições reais que respeitamos:

- **Briefing curto** (poucos milhares de tokens): o gargalo é custo, não capacidade.
- **Cache de prompt** da parte estável (mínimo de 1.024 tokens no 4.8; leitura ≈ 10% do custo de entrada).
- **Cadência esparsa + paralelismo** pra caber nos limites de taxa.
- **Saída pequena**: a Decisão JSON é curta; 128k é teto de sobra.

(Detalhe de custo e tiers no PDF 14.)

---

### 8. Validação e segurança

- A Decisão é **parseada e validada**: JSON malformado ou ação ilegal → rejeita e usa fallback.
- A engine **nunca** aplica algo que viole as regras (um governo difuso não "declara guerra" sozinho só porque o LLM escreveu isso).
- Toda ação aplicada passa pelo mesmo pipeline do tick (PDF 03 §5).

---

### 9. Conexões

- **14 (Provedores/Custo)** implementa o `Decider` em cada motor e o tiering.
- **10–12** fornecem governo, personalidade e relações ao briefing.
- **15–17** geram os eventos e pressões que o líder lê e responde.

---

*Fim do Documento 13 / 21.*
