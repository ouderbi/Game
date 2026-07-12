# PROJETO NOÓS
## Documento 15 / 21 — Sistema de Eventos Procedurais

> **Camada:** Dinâmicas Emergentes · **Status:** rascunho para revisão · **Série:** 21 documentos
> **Depende de:** 03 (Arquitetura), 06 (Dados), 07–12 · **Alimenta:** 16 (Catálogo), 17 (Estabilidade)
> **Realiza:** o Pilar 2 (história que emerge, não roteirizada).

O motor que faz as coisas acontecerem. Princípio inegociável: **eventos emergem de pressões acumuladas — nunca de um dado solto.** O acaso só entra no *quando* e no *quão forte*, jamais no *porquê*.

---

### 1. O modelo de pressão

Cada tipo de evento tem **acumuladores de pressão** por escopo (global / polity / região). A pressão sobe a partir do estado do mundo:

| Pressão | Sobe com (exemplos) |
|---|---|
| Pandemia | densidade + saneamento ruim + contatos comerciais + refugiados |
| Guerra nuclear | corrida armamentista + hostilidade + líder belicista + urânio/tech |
| Golpe | deslealdade de facção + baixa legitimidade + corrupção + poder militar |
| Fome | produção < necessidades + guerra + desastre + clima |
| Revolução | desigualdade + repressão + baixa legitimidade + ideologia se espalhando |

A pressão é um número 0–1 que **se acumula tick a tick** (PDF 06).

---

### 2. O ciclo de vida de um evento

```
pressão acumula → cruza limiar (ponderado, levemente estocástico)
   → evento INSTANCIA → PROPAGA → RESOLVE → DECAI / rescaldo
```

O limiar tem um componente aleatório pequeno (pra não ser robótico), mas a **causa** é sempre o estado acumulado.

---

### 3. O schema genérico de evento

Todo evento do catálogo (PDF 16) preenche esta estrutura:

```
EventDef
├── id
├── category          # bélico|saúde|econômico|ambiental|tecnológico|social
├── preconditions     # o que precisa ser verdade
├── pressure_sources  # o que alimenta a pressão
├── trigger           # limiar de disparo
├── severity          # quão forte (faixa)
├── scope             # global | polity | região
├── propagation       # como se espalha
├── resolution_paths  # como termina
└── aftermath         # marca que deixa
```

---

### 4. As duas origens de um evento

1. **Emergente da pressão** (mundo decide): pandemia, fome, desastre, revolução — disparam quando a pressão cruza o limiar.
2. **Escolhido pelo líder** (mente decide): guerra nuclear, declarar guerra, golpe preventivo — o líder-LLM **opta** por isso quando capacidade + situação permitem (PDF 13).

As decisões de líder também **realimentam pressões**: um líder belicista empurra a pressão de guerra pra cima de todos.

---

### 5. O laço de geração (no pipeline do tick)

A cada passo (PDF 03 §5):

1. Atualizar todas as pressões a partir do estado.
2. Checar limiares; instanciar eventos que dispararam.
3. **Notificar os líderes afetados** (entra no briefing, PDF 13) pra responderem.
4. Propagar eventos em curso; aplicar efeitos; decair concluídos.

---

### 6. Propagação

Eventos se **espalham** pela estrutura do mundo: pandemia pelas rotas comerciais e migração; guerra puxando aliados; pânico entre vizinhos na população. A geografia (PDF 04) e as relações (PDF 12) são os canais.

---

### 7. Conexões

- **16 (Catálogo)** preenche o schema da Seção 3 pra cada evento concreto.
- **17 (Estabilidade)** consome eventos e devolve pressões (golpe, revolução, colapso).
- **13 (Inteligência)** recebe os eventos no briefing e responde por eles.

---

*Fim do Documento 15 / 21.*
