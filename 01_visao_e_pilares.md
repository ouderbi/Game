# PROJETO LEVIATÃ
## Documento 01 / 20 — Visão & Pilares

> **Nome de trabalho:** "Leviatã" (provisório — em Hobbes, o Estado é um corpo cuja cabeça é o soberano; combina com a nossa separação cérebro/corpo). Sinta-se livre pra vetar.
> **Camada:** Fundamentos · **Status:** rascunho para revisão · **Série:** 21 documentos

---

### 1. Resumo (pitch)

Um simulador de grande estratégia em 2D no qual o jogador **sempre lidera** uma civilização — da Idade da Pedra à alta tecnologia e ao sci-fi. Os rivais e aliados ao redor do tabuleiro são **líderes com mente própria, movida por LLM**: eles lembram, planejam e tramam. Num mundo onde guerra nuclear, pandemia, golpe de Estado, inflação e corrupção **emergem das pressões acumuladas** — nunca de um dado aleatório — cada partida vira uma história que ninguém roteirizou.

---

### 2. A fantasia central

Você conduz a *mente* de um povo através de milênios. Do outro lado há inteligências que se lembram do que você fez, guardam rancor, formam alianças e traem. E embaixo de tudo há gente real em miniatura: às vezes sábia, frequentemente burra, ocasionalmente heroica. O prazer não está em "vencer um placar", e sim em ver uma história viva se desenrolar e ter sido você a empurrá-la.

---

### 3. Os três pilares

Todo recurso futuro é testado contra estes três. Se não serve a um pilar, provavelmente não entra.

**Pilar 1 — Adversários que pensam de verdade.**
A inteligência dos líderes-LLM é a alma do jogo, não um enfeite. Um ditador paranoico e um presidente conciliador reagem diferente ao mesmo evento porque *pensam* diferente.

**Pilar 2 — História e natureza humana que emergem.**
Acontecimentos e comportamentos nascem de causas acumuladas no mundo, não de scripts. Isso inclui a natureza humana: pessoas falhas, irracionais e às vezes nobres são justamente o que faz a história parecer viva. O bem e o mal não são botões — são resultados.

**Pilar 3 — Variedade civilizacional radical.**
Dezenas de formas de governo e de não-governo, e a jornada completa pedra → alta tecnologia → sci-fi. A variedade é a graça da coisa.

---

### 4. Modelar a natureza humana (virtudes e vícios) — princípio transversal

Um compromisso explícito do projeto: vários fenômenos da vida real são simulados **de forma natural e emergente**, surgindo da interação dos sistemas em vez de serem programados como eventos fixos. Eles não vivem todos neste documento — aqui só cravamos a *intenção* e apontamos onde cada um é detalhado, pra nenhum se perder e cada um virar sistema concreto.

| Fenômeno da vida real | Como aparece no jogo | Detalhado em |
|---|---|---|
| Burrice / irracionalidade | Vieses, pânico, comportamento de manada na população; líderes (sobretudo em modelos baratos) também erram | 07, 13 |
| Inflação | Emergente: massa monetária vs. bens disponíveis | 08 |
| Corrupção | Desvio de recursos; corrói legitimidade e estabilidade | 08, 11, 17 |
| Lealdade | Medidor por facção e indivíduo; alimenta golpes, deserções e coesão | 11, 17 |
| Altruísmo | Cooperação, caridade, sacrifício — no indivíduo e no líder | 07, 09 |
| Espectro bem ↔ mal | Resultado emergente da interação, sem sistema de moralidade roteirizado | 09, 16, 17 |

Princípio-guia: **se um traço humano importa, ele vira uma variável que interage — não uma linha de roteiro.**

---

### 5. O que o jogo É / NÃO É

**É:**
- Grande estratégia com líderes movidos por LLM.
- Poucos sistemas profundos e entrelaçados (emergência > quantidade de variáveis).
- Single-player, rodando como programa nativo de Windows (.exe).
- Um mundo ativo simulado ao vivo; outros mundos ficam salvos/congelados.
- Um **sandbox sem babá**: toda decisão é possível, inclusive a pior.

