# PROJETO LEVIATÃ
## Documento 24 / 24 — Sistema Multi-Escala & Zoom

> **Camada:** Interface & Experiência (entrou no fim da ordem dos arquivos) · **Status:** rascunho para revisão · **Série:** 24 documentos
> **Depende de:** 03 (LOD), 04 (Mundo), 06 (Dados), 07 (População), 18 (Render) · **Alimenta:** 18, 19
> **Atende ao seu pedido:** zoom contínuo cidade → mapa → país → multimundos, com visual estilo SimCity 2000, sem derreter a máquina.

Zoom de SimCity (cidade, tile a tile) até HOI4 (mundo, país a país), numa máquina só. O segredo está em separar o que é **simulado** do que é **desenhado**.

---

### 1. O princípio de ouro

> **A simulação roda na escala AGREGADA, sempre. O zoom é como você OLHA — não muda o que é CALCULADO.**

A unidade real de simulação é a **região/cidade**, nunca o cidadão. O zoom só troca a **lente** sobre os mesmos dados. Isso é o que torna possível ter a riqueza visual do SimCity *e* a escala do HOI4 ao mesmo tempo.

---

### 2. As quatro lentes

| Lente | O que mostra | Fonte dos dados |
|---|---|---|
| **Cidade** (mais perto) | tiles isométricos + sprites de prédios (estilo SimCity 2000) | números agregados da região |
| **Mapa** (várias cidades) | regiões como nós, rotas e fluxos | estado das regiões |
| **País** (vários países) | nível HOI4: polities, fronteiras, diplomacia | polities/relações (PDF 12) |
| **Multimundos** | só o mundo ativo ao vivo; outros congelados | mundos salvos (PDF 04) |

Os "cidadãos andando" na lente Cidade são **representação amostral / enfeite** — não milhões simulados um a um.

---

### 3. Simulação vs. Visualização (a distinção que faz tudo funcionar)

- **Simulação:** sempre **agregada e vetorizada** (numpy, PDF 06/07). Processa **todas as regiões de uma vez** — nunca um laço "pra cada cidade, simule". É exatamente como o HOI4 faz.
- **Visualização:** o **LOD** (PDF 03) decide o detalhe do **desenho**, não da simulação. A região visível desenha em detalhe (tiles, sprites); as outras 200 são ícone + número. **Culling**: só desenha o que está na viewport.

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

### 6. Ordem de implementação (escopo — manter o "dar certo")

As lentes entram **uma de cada vez**, depois que a base estratégica roda. Tentar as quatro de uma vez é o caminho clássico pra empacar.

1. **Base (já em andamento):** render de mapa de tiles, lente estratégica (M0).
2. **Lente País / Mapa** — a mais próxima do que já existe.
3. **Lente Cidade isométrica** — a mais trabalhosa (ordenação, sprites, elevação).
4. **Lente Multimundos.**

**Importante desde já:** a arquitetura de **câmera + LOD** deve ser desenhada para **acomodar as quatro lentes** desde o início — assim adicionar uma lente nova não dói. O *princípio de ouro* (Seção 1) vale para **todo** o código de simulação agora, mesmo antes das lentes existirem.

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
