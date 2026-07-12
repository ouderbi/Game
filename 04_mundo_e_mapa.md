# PROJETO LEVIATÃ
## Documento 04 / 20 — Mundo & Mapa

> **Camada:** Modelo de Mundo · **Status:** rascunho para revisão · **Série:** 20 documentos
> **Depende de:** 03 (Arquitetura) · **Alimenta:** 06 (Dados), 08 (Economia), 15–16 (Eventos)

O substrato físico onde tudo acontece. Implementa parte de `world/`.

---

### 1. Representação do mundo — decisão  ⚙️ proposto

**Híbrido em duas camadas** (modelo "Paradox"):

- **Tiles** (grade quadrada) — a geografia base: terreno, biomas, visual. Proponho quadrada (simples no pygame) em vez de hexagonal.
- **Regiões / províncias** — o agrupamento de tiles que é a **unidade real de jogo**: o que uma polity possui, onde a população vive, onde a economia opera.

Por quê: a simulação opera sobre **centenas de regiões**, não sobre milhões de tiles — performático. Os tiles existem pro visual e pra geografia; as regiões carregam o estado.

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

### 5. Múltiplos mundos

- Cada mundo = **própria semente + próprio estado** salvo.
- **Ativo vs. congelado:** só o mundo carregado é simulado ao vivo; os demais ficam em disco (ver PDF 03 §7 e PDF 06).
- Trocar de mundo = persistir o atual e carregar outro.

---

### 6. Escala e bordas

- **Tamanho** configurável (pequeno → enorme), limitado pelo orçamento de desempenho.
- **Borda do mundo:** proponho **envolvimento cilíndrico** leste-oeste (dá a volta) e polos fechados ao norte/sul — clássico de estratégia.

---

### 7. Conexões

- **06 (Modelo de Dados)** define o schema de `Region` e do mapa.
- **08 (Economia)** consome recursos e regiões.
- **05 (Eras)** libera recursos por era.
- **15–16 (Eventos)** usam geografia e densidade pra calcular pressões e propagação.

---

*Fim do Documento 04 / 20.*