**NÃO é:**
- Um shooter ou jogo de ação.
- Um RPG de personagem individual — Fallout entra como *estética* e escala futura (zoom), não como núcleo.
- Uma tentativa de simular *toda* variável do mundo real (esse é o caminho mais curto pro projeto travar).

---

### 6. Referências e o que pegamos de cada

| Referência | O que aproveitamos | O que deixamos de fora |
|---|---|---|
| Hearts of Iron 4 | Política, diplomacia, grande estratégia | Foco exclusivo na 2ª Guerra; microgestão militar pesada |
| Age of Empires | Progressão por eras, ritmo | RTS de micro em tempo real |
| Civilization | Árvore tecnológica, arco pedra → futuro | Combate em grade por turnos clássico |
| Fallout | Retrofuturismo, facções, tom | Jogabilidade de RPG individual no núcleo |
| Star Wars | Escala sci-fi, facções icônicas | IP e narrativa fixa |

---

### 7. Princípios de design

1. **Emergência > contagem de variáveis** — poucos sistemas profundos que se cruzam.
2. **Natureza humana como força emergente** — virtudes e vícios saem dos sistemas, não de scripts.
3. **Cérebro / corpo** — o LLM decide em alto nível (esparso, assíncrono); o código executa (rápido, todo tick).
4. **Consciência de custo** — LLM é caro; tiering de modelos (caros só pros líderes pivotais) e camada de provedor trocável.
5. **Fatia vertical antes de tudo** — um núcleo pequeno e jogável primeiro; expansão só depois.
6. **Liberdade total — inclusive a de errar** — toda escolha é permitida, mesmo a autodestrutiva; o jogo nunca barra nem adverte ("tem certeza?"). Combinações ruins levam ao colapso naturalmente. A burrice não é só das pessoas — é uma opção do jogador.

---

### 8. Público & tom

Para quem gosta de sandboxes de estratégia emergente e de "histórias geradas" (público de Paradox, Civ, Dwarf Fortress, RimWorld). Tom: sério mas brincável; um laboratório de civilizações, não um simulador árido.

---

### 9. Critérios de sucesso ("dar certo")

Concretos, pra sabermos quando cada etapa fechou:

- A **fatia vertical** roda de fato num `.exe` em Windows.
- Surgem **histórias que não foram programadas** (ex.: uma pandemia derruba a legitimidade de uma teocracia e dispara um golpe).
- O **escopo de cada módulo fecha** antes de começar o próximo (nada de meio-feito acumulado).
- **Marco "vivo":** um punhado de polities com líderes-LLM atravessam uma era sozinhas e produzem ao menos um evento emergente sem intervenção.

---

### 10. Glossário básico

- **Polity:** qualquer unidade política — governo ou não-governo (tribo, reino, junta, megacorp, IA-governança…).
- **Líder-LLM:** a mente de uma polity, movida por um modelo de linguagem.
- **Cérebro / corpo:** decisão de alto nível (LLM) vs. execução mecânica (código).
- **Pressão:** acúmulo de estado que faz um evento ficar provável (ex.: pressão de pandemia).
- **Fatia vertical:** a menor versão jogável de ponta a ponta do jogo.
- **Mundo ativo vs. congelado:** o mundo carregado é simulado ao vivo; os demais ficam salvos em disco.

---

### 11. Conexões com os outros 19 documentos

- **02 Game Design / 03 Arquitetura** detalham loop, escalas e a estrutura técnica desta visão.
- **07–09 (População, Economia, Sociedade)** realizam a natureza humana emergente da Seção 4.
- **10–12 (Governo, Líderes/Facções, Diplomacia)** realizam o Pilar 3 e a variedade.
- **13–14 (Inteligência, Provedores/Custo)** realizam o Pilar 1 e o princípio cérebro/corpo.
- **15–17 (Eventos, Catálogo, Estabilidade)** realizam o Pilar 2 e o espectro bem/mal.
- **20 (Roadmap)** define a fatia vertical e a ordem de implementação.
- **21 (Construções, Estruturas & Políticas)** cataloga prédios e alavancas de política (muros, bunkers, universidades, estatização…), com liberdade total de escolha.

---

*Fim do Documento 01 / 20.*
