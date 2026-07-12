## Demografia & economia básica por região — PDF 07 (necessidades,
## humor, ciclo de vida: nascimento/envelhecimento/morte) e PDF 08 §1/§6
## (produção vira riqueza; escassez gera fome). Sempre agregado por
## região (PDF 06 §3) — nenhum indivíduo simulado aqui. Sem governo/
## tributação ainda (chega no M2).
##
## Escopo deliberado do M1: a única necessidade modelada é comida
## (PDF 07 §2 lista comida/segurança/social/propósito; as outras três só
## ganham sentido quando houver ameaça militar, sociedade e facções —
## chegam nos marcos que introduzem esses sistemas).
##
## Nota de arquitetura: Regiao guarda os agregados como campos OOP
## diretos (array-of-structs), não como PackedArrays indexados por id
## (PDF 06 §3, structure-of-arrays). Dívida técnica consciente — vale a
## pena migrar quando o número de regiões crescer rumo às lentes
## Planeta/Galáxia (PDF 24, M6); no M1, com dezenas de regiões, a
## clareza do objeto compensa mais que a vetorização.
class_name SimulacaoPopulacional
extends RefCounted

## Consumo médio por cabeça, nas mesmas unidades de capacidade_alimento.
const CONSUMO_PER_CAPITA := 1.0

## Taxa de crescimento logístico quando há excedente (PDF 07 §6).
const TAXA_CRESCIMENTO := 0.02

## Taxa de mortes por fome quando há escassez (PDF 08 §6, PDF 07 §6).
const TAXA_FOME := 0.03

## Velocidade com que humor e saúde perseguem seu alvo (PDF 07 §2).
const VELOCIDADE_HUMOR := 0.05
const VELOCIDADE_SAUDE := 0.03

## Riqueza acumula com excedente de produção (PDF 08 §1: "produção vira
## bens e riqueza") e se consome em tempos de escassez.
const TAXA_ACUMULO_RIQUEZA := 0.05
const TAXA_CONSUMO_RIQUEZA := 0.02

## Ciclo de vida (PDF 07 §6): a idade média deriva devagar rumo a um
## alvo — mais jovem quando a população cresce (muitos nascimentos),
## mais velha quando estagna/encolhe. Passada a idade-base, uma
## mortalidade natural pequena entra em ação, independente de fome.
const VELOCIDADE_ENVELHECIMENTO := 0.02
const IDADE_ALVO_CRESCIMENTO := 25.0
const IDADE_ALVO_ESTAGNACAO := 45.0
const IDADE_MORTALIDADE_BASE := 55.0
const TAXA_MORTALIDADE_NATURAL_MAX := 0.01


static func avancar(regiao: Regiao) -> void:
	if regiao.populacao_total <= 0.0 or regiao.capacidade_alimento <= 0.0:
		return

	var necessidade := regiao.populacao_total * CONSUMO_PER_CAPITA
	var excedente := regiao.capacidade_alimento - necessidade

	if excedente >= 0.0:
		# Crescimento logístico: desacelera perto da capacidade (PDF 07 §6).
		var espaco := 1.0 - (regiao.populacao_total / regiao.capacidade_alimento)
		regiao.populacao_total += TAXA_CRESCIMENTO * regiao.populacao_total * maxf(espaco, 0.0)
		_mover_humor(regiao, 0.8)
		_mover_saude(regiao, 0.85)
		_mover_idade(regiao, IDADE_ALVO_CRESCIMENTO)
		regiao.riqueza_media += TAXA_ACUMULO_RIQUEZA * (excedente / regiao.capacidade_alimento)
	else:
		# Escassez: produção não cobre a necessidade — fome (PDF 08 §6).
		var fracao_faltante := absf(excedente) / necessidade
		regiao.populacao_total -= regiao.populacao_total * TAXA_FOME * fracao_faltante
		_mover_humor(regiao, clampf(0.5 - fracao_faltante, 0.0, 0.5))
		_mover_saude(regiao, clampf(0.6 - fracao_faltante, 0.0, 0.6))
		_mover_idade(regiao, IDADE_ALVO_ESTAGNACAO)
		regiao.riqueza_media -= TAXA_CONSUMO_RIQUEZA * fracao_faltante

	regiao.riqueza_media = clampf(regiao.riqueza_media, 0.0, 1.0)
	_aplicar_mortalidade_natural(regiao)
	regiao.populacao_total = maxf(regiao.populacao_total, 0.0)


static func _mover_humor(regiao: Regiao, alvo: float) -> void:
	regiao.humor_medio += (alvo - regiao.humor_medio) * VELOCIDADE_HUMOR
	regiao.humor_medio = clampf(regiao.humor_medio, 0.0, 1.0)


static func _mover_saude(regiao: Regiao, alvo: float) -> void:
	regiao.saude_media += (alvo - regiao.saude_media) * VELOCIDADE_SAUDE
	regiao.saude_media = clampf(regiao.saude_media, 0.0, 1.0)


static func _mover_idade(regiao: Regiao, alvo: float) -> void:
	regiao.idade_media += (alvo - regiao.idade_media) * VELOCIDADE_ENVELHECIMENTO
	regiao.idade_media = maxf(regiao.idade_media, 0.0)


static func _aplicar_mortalidade_natural(regiao: Regiao) -> void:
	var excesso_idade := regiao.idade_media - IDADE_MORTALIDADE_BASE
	if excesso_idade <= 0.0:
		return
	var taxa := clampf(excesso_idade / 100.0, 0.0, TAXA_MORTALIDADE_NATURAL_MAX)
	regiao.populacao_total -= regiao.populacao_total * taxa
