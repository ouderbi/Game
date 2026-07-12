## Particiona o grid de tiles em regiões — PDF 04 §1 (a simulação opera
## sobre regiões, nunca sobre os tiles individuais). M1: blocos fixos de
## tiles; blocos 100% oceano viram nenhuma região (terra desabitada só
## existe se tiver ao menos um tile não-oceânico).
class_name GeradorDeRegioes
extends RefCounted

const TAMANHO_BLOCO := 8

## Capacidade de sustento por tile de cada bioma — PDF 04 §2, abstrato
## (unidades de população que aquele tile sozinho sustenta).
const CAPACIDADE_POR_BIOMA := {
	Bioma.Tipo.OCEANO: 0.0,
	Bioma.Tipo.PLANICIE: 10.0,
	Bioma.Tipo.FLORESTA: 7.0,
	Bioma.Tipo.DESERTO: 2.0,
	Bioma.Tipo.MONTANHA: 1.0,
	Bioma.Tipo.TUNDRA: 2.0,
}

## Fração inicial da capacidade que a região começa povoada — deixa
## espaço pra crescimento em vez de já nascer no teto (PDF 07 §6).
const OCUPACAO_INICIAL := 0.4


static func gerar(estado: EstadoDoMundo) -> Array[Regiao]:
	var regioes: Array[Regiao] = []
	var proximo_id := 0

	var y := 0
	while y < estado.altura:
		var x := 0
		while x < estado.largura:
			var regiao := _construir_bloco(estado, x, y, proximo_id)
			if regiao != null:
				regioes.append(regiao)
				proximo_id += 1
			x += TAMANHO_BLOCO
		y += TAMANHO_BLOCO

	return regioes


static func _construir_bloco(
	estado: EstadoDoMundo, origem_x: int, origem_y: int, id: int
) -> Regiao:
	var tiles: Array[Vector2i] = []
	var contagem_biomas: Dictionary = {}
	var capacidade := 0.0

	var fim_y: int = mini(origem_y + TAMANHO_BLOCO, estado.altura)
	var fim_x: int = mini(origem_x + TAMANHO_BLOCO, estado.largura)

	for y in range(origem_y, fim_y):
		for x in range(origem_x, fim_x):
			var tipo := estado.bioma_em(x, y)
			tiles.append(Vector2i(x, y))
			contagem_biomas[tipo] = contagem_biomas.get(tipo, 0) + 1
			capacidade += CAPACIDADE_POR_BIOMA.get(tipo, 0.0)

	if capacidade <= 0.0:
		return null  # bloco só de oceano/tiles sem capacidade — não vira região

	var regiao := Regiao.new()
	regiao.id = id
	regiao.tiles = tiles
	regiao.bioma_predominante = _bioma_mais_comum(contagem_biomas)
	regiao.capacidade_alimento = capacidade
	regiao.populacao_total = capacidade * OCUPACAO_INICIAL
	return regiao


static func _bioma_mais_comum(contagem_biomas: Dictionary) -> int:
	var melhor_tipo: int = Bioma.Tipo.OCEANO
	var melhor_contagem := -1
	for tipo in contagem_biomas:
		var contagem: int = contagem_biomas[tipo]
		if contagem > melhor_contagem:
			melhor_contagem = contagem
			melhor_tipo = tipo
	return melhor_tipo
