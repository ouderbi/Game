# PROJETO LEVIATÃ
## Documento 20 / 21 — Roadmap, Marcos & Convenções pro Claude Code

> **Camada:** Interface & Experiência · **Status:** rascunho para revisão · **Série:** 21 documentos
> **Depende de:** todos · **Orquestra:** a construção do projeto inteiro

O documento mais operacional. Define **a ordem de construção** e **como alimentar o Claude Code** — é o que transforma os outros 20 docs em código que existe.

---

### 1. A fatia vertical (o primeiro alvo)

A menor versão jogável de ponta a ponta. **Tudo o mais é expansão sobre ela.** Contém:

- Um **mundo pequeno** gerado (um continente, poucas regiões).
- **4–6 polities** com líderes (a maioria heurística; 1–2 com LLM).
- **Loop central:** tick, população com necessidades básicas, economia simples, alguns tipos de governo, medidores de estabilidade/legitimidade.
- **1–2 eventos** funcionando (ex.: fome + golpe) pra **provar a emergência**.
- **Render mínimo** (mapa de tiles + fronteiras) e **UI mínima** (painel da nação + pausa).
- **Meta:** algumas polities vivem alguns turnos e produzem **um evento emergente** sozinhas.

---

### 2. Os marcos (ordem dirigida por dependência)

| Marco | Entrega | Docs |
|---|---|---|
| **M0 — Esqueleto** | estrutura de pastas, loop de tick, render de mapa, pausa/velocidade | 03, 04, 18 |
| **M1 — População viva** | arrays de população, necessidades, economia básica, demografia | 06, 07, 08 |
| **M2 — Polities & governo** | polities, alguns governos, líderes (heurística), medidores | 10, 11, 17 |
| **M3 — Primeira emergência** | sistema de pressão + 1–2 eventos, cadeia de feedback visível | 15, 16, 17 |
| **M4 — A mente** | cérebro LLM dos líderes pivotais, camada de provedor, diplomacia | 12, 13, 14 |
| **M5 — Fatia vertical** | painéis de UI, save/load, base de eras, jogável de ponta a ponta | 05, 19, 06 |
| **Pós-fatia** | mais governos/eventos/eras, escalas regional/individual, destilação (fase 3), construções/políticas completas | 21, todos |

**Regra de ouro:** o **corpo** antes do **cérebro** (a simulação funciona sem LLM primeiro); a **emergência provada** antes de **escalar**.

---

### 3. Acordo de trabalho com o Claude Code

- **Alimente os `.md` desta suíte** como especificação/contexto.
- Siga a **estrutura de módulos** do PDF 03 — um módulo por vez.
- Construa **por marco**; cada módulo tem um "**pronto**" (Seção 4) antes do próximo.
- A **engine é a autoridade**; o LLM propõe e é validado (PDF 13).
- **Determinismo:** tick fixo + semente → testável e reproduzível.
- **Incremental:** rodável em cada marco, nunca um salto gigante.
- **Segredos/config:** chave de API fora do código (PDF 03 §10).
- Crie um **`CLAUDE.md`** na raiz do repositório resumindo estas convenções.

---

### 4. "Pronto" por módulo (checklist)

- [ ] Roda sem erro e se integra ao loop.
- [ ] Tem teste básico (determinístico).
- [ ] Respeita os schemas do PDF 06.
- [ ] Escopo **fechado** — nada meio-feito acumulado.
- [ ] Documentado o suficiente pro próximo módulo usar.

---

### 5. O que faz "dar certo"

Entregar a **fatia vertical primeiro**, expandir só depois, e **fechar o escopo de cada módulo**. É o oposto de tentar tudo de uma vez — e o que separa este projeto dos que morrem no meio.

---

### 6. Conexões

Este documento referencia e ordena **todos** os outros. O PDF 01 define o destino; este define o caminho.

---

*Fim do Documento 20 / 21.*
