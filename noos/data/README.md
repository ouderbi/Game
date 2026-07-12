# data/

Catálogo de dados do jogo, separados do código (data-driven — PDF 10 §3, PDF 23 §7). Crescer o conteúdo é **preencher estes arquivos**, nunca reescrever GDScript.

## `governos.json`

As **54 formas de governo** espalhadas pelas 12 eras (PDF 05 §4). Cada entrada tem:

- **atributos** (`concentracao_poder`, `tendencia_corrupcao`, `militarismo`, `liberdades_civis`, `estabilidade_base`) — 0 a 1;
- **bonus / penalidade / consequencia** — a identidade de design do governo (PDF 10 §1, PDF 23 §4): o que faz de bom, o que custa, o que faz da civilização;
- **manutencao** — o esforço constante pra manter o governo de pé (`recurso`, `limiar`, `descricao`, `falha`). Se o recurso cai abaixo do limiar, a estabilidade despenca e o governo caminha pro colapso/transição (PDF 01 §7, PDF 10 §5, PDF 17). Recursos: `comida`, `consenso`, `riqueza` já são simulados; `forca_militar`, `pesquisa`, `coesao`, `fe`, `dados`, `energia` ficam prontos no schema até os sistemas que os alimentam existirem.

Carregado por `world/entities/catalogo_governos.gd`. **Sem favoritismo**: cada governo tem trade-off real, nenhum é estritamente melhor. Toda polity começa `tribo` (PDF 05 §4) e só chega aos demais por transição (PDF 10 §5).

**Nota de export (Godot):** ao gerar builds, inclua `*.json` no filtro de recursos do export preset — arquivos `.json` não são recursos importados, então precisam ser adicionados explicitamente pra irem no `.exe`. Rodando pelo editor, funciona sem configurar nada.
