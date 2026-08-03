# world/entities/

`Polity`, `Lider`, `TipoDeGoverno` (PDF 06 §2) chegaram no **M2** (PDF 20), junto com o catálogo de governos e a IA heurística. `Faction` (facções, PDF 06 §2/PDF 11 §3) fica pro marco que precisar dela de verdade — as equações completas de risco de golpe/revolução do PDF 17 §2.

## Entidades adicionadas na expansão de ativos

- **`Construcao`** — schema PDF 21 §1. 120 construções (10 por era × 12 eras) em `catalogo_construcoes.gd`, cada uma com custo, manutenção e bônus em estabilidade/economia/defesa/cultura/ciência. As regiões referenciam construções por id.
- **`Tecnologia`** — schema PDF 05 §3. 48 tecnologias (4 por era × 12 eras) em `catalogo_tecnologias.gd`, organizadas em 4 ramos (base, military, economy, culture).
- **`Recurso`** — schema PDF 08 §1. 24 recursos (2 por era × 12 eras) que afetam produção e comércio.
- **`catalogo_lideres.gd`** — 60 líderes (5 por era × 12 eras), cada um com arquétipo e traços de personalidade únicos. Os retratos SVG estão em `assets/leaders/`.
