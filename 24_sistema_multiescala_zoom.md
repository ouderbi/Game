# PROJETO NOÓS
## Documento 24 / 24 — Sistema Multi-Escala & Zoom

> **Camada:** Interface & Experiência (entrou no fim da ordem dos arquivos) · **Status:** rascunho para revisão · **Série:** 24 documentos
> **Depende de:** 03 (Arquitetura/Godot), 04 (Mundo), 05 (Eras), 06 (Dados), 07 (População), 18 (Render) · **Alimenta:** 18, 19
> **Atende ao seu pedido:** zoom contínuo Cidade → País → Planeta → Galáxia, tamanho tipo Spore, com visual estilo SimCity 2000, sem derreter a máquina. Implementado em **Godot 4** (PDF 03).

Zoom de SimCity (cidade, tile a tile) até uma escala galáctica, numa máquina só. O segredo está em separar o que é **simulado** do que é **desenhado**.

---

### 1. O princípio de ouro

> **A simulação roda na escala AGREGADA, sempre. O zoom é como você OLHA — não muda o que é CALCULADO.**

A unidade real de simulação é a **região/cidade**, nunca o cidadão. O zoom só troca a **lente** sobre os mesmos dados. Isso é o que torna possível ter a riqueza visual do SimCity *e* a escala do HOI4 ao mesmo tempo.

---

### 2. As quatro lentes  ✅ decidido (tamanhos literais de grade)

| Lente | Grade de referência | O que mostra | Fonte dos dados | Era mínima (PDF 05) |
|---|---|---|---|---|
| **Cidade** (mais perto) | 256 × 256 tiles | tiles isométricos + sprites de prédios (estilo SimCity 2000) | números agregados da região | Pedra (desde o início) |
| **País** (várias cidades/regiões) | 1024 × 1024 tiles | regiões como nós, fronteiras, rotas, diplomacia local | estado das regiões e polities (PDF 12) | Pedra (desde o início) |
| **Planeta** (vários países) | 4096 × 4096 tiles | nível HOI4: todas as polities do planeta, fronteiras, guerra, diplomacia global | polities/relações (PDF 12) | Espacial (PDF 05) revela o planeta inteiro de uma vez; antes disso só o explorado |
| **Galáxia** | grafo de sistemas/planetas (não é grade de tiles) | sistemas estelares, rotas interestelares; só o planeta/sistema aberto no momento é simulado em detalhe | mundos/planetas salvos (PDF 04 §5) | Estelar+ (PDF 05) |

Os "tamanhos de referência" (256/1024/4096) são a **resolução da grade visual** daquela lente — não um limite fixo; mapas podem ser configurados menores/maiores, respeitando o orçamento de desempenho (PDF 03 §9). Os "cidadãos andando" na lente Cidade são **representação amostral / enfeite** — não milhões simulados um a um.

Note que a lente **Galáxia** é diferente de "**múltiplos mundos**" (PDF 04 §5): a Galáxia é a escala macro *dentro* de uma partida/save; "múltiplos mundos" são saves inteiros e independentes (cada um com sua própria semente, podendo cada um ter sua própria galáxia).

---

### 3. Simulação vs. Visualização (a distinção que faz tudo funcionar)

- **Simulação:** sempre **agregada**, processada em bloco sobre arrays por região (PDF 03/06/07 — `PackedArrays` do Godot). Processa **todas as regiões de uma vez** — nunca um laço "pra cada cidade, simule". É exatamente como o HOI4 faz.
- **Visualização:** o **LOD** (PDF 03) decide o detalhe do **desenho**, não da simulação. A região visível desenha em detalhe (tiles, sprites); as outras milhares são ícone + número. **Culling**: só desenha o que está na viewport (Godot cuida disso nativamente via `VisibleOnScreenNotifier2D`/câmera).

> Regra prática: **simula tudo junto e barato; desenha em detalhe só onde você olha.**

A lente Cidade não é uma simulação nova — é uma **camada de visualização rica** por cima de dados que já existem agregados.

---

### 4. A lente Cidade em detalhe (isométrico SimCity 2000)

- **Projeção dimétrica 2:1**, tiles em losango (transformação grade→tela do PDF 18: `tela_x=(gx−gy)·L/2`, `tela_y=(gx+gy)·A/2`, menos `nível·passo` pra elevação).
- **Sprites de prédios com altura**, ordenados por *painter* (`gx+gy` e depois elevação).
- **As construções do PDF 21** (muros, bunkers, universidades, usinas…) aparecem aqui como sprites.
- A cidade renderiza com **bastante detalhe**, mas com **culling + pan**: desenha o que está na viewport e você navega dentro dela — não renderiza a região inteira de uma vez. *(Esta é a decisão padrão; ajustável.)*
- Quais e quantos prédios aparecem é **gerado a partir do estado agregado** (uma região populosa mostra mais prédios) — visualização procedural dos números.

---

### 5. ⚙️ Instrução direta ao Claude Code: alta resolução

> Implemente a renderização com **alta fidelidade visual**: tiles isométricos nítidos, sprites detalhados, **suporte a alta densidade de pixels** (escala de DPI), **zoom sem perda de qualidade** e capricho no estilo SimCity 2000. Trabalhe a câmera para transição **suave** entre as lentes.
>
> **Sem travar a fatia vertical:** comece com assets placeholder de **boa qualidade e alta resolução** (pacotes CC0 como os do Kenney servem) e refine a arte final depois. A "resolução" aqui é da **engine de render** — nítida, escalável, detalhada —, não um bloqueio à espera de arte.

---

### 6. Ordem de implementação  ✅ decidido (arquitetura grande desde o início)

O projeto mira o escopo completo (12 eras, 4 lentes) desde a arquitetura — mas a **construção** ainda entra em ordem, marco a marco (PDF 20), pra sempre ter algo rodável:

1. **Base:** render de mapa de tiles, lente **País** (a mais próxima de um 4X clássico) — M0.
2. **Lente Planeta** — visão global de todas as polities (nível HOI4).
3. **Lente Cidade isométrica** — a mais trabalhosa (ordenação, sprites, elevação).
4. **Lente Galáxia** — entra quando as eras Espacial+ estiverem em produção (PDF 05).

**Desde o dia 1:** a arquitetura de **câmera + LOD** já é desenhada para as quatro lentes (Seção 2) e os 12 slots de era (PDF 05) — mesmo que só uma lente e as primeiras eras estejam com conteúdo populado no início. O *princípio de ouro* (Seção 1) vale para **todo** o código de simulação desde o primeiro tick.

---

### 7. Nota de dados: elevação por tile

A lente Cidade isométrica precisa de **elevação por tile** (morros, água em níveis, encostas). Isso é um campo a acrescentar no mapa (PDFs 04 e 06) quando a lente Cidade for implementada — um conjunto de tiles por combinação de inclinação, como no SimCity 2000.

---

### 8. Conexões

- **03 (LOD)** é o mecanismo que separa detalhe de simulação de detalhe de desenho.
- **07 (População agregada)** é a fonte que a lente Cidade visualiza.
- **18 (Render)** ganha um renderizador por lente; **19 (UI)** ganha os controles de zoom.
- **21 (Construções)** fornece os sprites de prédio da lente Cidade.

---

*Fim do Documento 24 / 24.*
