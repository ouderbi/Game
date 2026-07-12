# PROJETO NOÓS
## Documento 06 / 20 — Modelo de Dados

> **Camada:** Modelo de Mundo · **Status:** rascunho para revisão · **Série:** 20 documentos
> **Depende de:** 03 (Arquitetura), 04 (Mundo), 05 (Eras) · **Alimenta:** praticamente todos os módulos

A espinha que todos os sistemas leem e escrevem. Junto com o PDF 03, é o documento que o Claude Code mais consulta. Tudo aqui é *schema* — os números e regras vivem nos docs específicos.

---

### 1. O contêiner: `WorldState`

Tudo que é salvo vive sob um único objeto:

```
WorldState
├── meta          # semente, tick atual, versão do schema, era global
├── map           # tiles, regiões, biomas, recursos
├── population    # arrays ECS-lite (os milhões)
├── polities      # dict[id -> Polity]
├── leaders       # dict[id -> Leader]
├── factions      # dict[id -> Faction]
├── relations     # relações entre polities
├── events_active # eventos em curso
└── pressures     # acumuladores de pressão (por tipo/escopo)
```

---

### 2. Schemas das entidades de alto nível (OOP)

**Region**
`id, tiles[], biome, resources[], owner_polity_id, population_slice, development, infrastructure`

**Polity**
`id, name, government_type_id, leader_id, region_ids[], treasury, tech_state, stability, legitimacy, corruption, faction_ids[], era`

**Leader**
`id, archetype, personality_traits{}, memory_ref, brain_tier, goals[]`

**Faction**
`id, type (militar|clero|oligarcas|povo|corporação|IA…), power, loyalty, polity_id`

**Relation** (entre duas polities)
`polity_a, polity_b, opinion, treaties[], status (paz|guerra|aliança)`

**EventActive**
`id, type, severity, scope, started_tick, resolution_state`

**Pressure**
`type, scope (global|polity|região), value (0–1), sources[]`

---

### 3. População (agregada por região — princípio de ouro do PDF 24)

A população **não** é uma lista de milhões de indivíduos. É um conjunto de **arrays agregados por região** (`PackedArrays` do Godot, PDF 03 §6), um índice por região, não por cidadão:

```
pop_total[]        humor_médio[]      lealdade_média[]
riqueza_dist[]      ocupação_dist[]    saúde_média[]
ideologia_dist[]    traços_dist[]      (por região)
```

`*_dist` guarda **distribuições agregadas** (ex.: fração pró-social, fração panicada, curva de riqueza) — é isso que sustenta a "burrice"/altruísmo emergentes do PDF 07 sem precisar simular cada pessoa. Operações são vetorizadas por região (um passo de simulação processa o array inteiro de uma vez, mesmo em mapas com milhares de regiões — Planeta/Galáxia, PDF 24). Indivíduos "importantes" (líderes, heróis, figuras notáveis) podem ser promovidos a entidades próprias quando necessário (LOD — ver PDF 03 §9) — exceção, não a regra.

---

### 4. IDs e referências

- Toda entidade tem um **id inteiro**.
- Referências são **por id**, nunca por ponteiro de objeto — isso mantém o save/load simples e evita ciclos.
- Ex.: `Polity.leader_id` aponta pro `Leader`, não guarda o objeto.

---

### 5. Versionamento e o que é salvo

- `meta.schema_version` permite **migrar** saves antigos quando o modelo mudar.
- **Persistido:** tudo no `WorldState`.
- **Derivado (não salvo):** caches recomputados a cada tick (ex.: índices espaciais, somatórios). Distinguir os dois evita saves inchados.

---

### 6. Exemplo concreto (uma Polity em JSON)

```json
{
  "id": 12,
  "name": "Reino de Vael",
  "government_type_id": "monarquia_feudal",
  "leader_id": 12,
  "region_ids": [4, 5, 9],
  "treasury": 1840,
  "tech_state": {"era": "medieval", "researched": ["arado", "feudalismo"]},
  "stability": 0.62,
  "legitimacy": 0.71,
  "corruption": 0.18,
  "faction_ids": [30, 31],
  "era": "medieval"
}
```

(A parte da população dessa região é salva à parte, em binário comprimido — ver PDF 03 §7.)

---

### 7. Conexões

- **04 / 05** definem o conteúdo de `map` e `tech_state`.
- **07–09** preenchem os arrays de população.
- **10–12** preenchem `polities`, `leaders`, `factions`, `relations`.
- **13** lê o estado pra montar o *briefing* dos líderes; escreve as decisões de volta.
- **15–17** escrevem `events_active`, `pressures` e ajustam `stability/legitimacy`.

---

*Fim do Documento 06 / 20.*
