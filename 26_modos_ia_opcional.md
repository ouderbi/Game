# PROJETO NOÓS
## Documento 26 / 28 — Modos de Jogo & IA Opcional

> **Camada:** Inteligência · **Status:** rascunho para revisão · **Série:** 28 documentos
> **Depende de:** 14 (Provedores), 25 (Heurística) · **Alimenta:** 19 (UI/config)

Crava um requisito: **o jogo é 100% jogável sem LLM.** O LLM é uma camada opcional por cima — nunca um pré-requisito.

---

### 1. Os três modos

| Modo | Custo | Conexão | Rivais |
|---|---|---|---|
| **Sem IA** (heurística) | grátis | offline | espertos, mas previsíveis |
| **IA local** (Ollama) | grátis | offline | com alguma alma, sem custo |
| **IA de ponta** (Claude API) | créditos | online | pensam e falam de verdade |

E o modo **misto** (o mais elegante): heurística na maioria das polities, LLM só nas poucas que importam (tiering, PDF 14) — custo mínimo, adversários vivos onde faz diferença.

---

### 2. Por que isso é requisito (não opção)

- **Comercial:** não se vende na Steam um jogo onde o comprador precisa configurar e pagar uma API (ver PDF 28).
- **Acessibilidade:** roda offline, de graça, em máquina fraca — esse será o modo padrão pra muita gente.
- **Teste em massa:** só é viável com heurística (LLM em escala é inviável, PDF 27).

---

### 3. O que muda entre os modos

- **Pilares 2 e 3 (emergência, variedade): 100% intactos** em todos os modos — pandemia, inflação, golpe, as 45 formas de governo, tudo emerge igual.
- **Pilar 1 (a alma dos rivais): varia.** Heurística = competente e previsível; LLM = imprevisível, com voz e personalidade.

Você troca *alma e imprevisibilidade* por *grátis, rápido e offline*.

---

### 4. Como é configurado

O provedor é escolhido na **config** (PDF 03/14) — arquivo ou menu. Nenhuma linha do jogo muda; é a mesma interface `decide()` com outro motor atrás.

---

### 5. Requisito explícito pro Claude Code

> O jogo **deve** ser completo e divertido usando **apenas** a `HeuristicProvider`. Trate o LLM como uma camada *opt-in*. Nunca crie dependência de rede ou de API no caminho principal do jogo.

---

### 6. Conexões

- **14** define a camada trocável que realiza os modos.
- **25** é o motor do modo "Sem IA".
- **28** explica por que isso é também uma decisão comercial.

---

*Fim do Documento 26 / 28.*
