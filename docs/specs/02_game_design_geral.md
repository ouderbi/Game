# PROJETO LEVIATÃ
## Documento 02 / 20 — Game Design Geral

> **Camada:** Fundamentos · **Status:** rascunho para revisão · **Série:** 20 documentos
> **Depende de:** 01 (Visão & Pilares) · **Alimenta:** 03 (Arquitetura), 05 (Eras), 13–14 (Inteligência/Custo), 15–17 (Eventos/Estabilidade)

Este documento responde "como isso de fato se joga". Ele liga a visão (01) à arquitetura técnica (03).

---

### 1. O loop central

O ciclo que se repete a partida inteira:

**Observar** o estado do mundo → **Decidir** (suas ações de líder) → o mundo **Simula** um período (população, economia, eventos e os outros líderes pensando) → as **Consequências** aparecem → repete.

O jogador age de forma contínua (pode decidir a qualquer momento, não só "no seu turno"); o mundo nunca para de viver ao redor dele.

---

### 2. O relógio — como o tempo passa  ✅ decidido

O jogo é **tempo real com pausa** (estilo Hearts of Iron 4), mas com uma regra que nasce da nossa arquitetura:

> **O mundo avança quando as mentes terminam — em paralelo e por tier.**

Como isso funciona na prática:

- **Ticks baratos (todo intervalo curto):** população, economia, movimento e pressões de evento avançam por regras determinísticas. Rápido, sem LLM.
- **Cadência de decisão (mais lenta):** os líderes só "pensam" a cada N ticks, ou quando um evento os obriga.
- **Resolução por tier, em paralelo:** quando os líderes pensam, todos pensam **ao mesmo tempo**, não em fila. E cada um usa o motor do seu tier:
  - **Maioria (heurística):** decisão instantânea.
  - **Poucos pivotais (LLM):** assíncrono. O mundo só espera *esses* — e como são poucos e paralelos, a espera é curta.
- **Pausa a qualquer momento** e velocidades (1x/2x/3x) que mudam a frequência dos ticks.
- **Fallback anti-travamento:** se a API atrasar ou cair, o líder usa a heurística naquele turno. O jogo **nunca** congela esperando a rede.

O que evitamos de propósito: o relógio refém da latência de cada agente, com dezenas de chamadas em fila travando cada passo.

---

### 3. A escada de decisão (resumo)  ✅ decidido

Qual "cérebro" toma cada decisão, do mais barato/burro ao mais caro/esperto. Detalhe completo no **PDF 14**.

| Nível | Motor | Custo / velocidade | Onde usar |
|---|---|---|---|
| 1 | Heurística / regras | Grátis, instantâneo | O grosso das decisões; população |
| 2 | Modelo pequeno local (Ollama, sem treino) | Grátis, rápido | Líderes secundários |
| 3 | LLM via API (Claude) | Custa, latência de rede | Líderes pivotais (alma + voz) |
| 4 | Rede pequena destilada (imitação do LLM) | Grátis, rápido, afiado | Fase futura, quando houver dados |

Princípio: **LLM só onde raciocínio, personalidade e voz aparecem.** O resto é heurística.

---

### 4. Escalas e zoom

- **Estratégica (mundo):** você como líder, o mapa de polities. **É o núcleo — e a única escala viva na fatia vertical.**
- **Regional / operacional (futuro):** cidades e exércitos de perto.
- **Individual (futuro):** zoom num indivíduo, estética Fallout.

O zoom é uma transição de câmera/detalhe sobre a *mesma* simulação — não telas separadas. Escalas futuras não bloqueiam a fatia vertical.

---

### 5. Progressão de eras

Pedra → Antiguidade → Clássica → Medieval → Industrial → Moderna → Informação → Alta Tecnologia → Sci-fi.

Cada era destrava **governos**, **tecnologias** e **ameaças** novas. Exemplos: guerra nuclear só na Moderna+; IA-governança e ameaças sci-fi no fim da árvore. Uma civilização avança por acúmulo tecnológico (detalhe no PDF 05).

---

### 6. O papel do jogador — os verbos

Onde "fazer muitas coisas" vira concreto. O jogador, como líder, pode:

- **Governar:** definir leis, mudar a forma de governo, combater (ou alimentar) a corrupção, gerir legitimidade.
- **Desenvolver:** pesquisa tecnológica, economia, construção, infraestrutura.
- **Diplomacia:** tratados, alianças, guerra e paz, espionagem.
- **Responder a crises:** as decisões que os eventos exigem (uma pandemia chegou — fecha fronteiras?).
- **Conduzir o povo:** influenciar humor, lealdade e coesão.

Linha divisória clara: **o jogador define direção e decisões de alto nível; o sim executa os milhões de detalhes.** Você não micro-gerencia cidadãos.

---

### 7. Vitória e derrota  ✅ decidido (sandbox aberto)

- **Base: sandbox aberto.** A graça é a história emergente (espírito Dwarf Fortress). Não há um "vencer" fixo que a IA possa otimizar — isso protege a "burrice das pessoas" (Pilar 2).
- **Metas opcionais** que o jogador pode perseguir: alcançar uma era, sobreviver X séculos, hegemonia, um feito específico.
- **Derrota:** colapso irrecuperável da sua polity (ver PDF 17 — estabilidade).
- **Fim de jogo = legado, não placar competitivo:** ao final, um resumo conta a *história* da sua civilização (eras vividas, crises superadas, marcas deixadas).

---

### 8. Dificuldade e equilíbrio

A dificuldade escala por três alavancas, sem trapaça de números:

- **Esperteza dos rivais:** quanto melhor o tier de LLM dos líderes rivais, mais difícil.
- **Agressividade / postura** da IA configurável.
- **Burrice como textura, não bug:** até rivais erram (vieses, pânico, decisões sub-ótimas). Isso é proposital e dá vida — não é falha a "consertar".

---

### 9. Sessão típica, salvar e mundos

- **Sessão:** o jogador entra num mundo, conduz sua polity por eras, enfrenta crises emergentes, salva e volta.
- **Salvar/carregar:** o estado completo do mundo persiste em disco.
- **Mundo ativo vs. congelado:** só o mundo carregado é simulado ao vivo; outros ficam salvos/congelados até serem abertos (controla custo e desempenho).

---

### 10. Modos de jogo (futuro)

- Campanha de mundo único (núcleo).
- Multimundos (alternar entre mundos salvos).
- Começar numa era escolhida, em vez de sempre na Idade da Pedra.

---

### 11. Conexões

- **03 (Arquitetura)** implementa o loop, os ticks e o relógio desta Seção 2.
- **05 (Eras & Tecnologia)** detalha a progressão da Seção 5.
- **13–14 (Inteligência / Custo)** detalham a escada de decisão (Seção 3) e o treino/destilação futuro.
- **15–17 (Eventos / Estabilidade)** detalham crises (Seção 6) e a derrota (Seção 7).
- **19 (UI/UX)** define como os verbos da Seção 6 chegam às mãos do jogador.

---

*Fim do Documento 02 / 20.*
