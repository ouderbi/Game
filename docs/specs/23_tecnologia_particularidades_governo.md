# PROJETO LEVIATÃ
## Documento 23 / 23 — Tecnologia & Particularidades por Governo

> **Camada:** Governança (entrou no fim da ordem dos arquivos) · **Status:** rascunho para revisão · **Série:** 23 documentos
> **Depende de:** 05 (Árvore-base), 10 (Governos) · **Alimenta:** 08 (Pesquisa), 16–17 (Eventos/Estabilidade), 21 (Destravamentos)
> **Atende ao seu pedido:** cada forma de governo com árvore tecnológica diferente e particularidades próprias.

Como cada governo pesquisa de modo diferente e tem identidade única — **sem construir 45 árvores do zero** (isso seriam 45 jogos). A solução: uma árvore-base + modificadores e exclusividades por governo.

---

### 1. O modelo (base + modificadores)

1. **Árvore-base comum** (PDF 05): o tronco que toda civilização compartilha (fogo, agricultura, metalurgia, escrita… até o sci-fi).
2. **Viés de pesquisa por governo:** multiplicadores de custo/velocidade por ramo.
3. **Tecnologias exclusivas por governo:** o que só aquele governo destrava.
4. **Travas:** o que aquele governo **não** alcança.
5. **Particularidades:** bônus, penalidades, ações e eventos únicos — além da tech.

Variedade por **modificação de uma base**, não por 45 árvores independentes. Expansível pelo schema.

---

### 2. O schema de perfil de governo

Estende o `GovernmentType` (PDF 10):

```
GovernmentProfile
├── tech_bias{ramo -> multiplicador}  # <1 mais rápido/barato; >1 mais lento/caro
├── exclusive_techs[]                 # só este governo destrava
├── locked_techs[]                    # este governo NÃO alcança
├── bonuses[]                         # vantagens passivas
├── penalties[]                       # desvantagens passivas
├── unique_actions[]                  # ações que só este governo pode tomar
└── unique_events[]                   # eventos próprios deste governo
```

---

### 3. Perfis de exemplo (a variedade na prática)

**Tecnocracia**
- Viés: científico 0,7x (rápido/barato); militar 1,1x.
- Exclusivas: automação avançada, IA aplicada.
- Bônus: velocidade de pesquisa. Penalidade: legitimidade baixa (governo frio).
- Ação única: *Diretiva Otimizadora* (realoca a economia por eficiência pura).

**Teocracia**
- Viés: social/coesão 0,7x; certas ciências 1,4x (resistência ao secular).
- Exclusivas: instituições de fé, unificação divina.
- Bônus: legitimidade e estabilidade pela fé. Penalidade: ciência travada.
- Evento único: *Cisma*. Ação única: *Decreto Sagrado*.

**Império militarista / despótico**
- Viés: militar 0,7x; econômico 1,2x.
- Exclusivas: doutrinas de conquista.
- Bônus: exército. Penalidade: economia e diplomacia.
- Ação única: *Conscrição Total*.

**Corporatocracia**
- Viés: econômico 0,7x.
- Exclusivas: ramos de mercado e finanças próprios.
- Bônus: economia e comércio. Penalidade: desigualdade e corrupção.
- Ação única: *Monopólio / Lobby*.

**IA-governança**
- Viés: científico/automação 0,6x.
- Exclusivas: tecnologias pós-humanas que ninguém mais alcança.
- Bônus: eficiência máxima, corrupção mínima. Penalidade: inquietação popular, legitimidade frágil.
- Ação única: *Reotimização Total* (refaz políticas instantaneamente).

**Tribo / não-governo**
- Travas: a maior parte da tech avançada.
- Bônus: resiliência e mobilidade. Penalidade: pesquisa lenta.
- Ação única: *Migração Nômade*.

(Os demais governos seguem o mesmo schema — preenchimento, não código novo.)

---

### 4. Particularidades além da tecnologia

Bônus/penalidades passivas, ações exclusivas e eventos próprios dão a cada governo um **jeito de jogar** distinto. Uma democracia e uma ditadura não só pesquisam diferente — elas *agem* diferente e enfrentam crises diferentes.

---

### 5. Transição de governo muda o perfil  ★

Quando uma polity **troca de governo** (golpe, revolução, reforma — PDFs 10/17), seu `GovernmentProfile` muda junto: prioridades de pesquisa, destravamentos e ações se reconfiguram. Uma teocracia que vira tecnocracia de repente *destrava* ciências antes travadas — e perde a coesão da fé. Consequência emergente rica, de graça.

---

### 6. Como integra

- **05 / 08:** o `tech_bias` modula a velocidade de pesquisa real.
- **21:** `exclusive_techs` destravam construções e políticas próprias.
- **16 / 17:** `unique_events` e particularidades alimentam eventos e estabilidade.
- **10:** este doc é a "ficha de identidade" que dá profundidade a cada governo do catálogo.

---

### 7. Escopo (mantendo o "dar certo")

A fatia vertical usa **poucos governos com perfis simples**; a variedade dos 45 entra na expansão (PDF 20, pós-fatia). O schema garante que crescer é só preencher, nunca reescrever.

---

*Fim do Documento 23 / 23 — série completa.*
