# PROJETO NOÓS
## Documento 10 / 21 — Formas de Governo & Não-Governo

> **Camada:** Governança · **Status:** rascunho para revisão · **Série:** 23 documentos
> **Depende de:** 06 (Dados), 09 (Sociedade) · **Alimenta:** 11 (Líderes), 13 (Inteligência), 17 (Estabilidade), 21 (Construções/Políticas), 23 (Tecnologia/Particularidades)
> **Realiza:** o Pilar 3 (variedade civilizacional radical).

A taxonomia das polities — governos *e* não-governos. É o que dá ao jogo dezenas de "jeitos de ser uma civilização", cada um moldando como a IA do líder pensa.

---

### 1. O schema de uma forma de governo

Cada tipo é uma estrutura de atributos que a simulação **e** o líder-LLM consomem:

```
GovernmentType
├── id
├── era_available        # era que destrava (PDF 05)
├── power_concentration  # 0–1: difuso ↔ absoluto
├── decision_speed       # quão rápido decide
├── legitimacy_source    # tradição|carisma|legal|divino|força|riqueza|voto|nenhum
├── succession_rule      # hereditário|eleição|nomeação|golpe|seleção_IA|nenhum
├── corruption_tendency  # base de corrupção (PDF 08)
├── militarism           # propensão à guerra
├── economic_model       # livre|misto|estatal|comando|saque
├── civil_liberties      # 0–1: repressivo ↔ livre
├── stability_baseline   # estabilidade de partida
├── leader_archetype     # molda a personalidade do líder-LLM (PDF 11/13)
├── default_llm_tier     # motor padrão de decisão (PDF 14)
├── available_policies[] # alavancas liberadas (PDF 21)
└── tech_profile         # viés de pesquisa, techs exclusivas, particularidades (PDF 23)
```

Cada governo também tem **particularidades** — vieses tecnológicos, tecnologias e ações exclusivas, bônus e penalidades próprias — detalhadas no **PDF 23**. É o que dá identidade real a cada forma de governo.

---

### 2. Perfis de exemplo (subconjunto detalhado)

| Tipo | Poder | Legitimidade | Sucessão | Corrupção | Militarismo | Liberdades |
|---|---|---|---|---|---|---|
| Tribo | baixo | tradição | nenhum | baixa | média | alta |
| Cidade-Estado | médio | legal | eleição | média | média | média |
| Império despótico | alto | força | hereditário | alta | alta | baixa |
| Teocracia | alto | divino | nomeação | média | média | baixa |
| República democrática | baixo | voto | eleição | baixa | baixa | alta |
| Ditadura militar | alto | força | golpe | alta | alta | baixa |
| Cleptocracia | alto | riqueza | nomeação | **máxima** | baixa | baixa |
| Tecnocracia | médio | legal | nomeação | baixa | baixa | média |
| Corporatocracia | alto | riqueza | nomeação | alta | média | baixa |
| IA-governança | variável | legal | seleção_IA | mínima | variável | variável |

Os demais tipos (Seção 3) seguem o **mesmo schema** — o Claude Code preenche cada um a partir dele.

---

### 3. O catálogo (dezenas de tipos)

**Não-governo / pré-estatal:** anarquia, bando nômade, tribo, confederação tribal, chefatura, teocracia xamânica, estado falido, zona autônoma temporária.

**Antigos:** cidade-estado, reino, império, despotismo, oligarquia, tirania, gerontocracia, teocracia, monarquia eletiva.

**Clássicos/Medievais:** feudalismo, monarquia absolutista, califado, principado mercante, república aristocrática.

**Modernos:** monarquia constitucional, república democrática, república parlamentar, federação, confederação, ditadura militar, junta, Estado de partido único, fascismo, socialismo de Estado, populismo autoritário, cleptocracia, plutocracia, anarcossindicalismo.

**Tardios / Sci-fi:** tecnocracia, corporatocracia / megacorp, IA-governança, mente-colmeia, autocracia pós-humana, democracia direta digital, sindicato pirata, federação galáctica, anarcocapitalismo, ecotopia.

(≈ 45 tipos; a lista é expansível — qualquer novo tipo é só um preenchimento do schema.)

---

### 4. Como o governo molda o líder-LLM

O `leader_archetype` e os atributos viram **contexto e restrição** no prompt do líder (detalhe no PDF 13):

- Um **déspota** num império de força é instruído a valorizar lealdade e controle, e tem liberdade pra ações brutais.
- Uma **república democrática** é instruída a buscar consenso e responde a eleições.
- Uma **IA-governança** decide com frieza otimizadora — e pode ser perturbadora justamente por isso.

A forma de governo também **limita** o que o líder pode fazer (um governo difuso não declara guerra sozinho num clique).

---

### 5. Transições de governo

Uma polity **muda de tipo** por eventos (PDF 16) e por estabilidade (PDF 17): golpe → junta; revolução → república ou Estado de partido único; reforma → constitucional; colapso → estado falido. A `succession_rule` define a via normal; crises abrem as anormais.

---

### 6. Liberdade total (inclusive a pior escolha)

Nada impede o jogador de adotar um governo **inadequado** à sua situação (uma cleptocracia numa civilização que precisava de ciência). O jogo não adverte — as consequências (corrupção, atraso, revolta) simplesmente acontecem. É o princípio do PDF 01 §7 aplicado à governança.

---

### 7. Conexões

- **11 (Líderes & Facções)** detalha arquétipos e quem disputa o poder.
- **13 (Inteligência)** transforma o tipo de governo em personalidade e restrições do líder.
- **17 (Estabilidade)** dispara as transições da Seção 5.
- **21 (Construções/Políticas)** lista as `available_policies` de cada governo.
- **23 (Tecnologia & Particularidades)** define a árvore e os traços exclusivos de cada governo.

---

*Fim do Documento 10 / 21.*
