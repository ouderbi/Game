# PROJETO NOÓS
## Documento 19 / 21 — UI/UX & Controles

> **Camada:** Interface & Experiência · **Status:** rascunho para revisão · **Série:** 21 documentos
> **Depende de:** 18 (Render), 02 (Verbos) · **Alimenta:** 20 (Roadmap)

Onde os **verbos do jogador** (PDF 02 §6) chegam às mãos. Implementa `ui/`.

---

### 1. Os painéis principais

| Painel | Conteúdo |
|---|---|
| Mapa-mundo | a visão principal (PDF 18) |
| Nação | economia, estabilidade, legitimidade, era, tesouro |
| Governo & Políticas | trocar governo, alavancas de política (PDF 21), impostos |
| Pesquisa | alocar foco tecnológico (PDF 05) |
| Diplomacia | relações, tratados, **mensagens dos outros líderes** |
| Construção | erguer estruturas (PDF 21) |
| Líder & Facções | seu líder, facções, lealdade |
| Eventos | crises que exigem decisão (pop-ups) |
| Zoom | alterna entre as 4 lentes: Cidade/País/Planeta/Galáxia (PDF 24) |
| Cheats (modo sandbox) | painel à parte, só visível com sandbox ligado (PDF 02 §8) |

---

### 2. Como uma decisão entra na simulação  ✅ implementado (primeiro verbo)

```
clique do jogador → ação enfileirada → aplicada pelo MESMO pipeline do tick (PDF 03 §5)
```

A ação do jogador passa pela mesma validação que a decisão do líder-LLM (ou heurística). Consistência total: `EstadoDoMundo.fila_acoes_jogador` recebe o clique; `SimulacaoPolitica.avancar()` identifica a polity com `eh_jogador = true` e, em vez de chamar o Decisor heurístico, consome essa fila — o mesmo `_aplicar_decisao()` valida e aplica os dois casos. Primeiro verbo real: subir/baixar impostos (HUD). Os demais painéis da Seção 1 chegam conforme os sistemas por trás deles existirem.

---

### 3. Tornar a emergência legível

Como os eventos nascem de **causas acumuladas**, a UI **dá pistas das pressões subindo** — o jogador *vê a crise chegando* e pode agir. Isso é o que torna o sistema emergente justo, e não arbitrário: medidores, alertas suaves, tendências.

---

### 4. A voz dos líderes-LLM na tela

É aqui que "adversários que pensam" vira **sensação**: um feed de diplomacia com as mensagens, ultimatos e propostas dos outros líderes, retratos e texto de personalidade. Você *lê* a mente rival se manifestar.

---

### 5. Controles

- **Mouse:** *pan*, *zoom*, selecionar, clicar.
- **Teclado:** pausa, velocidades (1x/2x/3x), atalhos de painel.
- **Pausa a qualquer momento** (PDF 02 §2) — pensar sem pressa.

---

### 6. Notificações, log e legado

- **Log de eventos** com o histórico da partida.
- Esse histórico alimenta a **tela de legado** ao final (PDF 02 §7) — a história da sua civilização contada.

---

### 7. UX sem babá

Coerente com o PDF 01 §7: **nenhum aviso** do tipo "tem certeza? isso é ruim". Confirmação só pra ações mecânicas irreversíveis — nunca pra advertir sobre escolhas ruins de estratégia ou moral.

---

### 8. Localização (PT-BR / EN)  ✅ decidido

- Todo texto de jogo (painéis, eventos, falas dos líderes) passa por uma camada de localização desde o M5 (PDF 20), com **português e inglês** disponíveis desde o lançamento da primeira versão jogável.
- Usa o sistema de tradução nativo do Godot (arquivos `.csv`/`.po` por *locale*); o jogador troca o idioma na config, sem reiniciar.
- Textos gerados pelo LLM (falas/diplomacia, PDF 13 §3) são pedidos **no idioma ativo** do jogador diretamente no prompt — não passam por tradução automática à parte.

---

### 9. Conexões

- **21 (Construções/Políticas)** preenche os painéis de Governo e Construção.
- **12–13** alimentam o feed de diplomacia.
- **17** fornece os medidores e pressões exibidos.
- **24 (Multi-escala)** fornece os controles de zoom entre lentes.
- **29 (Áudio)** hospeda os controles de volume nesta camada de UI.

---

*Fim do Documento 19 / 21.*
