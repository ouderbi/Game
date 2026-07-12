# PROJETO LEVIATÃ
## Documento 07 / 20 — Indivíduos & População

> **Camada:** População · **Status:** rascunho para revisão · **Série:** 20 documentos
> **Depende de:** 06 (Modelo de Dados) · **Alimenta:** 08 (Economia), 09 (Sociedade), 15–17 (Eventos/Estabilidade)
> **Realiza:** a "natureza humana emergente" prometida no PDF 01 §4 (no nível do indivíduo).

Os milhões de indivíduos independentes. **Nada de LLM aqui** — tudo é IA barata por regras, vetorizada (arrays do PDF 06). É de propósito: a vida humana em massa precisa ser rápida, e a riqueza vem da *interação*, não da inteligência de cada um.

---

### 1. Atributos do indivíduo (os arrays)

Cada indivíduo é um índice nos arrays paralelos:

```
idade   saúde   riqueza   humor   lealdade
ideologia   ocupação   região   vivo
+ traços: racionalidade, pró-socialidade, conformidade
```

Os três últimos traços são as alavancas da natureza humana (Seções 4–5).

---

### 2. Necessidades & comportamento (utilidade)

- Cada indivíduo tem **necessidades**: comida, segurança, social, propósito.
- Necessidades atendidas → **humor** sobe; não atendidas → humor cai.
- Humor + lealdade → **comportamento**: trabalhar, migrar, cooperar, protestar, revoltar.
- Tudo resolvido por **regra vetorizada** sobre o array inteiro a cada tick.

---

### 3. A burrice / irracionalidade — emergente  ★

O ponto que você pediu: as pessoas **não otimizam perfeitamente**. Modelado de forma concreta:

| Mecanismo | Efeito no jogo |
|---|---|
| Ruído na decisão | escolhas sub-ótimas, variação individual |
| Viés de manada / conformidade | bolhas, modas, pânico coletivo |
| Aversão à perda / otimismo | corridas a bancos, negação de crises |
| Suscetibilidade a desinformação | crenças falsas se espalham |
| Cascata de medo | pânico se propaga entre vizinhos |

Isso **não é bug** — é o que gera tumultos, bolhas e más decisões coletivas. Liga direto com eventos (corrida bancária, motim) no PDF 16.

---

### 4. Altruísmo — emergente  ★

A pró-socialidade é uma **distribuição** na população: a maioria neutra, alguns egoístas, alguns altruístas. O traço alto leva a **cooperar, doar, sacrificar-se** mesmo contra o interesse próprio:

- Ajuda mútua e caridade em tempos difíceis (amortece fome/crise).
- Coesão social mais alta.
- Heroísmo em crises (alguém se arrisca pelos outros).

O bem não é um botão — é uma fração da população agindo conforme um traço.

---

### 5. Lealdade — emergente  ★

Lealdade do indivíduo à sua polity/facção/líder:

- **Cai** com: necessidades não atendidas, corrupção, repressão, desigualdade.
- **Sobe** com: prosperidade, legitimidade, identidade compartilhada.
- **Consequências:** baixa lealdade alimenta deserção, migração e — em massa — golpes e revoluções (PDF 17).

---

### 6. Ciclo de vida & demografia

Nascimento, envelhecimento, morte. Crescimento populacional puxado por prosperidade e segurança; encolhimento por fome, guerra e pragas. A pirâmide demográfica afeta força de trabalho e exército.

---

### 7. Migração

Indivíduos se movem entre regiões por **empurra/puxa**: fogem de guerra, fome e repressão; vão atrás de prosperidade e segurança. Disso emergem **urbanização**, êxodo rural e **fluxos de refugiados** (que por sua vez mexem na política das regiões de destino).

---

### 8. Desempenho & LOD

Regiões de fundo rodam por **estatística agregada**; só regiões/indivíduos relevantes simulam fino. Indivíduos podem ser "promovidos" a entidades OOP quando viram importantes (ver PDF 03 §9).

---

### 9. Conexões

- **08 (Economia)** consome ocupação, riqueza e necessidades.
- **09 (Sociedade)** agrega humor e ideologia em cultura e moral coletiva.
- **15–17 (Eventos/Estabilidade)** usam lealdade, pânico e desigualdade como combustível.

---

*Fim do Documento 07 / 20.*
