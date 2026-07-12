# PROJETO NOÓS
## Documento 22 / 23 — Mapa de Integração & Fluxo do Sistema

> **Camada:** Integração (entrou no fim da ordem dos arquivos) · **Status:** rascunho para revisão · **Série:** 23 documentos
> **Depende de:** todos · **Mostra:** o todo girando junto

Os outros documentos definem peças. Este mostra a **máquina inteira funcionando** — a ordem de um tick cruzando todos os sistemas, o diagrama de dependências e o fluxo de dados de ponta a ponta. É o doc que evita que 23 módulos virem 23 ilhas.

---

### 1. Um tick completo (cruzando todos os sistemas)

A sequência fixa de cada passo de simulação, com o sistema responsável:

```
 1. Relógio avança                          (core/clock · PDF 03)
 2. População & economia atualizam          (07/08): necessidades, produção,
                                              preços, INFLAÇÃO, corrupção, migração
 3. Sociedade agrega                         (09): moral, ideologia, coesão
 4. Pressões recalculadas                    (15) a partir de 07–12
 5. Eventos checados e disparados            (15/16); efeitos aplicados
 6. Estabilidade/legitimidade recomputadas   (17); riscos de golpe/revolução
 7. Líderes notificados; decisões coletadas  (13): heurística na hora,
                                              LLM enfileirado (14)
 8. Decisões validadas e aplicadas           (13 → world): a engine é a autoridade
 9. Diplomacia resolvida                      (12)
10. Render lê o estado; UI atualiza; log      (18/19)
```

Atravessando tudo: **LOD**, a **fila assíncrona** de LLM e o **determinismo** (semente + tick fixo).

---

### 2. Diagrama de dependências (camadas)

```
config / providers (base trocável)
        │
   WorldState + Modelo de Dados (06)  ◄── o HUB: tudo lê e escreve aqui
        │
  População(07) · Economia(08) · Sociedade(09)
        │
  Governo(10) · Líderes/Facções(11) · Diplomacia(12)
        │
  Cérebros(13) · Provedores(14)
        │
  Eventos(15) · Catálogo(16) · Estabilidade(17)
        │
  Render(18) · UI(19)
        │
  Roadmap(20) orquestra a construção

Transversais: Mundo(04) · Eras(05) · Construções/Políticas(21) · Tech por governo(23)
```

---

### 3. O fluxo de dados (o hub `WorldState`)

Tudo gira em torno de um estado central:

```
WorldState ──(projeção de leitura)──► BRIEFING ──► Decider.decide() ──► DECISÃO
     ▲                                                                      │
     └──────────────── efeitos validados ◄── engine valida ◄───────────────┘

Entrada do jogador ──► mesma fila ──► mesma validação ──► WorldState
```

Ninguém escreve no estado por fora do pipeline — nem o jogador, nem o LLM.

---

### 4. Seguindo um evento de ponta a ponta (exemplo)

Uma **fome** atravessando a máquina inteira:

```
queda de produção (08) → pressão de fome sobe (15) → cruza o limiar → evento FOME (16)
   → mortes e migração na população (07) → moral e lealdade caem (07/09)
   → legitimidade e estabilidade caem (17) → risco de revolução sobe (17)
   → entra no briefing dos líderes (13) → líder decide importar/reprimir (13/14)
   → decisão validada e aplicada (13) → diplomacia de ajuda (12)
   → região mostra sofrimento na tela (18) → alerta na UI e no log (19)
```

Nenhum passo foi roteirizado — cada um é um sistema reagindo ao anterior.

---

### 5. Onde cada documento "roda" no tick

| Momento do tick | Documentos |
|---|---|
| Estado base / dados | 04, 06 |
| População/economia/sociedade | 07, 08, 09 |
| Pressões e eventos | 15, 16 |
| Governança e medidores | 10, 11, 17 |
| Mente e decisão | 12, 13, 14, 25, 26 |
| Construções/políticas/tech | 05, 21, 23 |
| Apresentação | 18, 19, 24, 29 |
| Orquestração (build) | 20 |

---

### 6. Princípios de integração

- **Um hub de estado** (06): nenhuma escrita por fora do pipeline.
- **Engine soberana:** LLM e jogador propõem; a simulação valida.
- **Determinismo:** semente + tick fixo → reprodutível e testável.
- **Acoplamento por id**, não por ponteiro (06) — módulos trocáveis.
- **Assíncrono não bloqueia:** o corpo nunca espera o cérebro (03).

---

### 7. Conexões

Este documento amarra **todos** os outros. Use-o junto ao PDF 20 (Roadmap): o 20 diz *em que ordem construir*, o 22 diz *como tudo conversa quando rodando*.

---

*Fim do Documento 22 / 23.*
