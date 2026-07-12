# PROJETO NOÓS
## Documento 21 / 21 — Construções, Estruturas & Políticas

> **Camada:** Governança (entrou por último na ordem dos arquivos) · **Status:** rascunho para revisão · **Série:** 21 documentos
> **Depende de:** 05 (Eras), 08 (Economia), 10 (Governo) · **Alimenta:** 17 (Estabilidade), 16 (Defesa/Guerra), 19 (UI)
> **Marcado por você como extremamente importante.** Variedade enorme + liberdade total, inclusive a pior escolha.

O que uma civilização **constrói** e quais **políticas** adota. Dois tipos de "estrutura": construções físicas no mapa, e alavancas de política (que não são prédios). Tudo com variedade por era, e nada que impeça você de fazer a escolha errada.

---

### 1. Os dois tipos

- **Construções físicas** — ficam no mapa (muralha, universidade, usina…).
- **Políticas / instituições** — alavancas de Estado, sem objeto físico (estatização, conscrição, censura…).

---

### 2. Schema de uma construção

```
Building
├── id
├── category      # defensiva | cívica | econômica | especial
├── era_available # era que destrava (PDF 05)
├── cost          # custo de construção
├── upkeep        # manutenção por turno
├── effects       # bônus (defesa, pesquisa, produção, moral…)
└── requirements  # pré-requisitos (recurso, tech, terreno)
```

### 3. Schema de uma política

```
Policy
├── id
├── era_available
├── effects       # o que melhora
└── tradeoffs     # o que piora em troca
```

Ambos são **templates** — o Claude Code preenche cada item a partir deles.

---

### 4. Catálogo de construções (por categoria)

**Defensivas:** paliçada, muralha, fortaleza, **bunker**, búnker antinuclear, bateria antiaérea, silo de mísseis, **escudo de energia** (sci-fi).

**Cívicas / conhecimento:** **universidade**, biblioteca, escola, hospital, templo, monumento, tribunal.

**Econômicas:** fazenda, mina, fábrica, mercado, porto, banco, usina (carvão / **nuclear** / fusão).

**Especiais / sci-fi:** laboratório de IA, elevador espacial, megaestrutura orbital.

(A lista é expansível — qualquer nova construção é só um preenchimento do schema da Seção 2.)

---

### 5. Catálogo de políticas (alavancas, com trade-off)

| Política | Melhora | Custa (trade-off) |
|---|---|---|
| **Estatização** | controle, arrecadação imediata | eficiência, inovação; corrupção sobe |
| **Privatização** | eficiência, inovação | desigualdade; menos controle |
| Economia de comando | mobilização, igualdade nominal | escassez, mercado morto |
| Livre mercado | crescimento, inovação | desigualdade, instabilidade |
| Tributação alta | tesouro cheio | humor e lealdade caem |
| Conscrição | exército grande | economia e humor sofrem |
| Censura | estabilidade de curto prazo | legitimidade, ciência caem |
| Bem-estar | lealdade, coesão | custo alto ao tesouro |
| Fronteiras fechadas | controle, barra pandemia | comércio e ideias minguam |
| Programa nuclear | dissuasão, poder | custo enorme, tensão sobe |
| Vigilância de massa | controle, anti-golpe | liberdades, moral caem |

---

### 6. Liberdade total — inclusive a pior escolha  ★

O ponto que você fez questão de cravar. Nada te impede de:

- Construir **só bunkers e nenhuma universidade** → defendido, mas **apodrecendo na tecnologia**.
- **Estatizar tudo** → controle total, mas **estagnação e corrupção**.
- Censurar, vigiar e conscrever ao máximo → ordem aparente, mas **legitimidade no chão** e golpe à espreita.

O jogo **não adverte e não barra** — as consequências escorrem naturalmente pra economia (08), pesquisa (05) e estabilidade (17). É o princípio do PDF 01 §7 aplicado a cada tijolo e cada lei.

---

### 7. Variedade por era

Cada era **destrava** novas construções e políticas; o fim da árvore abre as exóticas (escudo de energia, IA-governança como política, megaestruturas). A diversidade cresce com o tempo, mantendo a "graça da coisa" que você pediu.

---

### 8. Como tudo isto conecta

- **08 (Economia):** construções e políticas mexem em produção, custo e corrupção.
- **05 (Eras):** universidades e laboratórios aceleram a pesquisa.
- **16 (Eventos):** defesas afetam guerra/nuclear; fronteiras afetam pandemia.
- **17 (Estabilidade):** censura, bem-estar e vigilância movem legitimidade e estabilidade.
- **10 (Governo):** cada governo libera um conjunto diferente de `available_policies`.

---

*Fim do Documento 21 / 21 — série completa.*
