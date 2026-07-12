# Leviatã

Protótipo de grande estratégia 2D orientado por simulação emergente. O projeto
segue a especificação em [`docs/specs`](docs/specs) e está sendo construído por
marcos incrementais.

## Estado atual

O **M0 — Esqueleto** está disponível:

- mundo procedural determinístico por semente;
- mapa de tiles com biomas, regiões e fronteiras;
- loop de simulação com passo fixo;
- pausa e velocidades 1x, 2x e 3x;
- câmera com pan e zoom;
- painel mínimo com estado do relógio e da seleção;
- execução headless para automação.

## Requisitos

- Python 3.11+

## Instalação

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install -e ".[dev]"
```

## Executar

```bash
python main.py
```

Controles:

| Entrada | Ação |
|---|---|
| `Espaço` | pausar/continuar |
| `1`, `2`, `3` | alterar velocidade |
| `WASD` ou setas | mover câmera |
| roda do mouse | zoom |
| botão esquerdo | selecionar tile |
| botão direito + arrastar | mover câmera |
| `R` | centralizar câmera |
| `Esc` | sair |

Uma simulação sem janela pode ser executada com:

```bash
python main.py --headless --ticks 1000 --seed 42
```

## Desenvolvimento

```bash
ruff check .
mypy leviata tests
pytest
python -m build
```

## Estrutura

```text
leviata/
├── core/       # relógio e simulação determinística
├── world/      # estado e geração procedural
├── render/     # câmera e desenho pygame
└── ui/         # sobreposição de interface
```

Leia [`CLAUDE.md`](CLAUDE.md) para as convenções de arquitetura e
[`docs/specs/20_roadmap_convencoes.md`](docs/specs/20_roadmap_convencoes.md)
para a ordem dos próximos marcos.