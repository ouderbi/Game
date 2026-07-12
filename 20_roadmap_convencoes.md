# PROJETO NOÓS
## Documento 20 / 21 — Roadmap, Marcos & Convenções pro Claude Code

> **Camada:** Interface & Experiência · **Status:** rascunho para revisão · **Série:** 21 documentos
> **Depende de:** todos · **Orquestra:** a construção do projeto inteiro

O documento mais operacional. Define **a ordem de construção** e **como alimentar o Claude Code** — é o que transforma os outros 20 docs em código que existe.

---

### 1. Escopo do projeto  ✅ decidido (revisado — escopo grande desde o início)

Diferente da ideia original de "fatia vertical pequena", o projeto **mira o escopo completo desde a arquitetura**: 12 eras (Pedra → Intergaláctica), 4 lentes de mapa (Cidade/País/Planeta/Galáxia — PDF 24), dezenas de formas de governo, modo sandbox com cheats. Isso é uma escolha deliberada, com um risco conhecido (PDF 28 §3: escopo é o assassino nº 1 de projeto indie) — mitigado assim:

- **Arquitetura grande, construção incremental.** O código já nasce estruturado pra suportar tudo (schemas, interfaces, as 4 lentes, os 12 slots de era) — mas cada marco entrega algo **rodável de ponta a ponta**, nunca um salto gigante sem nada funcionando no meio.
- **Godot 4** (PDF 03) sustenta essa ambição: multiplataforma de graça, exporta fácil, headless pra testar sem tela.
- **Ritmo acelerado**, priorizando ter o loop central + emergência provada rodando o quanto antes, e expandindo em largura (mais eras, mais governos, mais lentes) a partir daí.

---

### 2. Os marcos (ordem dirigida por dependência)

| Marco | Entrega | Docs |
|---|---|---|
| **M0 — Esqueleto Godot** | projeto Godot, estrutura de pastas (PDF 03 §2), loop de tick determinístico, render de mapa (lente País), pausa/velocidade | 03, 04, 18, 24 |
| **M1 — População viva** | população agregada por região, necessidades, economia básica, demografia | 06, 07, 08 |
| **M2 — Polities & governo** | polities, catálogo inicial de governos, líderes (heurística/Utility AI), medidores de estabilidade/legitimidade | 10, 11, 17, 25 |
| **M3 — Emergência aberta** | sistema de pressão + catálogo de eventos ativo; **nenhum evento é garantido** — o que acontece é resultado das escolhas do jogador e dos líderes-NPC, podendo até não acontecer nada por um bom tempo | 15, 16, 17 |
| **M4 — A mente** | cérebro Ollama local dos líderes pivotais (1 jogador + 3 líderes-NPC isolados no início — PDF 04 §7, 11), camada de provedor trocável, diplomacia | 12, 13, 14, 26 |
| **M5 — Ciclo completo Era 1–8** | painéis de UI (PT+EN), save/load, eras Pedra→Alta Tecnologia jogáveis, sandbox/cheats, lente Cidade isométrica | 05, 19, 06, 21 |
| **M6 — Escala espacial** | eras Espacial→Intergaláctica, lentes Planeta e Galáxia, isolamento/primeiro-contato completo | 04, 05, 24 |
| **Pós-M6** | catálogo completo de ~45 governos, testes em massa, destilação (fase 3), polimento, lançamento | 21, 23, 27, 28 |

**Regra de ouro (mantida):** o **corpo** antes do **cérebro** (a simulação funciona sem LLM primeiro — PDF 26); a **emergência provada** antes de **escalar** conteúdo.

---

### 3. Acordo de trabalho com o Claude Code

- **Alimente os `.md` desta suíte** como especificação/contexto.
- Siga a **estrutura de módulos** do PDF 03 — um módulo por vez.
- Construa **por marco**; cada módulo tem um "**pronto**" (Seção 4) antes do próximo.
- A **engine é a autoridade**; o LLM propõe e é validado (PDF 13).
- **Determinismo:** tick fixo + semente → testável e reproduzível.
- **Incremental mesmo com escopo grande:** a arquitetura suporta tudo desde o início, mas cada marco entrega algo rodável — nunca um salto gigante.
- **Idiomas:** identificadores e comentários de código em **português**; textos de jogo (UI, falas dos líderes) com suporte a **PT-BR e EN** desde o M5 (PDF 19).
- **Segredos/config:** chave de API fora do controle de versão (PDF 03 §10). Hoje o provedor padrão é o **Ollama local** — a `AnthropicProvider` existe no contrato, mas fica opt-in/futura até haver orçamento definido (PDF 14).
- Crie um **`CLAUDE.md`** na raiz do repositório resumindo estas convenções.

---

### 4. "Pronto" por módulo (checklist)

- [ ] Roda sem erro e se integra ao loop.
- [ ] Tem teste básico (determinístico, roda headless — PDF 03 §11).
- [ ] Respeita os schemas do PDF 06.
- [ ] Escopo **fechado** — nada meio-feito acumulado.
- [ ] Documentado o suficiente pro próximo módulo usar.

---

### 5. O que faz "dar certo"

Entregar o **loop central + emergência provada primeiro** (M0–M4), depois expandir em largura (mais eras, mais governos, mais lentes) sobre uma arquitetura que já foi desenhada pro tamanho final — e **fechar o escopo de cada módulo** antes de abrir o próximo. Nunca um módulo "meio-feito" acumulado.

---

### 6. Conexões

Este documento referencia e ordena **todos** os outros. O PDF 01 define o destino; este define o caminho.

---

*Fim do Documento 20 / 21.*
