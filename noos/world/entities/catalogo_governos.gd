## Carrega o catálogo de governos de data/governos.json — PDF 10 §3
## (expansível: crescer é preencher o JSON, nunca reescrever código).
## 54 governos pelas 12 eras (PDF 05 §4). Toda polity começa "tribo";
## os demais só por transição (PDF 10 §5), nunca de largada.
class_name CatalogoDeGovernos
extends RefCounted

const CAMINHO_JSON := "res://data/governos.json"

# Cache de módulo — o JSON é lido uma vez só por execução.
static var _cache: Dictionary = {}


## Retorna { id (String) -> TipoDeGoverno }. Lê o JSON na primeira
## chamada e cacheia. Se o arquivo faltar/estiver inválido, cai num
## catálogo mínimo embutido (nunca deixa o jogo sem ao menos a Tribo).
static func catalogo() -> Dictionary:
	if not _cache.is_empty():
		return _cache

	var texto := _ler_arquivo(CAMINHO_JSON)
	if texto == "":
		_cache = _catalogo_minimo()
		return _cache

	var dados: Variant = JSON.parse_string(texto)
	if typeof(dados) != TYPE_DICTIONARY or not dados.has("governos"):
		push_error("governos.json inválido — usando catálogo mínimo")
		_cache = _catalogo_minimo()
		return _cache

	var resultado: Dictionary = {}
	for entrada in dados["governos"]:
		var tipo := _de_dicionario(entrada)
		if tipo != null:
			resultado[tipo.id] = tipo
	if resultado.is_empty():
		resultado = _catalogo_minimo()
	_cache = resultado
	return _cache


static func _ler_arquivo(caminho: String) -> String:
	if not FileAccess.file_exists(caminho):
		push_error("governos.json não encontrado em %s" % caminho)
		return ""
	var arquivo := FileAccess.open(caminho, FileAccess.READ)
	if arquivo == null:
		return ""
	var texto := arquivo.get_as_text()
	arquivo.close()
	return texto


static func _de_dicionario(entrada: Dictionary) -> TipoDeGoverno:
	if not entrada.has("id"):
		return null
	var tipo := TipoDeGoverno.new()
	tipo.id = entrada.get("id", "")
	tipo.nome = entrada.get("nome", tipo.id)
	tipo.nome_en = entrada.get("nome_en", tipo.nome)
	tipo.era = entrada.get("era", "pedra")
	tipo.concentracao_poder = float(entrada.get("concentracao_poder", 0.5))
	tipo.tendencia_corrupcao = float(entrada.get("tendencia_corrupcao", 0.3))
	tipo.militarismo = float(entrada.get("militarismo", 0.5))
	tipo.liberdades_civis = float(entrada.get("liberdades_civis", 0.5))
	tipo.estabilidade_base = float(entrada.get("estabilidade_base", 0.5))
	tipo.bonus = entrada.get("bonus", "")
	tipo.penalidade = entrada.get("penalidade", "")
	tipo.consequencia = entrada.get("consequencia", "")
	var manutencao: Dictionary = entrada.get("manutencao", {})
	tipo.manutencao_descricao = manutencao.get("descricao", "")
	tipo.manutencao_recurso = manutencao.get("recurso", "consenso")
	tipo.manutencao_limiar = float(manutencao.get("limiar", 0.4))
	tipo.manutencao_falha = manutencao.get("falha", "")
	return tipo


## Rede de segurança: só a Tribo, caso o JSON falhe. O jogo nunca fica
## sem o governo inicial.
static func _catalogo_minimo() -> Dictionary:
	var tribo := TipoDeGoverno.new()
	tribo.id = "tribo"
	tribo.nome = "Tribo"
	tribo.nome_en = "Tribe"
	tribo.era = "pedra"
	tribo.concentracao_poder = 0.2
	tribo.tendencia_corrupcao = 0.15
	tribo.militarismo = 0.5
	tribo.liberdades_civis = 0.85
	tribo.estabilidade_base = 0.55
	tribo.manutencao_recurso = "comida"
	tribo.manutencao_limiar = 0.2
	return {"tribo": tribo}
