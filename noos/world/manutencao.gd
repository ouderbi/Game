## Manutenção de governo — o que o jogador precisa sustentar o tempo todo
## pra manter a forma de governo de pé (ditadura → militares fortes; feudo
## → comida e proteção; tecnocracia → pesquisa). Se o recurso de
## manutenção cai abaixo do limiar do governo, a estabilidade despenca e
## o governo caminha pro colapso/transição — ninguém avisa, a consequência
## vem sozinha (PDF 01 §7, PDF 10 §5, PDF 17).
##
## Alguns recursos já são simulados de verdade (comida, consenso, riqueza);
## os que dependem de sistemas ainda não construídos (militar, pesquisa,
## coesão, fé, dados, energia) retornam "pendente" e não penalizam nada
## por enquanto — o schema fica pronto, e o dia em que esses sistemas
## existirem, a manutenção passa a valer sem tocar nesta lógica.
class_name Manutencao
extends RefCounted

## Recursos que já têm simulação de verdade hoje.
const RECURSOS_VIVOS := ["comida", "consenso", "riqueza"]

const STATUS_OK := "ok"
const STATUS_FALHANDO := "falhando"
const STATUS_PENDENTE := "pendente"  ## recurso ainda não simulado (schema pronto)


## Avalia a manutenção de uma polity. Retorna:
##   { recurso, valor (-1 se pendente), limiar, status, deficit (0-1) }
static func avaliar(
	tipo_governo: TipoDeGoverno, polity: Polity, regioes: Array[Regiao]
) -> Dictionary:
	var recurso := tipo_governo.manutencao_recurso
	var limiar := tipo_governo.manutencao_limiar
	var valor := _valor_recurso(recurso, polity, regioes)

	if valor < 0.0:
		return {
			"recurso": recurso,
			"valor": -1.0,
			"limiar": limiar,
			"status": STATUS_PENDENTE,
			"deficit": 0.0,
		}

	var deficit := maxf(limiar - valor, 0.0)
	var status := STATUS_OK if deficit <= 0.0 else STATUS_FALHANDO
	return {
		"recurso": recurso,
		"valor": valor,
		"limiar": limiar,
		"status": status,
		"deficit": deficit,
	}


## Valor 0-1 do recurso de manutenção pra esta polity. Retorna -1.0 pra
## recursos ainda não simulados (pendentes).
static func _valor_recurso(recurso: String, polity: Polity, regioes: Array[Regiao]) -> float:
	match recurso:
		"comida":
			return _fracao_media(regioes, func(r): return _excedente_comida(r))
		"consenso":
			return _fracao_media(regioes, func(r): return r.humor_medio)
		"riqueza":
			# Combina riqueza das regiões com o tesouro da polity (PDF 08).
			var riqueza_regioes := _fracao_media(regioes, func(r): return r.riqueza_media)
			var fator_tesouro := clampf(polity.tesouro / 300.0, 0.0, 1.0)
			return (riqueza_regioes + fator_tesouro) / 2.0
		_:
			return -1.0  # militar/pesquisa/coesao/fe/dados/energia: pendente


## Excedente de comida da região como fração 0-1 (0 = fome, 1 = fartura).
## necessidade = população × consumo per capita (1.0, PDF 08 §1/§6).
static func _excedente_comida(regiao: Regiao) -> float:
	if regiao.capacidade_alimento <= 0.0:
		return 0.0
	var necessidade := regiao.populacao_total * 1.0
	var excedente := regiao.capacidade_alimento - necessidade
	return clampf(excedente / regiao.capacidade_alimento, 0.0, 1.0)


static func _fracao_media(regioes: Array[Regiao], extrator: Callable) -> float:
	if regioes.is_empty():
		return 0.0
	var soma := 0.0
	for regiao in regioes:
		soma += float(extrator.call(regiao))
	return soma / regioes.size()
