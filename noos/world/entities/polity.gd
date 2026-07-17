## Uma polity — qualquer unidade política, governo ou não-governo
## (glossário do PDF 01 §10; schema do PDF 06 §2, subconjunto). Referências
## por id, nunca por objeto direto (PDF 06 §4) — mantém save/load simples
## e evita ciclos quando polities/líderes forem serializados (M5).
class_name Polity
extends RefCounted

var id: int
var nome: String
var tipo_governo_id: String
var leader_id: int
var region_ids: Array[int] = []

## true só pra "Sua Polity" — decisões vêm da fila de ações do jogador
## (EstadoDoMundo.fila_acoes_jogador) em vez do Decisor heurístico
## (SimulacaoPolitica.avancar). PDF 19 §2: clique do jogador → ação
## enfileirada → aplicada pelo MESMO pipeline do tick que a IA usa.
var eh_jogador: bool = false

## Era atual (PDF 05 §4) — hoje sempre "pedra" (sem árvore de eras ainda,
## M5). Já existe pra filtrar candidatos de transição de governo por era
## desde já (TransicaoDeGoverno), sem precisar mexer nesse código quando
## a progressão de eras chegar.
var era: String = "pedra"

var tesouro: float = 100.0
var corrupcao: float = 0.1
var estabilidade: float = 0.6
var legitimidade: float = 0.6

## Registro simples de transições — alimenta a tela de legado (PDF 02 §7)
## quando ela existir. Cada entrada: "tick:governo_antigo->governo_novo:motivo".
var historico_governos: Array[String] = []
