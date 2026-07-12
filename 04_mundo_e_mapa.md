# PROJETO NOÓS
## Documento 04 / 20 — Mundo & Mapa

> **Camada:** Modelo de Mundo · **Status:** rascunho para revisão · **Série:** 20 documentos
> **Depende de:** 03 (Arquitetura) · **Alimenta:** 06 (Dados), 08 (Economia), 15–16 (Eventos)

O substrato físico onde tudo acontece. Implementa parte de `world/`.

---

### 1. Representação do mundo — decisão  ✅ decidido

**Híbrido em duas camadas** (modelo "Paradox"):

- **Tiles** (grade quadrada) — a geografia base: terreno, biomas, visual. Quadrada por ser simples de desenhar em qualquer engine (inclusive Godot, via `TileMapLayer`) e por casar direto com as escalas literais do PDF 24 (256×256, 1024×1024, 4096×4096…).
- **Regiões / províncias** — o agrupamento de tiles que é a **unidade real de jogo**: o que uma polity possui, onde a população vive, onde a economia opera.

Por quê: a simulação opera sobre **centenas/milhares de regiões**, nunca sobre os tiles individuais — performático mesmo nos mapas grandes (Planeta, Galáxia). Os tiles existem pro visual e pra geografia; as regiões carregam o estado. Este é o mesmo princípio de ouro do PDF 03 §6 e do PDF 24 §1: **a simulação é sempre agregada; o grid de tiles é resolução visual, não unidade de cálculo.**

---

### 2. Biomas

Tundra, floresta, planície, savana, deserto, montanha, pântano, litoral, oceano. Cada bioma afeta: **recursos** disponíveis, **custo de movimento**, **capacidade de assentamento** e **vulnerabilidade a eventos** (ex.: planície fértil → mais população → mais pressão de pandemia).

---

### 3. Recursos

Distribuídos por bioma e **liberados por era**:

| Tipo | Exemplos | Observação |
|---|---|---|
| Alimento | caça, peixe, grãos, gado | base da população |
| Materiais | madeira, pedra, metais | construção e economia |
| Estratégicos | carvão, petróleo, urânio | liberados por era (urânio → capacidade nuclear) |
| Avançados/sci-fi | materiais exóticos | fim da árvore |

Recursos alimentam a economia (PDF 08) e algumas pressões de evento (ex.: urânio + hostilidade → pressão nuclear).

---

### 4. Geração procedural do mundo

Pipeline determinístico a partir de uma **semente** (mesma semente → mesmo mundo, casando com o tick fixo):

1. **Semente → ruído** (Perlin/Simplex) gera o mapa de altitude.
2. **Altitude + latitude → clima → biomas.**
3. **Biomas → distribuição de recursos.**
4. **Posicionamento inicial** de polities/povos.

Parâmetros de geração: tamanho do mundo, nível do mar, aridez/umidade, fragmentação dos continentes, número de civilizações iniciais.

---

### 5. Múltiplos mundos e escalas literais  ✅ decidido (escopo ampliado)

- Cada mundo = **própria semente + próprio estado** salvo.
- **Ativo vs. congelado:** só o mundo carregado é simulado ao vivo; os demais ficam em disco (ver PDF 03 §7 e PDF 06).
- Trocar de mundo = persistir o atual e carregar outro.
- O mapa Planeta tem tamanho de grade de referência **4096×4096 tiles visuais** (PDF 24); a escala Galáxia é o próximo nível acima — não é mais um grid de tiles, e sim um grafo de sistemas/planetas (cada planeta, quando visitado, abre seu próprio mapa 4096×4096). **Nada disso é simulado tile a tile:** vale sempre o princípio de ouro do PDF 24 §1 — a simulação é agregada por região/planeta/sistema; o grid é só a lente visual daquela escala.

---

### 6. Escala e bordas

- **Tamanho** configurável (pequeno → enorme), limitado pelo orçamento de desempenho — a fatia inicial já mira no tamanho de referência da Seção 5, não num mapa reduzido.
- **Borda do mundo:** envolvimento cilíndrico leste-oeste (dá a volta) e polos fechados ao norte/sul — clássico de estratégia.

---

### 7. Isolamento inicial e "primeiro contato"  ✅ decidido

O jogador começa com a sua polity e **não deve encontrar as demais civilizações-LLM cedo demais** — o contato é um marco narrativo, não um dado de largada:

- **Distância geográfica real:** civilizações iniciais nascem espalhadas (continentes/regiões distantes, depois de gerado o mundo — Seção 4), não próximas.
- **Névoa de guerra / exploração:** o mapa fora do alcance de exploração/comércio da polity não é conhecido; encontrar outra civilização exige alcançar a região dela (via expansão, exploração ou, mais tarde, rotas comerciais/navegação — PDF 08 §5).
- **Assimetria tecnológica reforça o efeito** (PDF 05 §5): civilizações em eras muito diferentes tendem a não ter meios de se alcançar cedo (uma tribo não naveg a oceano; uma potência industrial sim).
- Isso vale como **parâmetro de geração de mundo** (Seção 4): a distância mínima entre pontos de partida das polities é configurável, com um padrão que evita encontros no início de partida.

---

### 8. Conexões

- **06 (Modelo de Dados)** define o schema de `Region` e do mapa.
- **08 (Economia)** consome recursos e regiões.
- **05 (Eras)** libera recursos por era e as escalas de mapa Planeta/Galáxia.
- **11 (Líderes)** usa o isolamento da Seção 7 pra faseamento de quando os líderes-LLM se encontram.
- **15–16 (Eventos)** usam geografia e densidade pra calcular pressões e propagação.
- **24 (Multi-escala)** detalha as 4 lentes e os tamanhos literais de grade.

---

*Fim do Documento 04 / 20.*
