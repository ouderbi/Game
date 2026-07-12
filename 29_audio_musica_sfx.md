# PROJETO NOÓS
## Documento 29 / 29 — Áudio, Música & SFX

> **Camada:** Interface & Experiência (entrou por último na ordem dos arquivos) · **Status:** rascunho para revisão · **Série:** 29 documentos
> **Depende de:** 05 (Eras), 15–16 (Eventos), 18 (Render) · **Alimenta:** 19 (UI), 20 (Roadmap)

Lacuna que faltava na suíte: como o jogo **soa**. Assim como o visual (PDF 18), o áudio muda com a era e reforça a leitura de crise (PDF 19 §3) — sem exigir orçamento de trilha original desde o início.

---

### 1. Música por era

- Cada uma das 12 eras (PDF 05) tem sua própria **paleta musical** — instrumentação que evolui de percussão/instrumentos primitivos (Pedra) até sintetizadores/orquestral eletrônico (Intergaláctica), passando por orquestral clássico (Clássica/Medieval), industrial/orquestral maior (Industrial/Moderna) e eletrônico (Informação/Alta Tecnologia).
- **Transição de era** é acompanhada por uma mudança perceptível de trilha — reforça a sensação de progresso, do mesmo jeito que o visual muda (PDF 18 §4).
- Música de fundo é **adaptativa por estado**, não só por era: uma polity estável toca algo mais calmo; sob crise grave (guerra, colapso iminente), a trilha tensiona.

---

### 2. SFX de eventos e UI

- **Eventos** (PDF 16) têm assinatura sonora própria: sirene/alarme pra guerra nuclear, sino/tétrico pra praga, tambores pra golpe. Reforça a leitura de crise "de relance" que a UI já propõe (PDF 19 §3).
- **UI:** cliques, confirmações, alertas de pressão subindo — sutis, nunca cansativos numa sessão longa (esse é um jogo de sessões extensas, ao estilo Paradox).
- **Ambiente:** som de fundo por bioma (PDF 04 §2) e por lente de zoom (PDF 24) — a lente Cidade tem ambiência urbana; a lente Planeta é mais abstrata/orquestral.

---

### 3. A "voz" dos líderes-LLM (texto, não voz sintetizada — por ora)

As falas dos líderes (PDF 13 §3, campo `diplomacy`) são **texto**, não áudio sintetizado, na primeira versão — custo e complexidade de TTS ficam fora de escopo por enquanto. Um efeito sonoro discreto (notificação) marca a chegada de uma nova mensagem no feed de diplomacia (PDF 19 §4). Dublagem/TTS fica como possibilidade futura, pós-lançamento.

---

### 4. Implementação em Godot 4

- **Audio buses** separados: Música, SFX, Ambiente, UI — cada um com volume próprio na tela de opções.
- `AudioStreamPlayer` (não-posicional) pra música/UI; `AudioStreamPlayer2D` pra sons posicionados no mapa (uma batalha, uma explosão nuclear na região certa).
- Crossfade entre faixas na transição de era/estado, em vez de corte seco.

---

### 5. Assets e placeholder

Assim como a arte (PDF 24 §5), o áudio começa com **bibliotecas CC0/royalty-free de qualidade** (ex.: bancos de SFX livres, música procedural ou trilhas CC0 por era) — não trava o desenvolvimento esperando trilha original. Composição própria entra como refinamento, se/quando fizer sentido pro lançamento (PDF 28).

---

### 6. Escopo (mantendo o "dar certo")

Áudio **não bloqueia** nenhum marco do PDF 20 — entra em paralelo, a partir do M5 (quando a UI e o ciclo de eras já estão de pé), sem impedir que M0–M4 rodem mudos/com placeholder mínimo.

---

### 7. Conexões

- **05 (Eras)** define os estágios que a paleta musical acompanha.
- **15–16 (Eventos)** fornecem os gatilhos de SFX de crise.
- **18 (Render)** e **24 (Multi-escala)** definem a ambientação por lente.
- **19 (UI/UX)** hospeda os controles de volume e o feed de diplomacia com notificação sonora.
- **20 (Roadmap)** posiciona a entrada do áudio a partir do M5.

---

*Fim do Documento 29 / 29 — série completa.*
