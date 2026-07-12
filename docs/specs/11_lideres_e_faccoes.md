# PROJETO LEVIATÃ
## Documento 11 / 21 — Líderes & Facções

> **Camada:** Governança · **Status:** rascunho para revisão · **Série:** 21 documentos
> **Depende de:** 06 (Dados), 10 (Governo) · **Alimenta:** 13 (Inteligência), 16–17 (Eventos/Estabilidade)

A mente de cada polity (o líder) e os grupos que disputam o poder por baixo dela (as facções). É daqui que nascem golpes, lealdades e crises de sucessão.

---

### 1. O modelo do líder

```
Leader
├── archetype            # preset de personalidade
├── personality_traits   # agressão, paranoia, ambição, competência,
│                        #   ideologia, corruptibilidade, carisma  (0–1)
├── goals[]              # o que esse líder quer
├── memory_ref           # histórico do que viveu (PDF 13)
└── brain_tier           # motor de decisão (PDF 14)
```

A personalidade vem do **arquétipo** + do **tipo de governo** (PDF 10). Líderes **são falíveis** de propósito: traços e modelos baratos produzem erros — alma, não bug.

---

### 2. Arquétipos de líder

Conquistador, reformador, déspota, tecnocrata, populista, teocrata, pragmático, fanático, mercador, libertador, paranoico, visionário.

Cada um é um preset de `personality_traits` + tendências de objetivo. O mesmo evento gera respostas opostas em arquétipos diferentes — é o coração do Pilar 1.

---

### 3. Facções (quem disputa o poder)

Grupos sub-estatais dentro de uma polity:

| Facção | Agenda típica |
|---|---|
| Militares | poder, guerra, orçamento |
| Clero | influência, ortodoxia |
| Oligarcas / elite econômica | riqueza, baixa tributação |
| Povo / massas | bem-estar, pão e segurança |
| Burocracia | estabilidade, autopreservação |
| Corporações | lucro, desregulação |
| Nobreza | privilégio, tradição |
| IA / tecnocratas | otimização, controle de dados |

Cada facção tem **poder** e **lealdade** (PDF 06).

---

### 4. Dinâmica de facções

- As decisões do líder **agradam** umas facções e **irritam** outras (subir imposto agrada burocracia, irrita oligarcas).
- Lealdade muda conforme isso.
- **Baixa lealdade + alto poder = risco de golpe** (a equação vive no PDF 17).
- O jogador precisa **equilibrar** facções — ou escolher conscientemente sacrificar uma.

---

### 5. Liderança e sucessão

- O líder muda por **morte**, pela `succession_rule` do governo (PDF 10), por **golpe** ou por **eleição**.
- **Crise de sucessão:** quando não há herdeiro/regra clara → disputa, instabilidade, possível guerra civil.
- Um novo líder traz **nova personalidade** (e possivelmente novo tier de modelo) — a história muda de tom.

---

### 6. Liberdade total (inclusive a pior escolha)

Nada impede o jogador de **alienar todas as facções ao mesmo tempo**. O jogo não avisa — o golpe ou a guerra civil vêm naturalmente. Princípio do PDF 01 §7.

---

### 7. Conexões

- **13 (Inteligência)** implementa o cérebro do líder a partir de `archetype` + `personality_traits`.
- **17 (Estabilidade)** converte lealdade/poder de facção em golpes e revoluções.
- **12 (Diplomacia)** usa a personalidade do líder na postura externa.

---

*Fim do Documento 11 / 21.*
