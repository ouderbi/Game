# Noós — convenções pro Claude Code

Projeto de grande estratégia com líderes movidos por LLM (Godot 4 / GDScript). Especificação completa em `01_visao_e_pilares.md` … `29_audio_musica_sfx.md` — leia-os como contexto antes de mexer em qualquer sistema; comece por `20_roadmap_convencoes.md` (ordem dos marcos) e `03_arquitetura_tecnica.md` (arquitetura).

## Stack

- **Godot 4.3+**, GDScript. Renderer `gl_compatibility` (não Forward+) — evita tela em branco em GPUs/drivers mais antigos no Windows.
- Código do jogo vive em `noos/`, estrutura de módulos definida no PDF 03 §2.

## Regras de ouro (não violar)

1. **A simulação nunca espera a rede.** Chamadas de LLM são assíncronas (`HTTPRequest`); se atrasarem/caírem, cai no fallback heurístico naquele tick.
2. **Simulação sempre agregada por região** — nunca por tile individual nem por cidadão, em nenhuma escala de mapa (PDF 03 §6, PDF 24 §1). O grid de tiles é resolução visual, não unidade de cálculo.
3. **Tick fixo + semente = determinismo.** Mesma semente → mesmo mundo, sempre reproduzível (essencial pra debug e para os testes headless — PDF 27).
4. **A engine é a autoridade final.** LLM e jogador propõem ações; a simulação valida e aplica — nunca aplica direto (PDF 13 §8).
5. **Liberdade total, inclusive a de errar.** Nunca adicionar confirmações tipo "tem certeza?" pra decisões ruins — as consequências vêm sozinhas (PDF 01 §7).

## Idioma

- Identificadores e comentários de código em **português**.
- Textos de jogo (UI, falas dos líderes) em **PT-BR e EN** desde o M5 (PDF 19 §8).
- Nomes de arquivo/pasta seguem o inglês já fixado no PDF 03 §2 (`core/`, `world/`, `brains/`...).

## Ordem de construção

Siga os marcos do PDF 20 §2 (M0 → M6 → pós-M6), sempre entregando algo rodável antes de abrir o próximo módulo. Checklist "pronto" por módulo: PDF 20 §4.

## Godot — armadilhas já mapeadas

- Um autoload **não pode** ter o mesmo nome de um `class_name` (erro de parse que barra o boot inteiro). Se um script é autoload, não lhe dê `class_name`.
- `Camera2D.enabled` (não `.current` — isso é Godot 3.x).
- Pra pegar o tamanho do viewport fora de um `Control`, use `get_viewport().get_visible_rect().size` (não `get_viewport_rect()`, que é método de `Control`).
- Sem acesso a um binário do Godot neste ambiente de desenvolvimento remoto — valide sintaxe com `gdlint` (`pip install gdtoolkit`) e rode os testes headless (`tests/test_determinismo.gd`) na sua máquina antes de assumir que algo funciona.

## Testes

`noos/tests/`: testes headless (`godot4 --headless --path noos --script res://tests/test_determinismo.gd`). Todo módulo novo ganha pelo menos um teste determinístico antes de fechar o marco.
