## Demografia & economia básica por região — PDF 07 (necessidades,
## humor, ciclo de vida) e PDF 08 §1/§6 (produção vs. necessidade,
## escassez). Sempre agregado por região (PDF 06 §3) — nenhum indivíduo
## simulado aqui. Sem governo/tributação ainda (chega no M2).
class_name SimulacaoPopulacional
extends RefCounted

## Consumo médio por cabeça, nas mesmas unidades de capacidade_alimento.
const CONSUMO_PER_CAPITA := 1.0

## Taxa de crescimento logístico quando há excedente (PDF 07 §6).
const TAXA_CRESCIMENTO := 0.02

## Taxa de mortes por fome quando há escassez (PDF 08 §6, PDF 07 §6).
const TAXA_FOME := 0.03

## Velocidade com que o humor persegue seu alvo (PDF 07 §2).
const VELOCIDADE_HUMOR := 0.05


static func avancar(regiao: Regiao) -> void:
	if regiao.populacao_total <= 0.0:
		return

	var necessidade := regiao.populacao_total * CONSUMO_PER_CAPITA
	var excedente := regiao.capacidade_alimento - necessidade

	if excedente >= 0.0:
		# Crescimento logístico: desacelera perto da capacidade (PDF 07 §6).
		var espaco := 1.0 - (regiao.populacao_total / regiao.capacidade_alimento)
		regiao.populacao_total += TAXA_CRESCIMENTO * regiao.populacao_total * maxf(espaco, 0.0)
		_mover_humor(regiao, 0.8)
	else:
		# Escassez: produção não cobre a necessidade — fome (PDF 08 §6).
		var fracao_faltante := absf(excedente) / necessidade
		regiao.populacao_total -= regiao.populacao_total * TAXA_FOME * fracao_faltante
		regiao.populacao_total = maxf(regiao.populacao_total, 0.0)
		_mover_humor(regiao, clampf(0.5 - fracao_faltante, 0.0, 0.5))


static func _mover_humor(regiao: Regiao, alvo: float) -> void:
	regiao.humor_medio += (alvo - regiao.humor_medio) * VELOCIDADE_HUMOR
	regiao.humor_medio = clampf(regiao.humor_medio, 0.0, 1.0)
