## Teste headless de determinismo e demografia — checklist "pronto" do
## PDF 20 §4. Rodar (sem editor, sem janela):
##   godot4 --headless --path noos --script res://tests/test_determinismo.gd
## Sai com código 0 se tudo passar, 1 se algo falhar (útil pra CI).
##
## Se o Godot nunca abriu este projeto no editor ainda, o cache de
## class_name globais (.godot/global_script_class_cache.cfg, gitignored
## de propósito) pode não existir num checkout novo. Por isso este script
## usa preload() explícito abaixo em vez de depender só do class_name
## global — funciona mesmo sem esse cache. Se preferir "aquecer" o cache
## de qualquer forma (deixa outros scripts mais rápidos de checar), rode
## uma vez antes: godot4 --headless --path noos --editor --quit-after 2
extends SceneTree

const GeradorDeMapa = preload("res://world/map_generator.gd")
const Simulacao = preload("res://core/sim.gd")
const GeradorDeRegioes = preload("res://world/region_generator.gd")
const Regiao = preload("res://world/region.gd")
const SimulacaoPopulacional = preload("res://world/populacao.gd")
const CatalogoDeGovernos = preload("res://world/entities/catalogo_governos.gd")
const TipoDeGoverno = preload("res://world/entities/government_type.gd")
const Polity = preload("res://world/entities/polity.gd")
const Lider = preload("res://world/entities/leader.gd")
const CalculadoraDeEstabilidade = preload("res://world/estabilidade.gd")
const SimulacaoPolitica = preload("res://world/simulacao_politica.gd")


func _initialize() -> void:
	var ok := true
	ok = _testar_geracao_deterministica() and ok
	ok = _testar_tick_avanca() and ok
	ok = _testar_regioes_cobrem_terra() and ok
	ok = _testar_populacao_cresce_com_excedente() and ok
	ok = _testar_populacao_cai_com_escassez() and ok
	ok = _testar_catalogo_governos() and ok
	ok = _testar_estabilidade_reage_a_prosperidade() and ok
	ok = _testar_simulacao_politica_nao_quebra() and ok

	if ok:
		print("OK: todos os testes passaram")
		quit(0)
	else:
		print("FALHOU: ver mensagens acima")
		quit(1)


func _testar_geracao_deterministica() -> bool:
	var a := GeradorDeMapa.gerar(1337, 32, 24)
	var b := GeradorDeMapa.gerar(1337, 32, 24)
	if a.biomas != b.biomas:
		print("FALHA: a mesma semente gerou mapas de biomas diferentes")
		return false
	print("OK: geração de mapa é determinística (mesma semente -> mesmo mapa)")
	return true


func _testar_tick_avanca() -> bool:
	var estado := GeradorDeMapa.gerar(1, 4, 4)
	var simulacao := Simulacao.new()
	for i in range(10):
		simulacao.passo(estado)
	if estado.tick_atual != 10:
		print("FALHA: esperava tick_atual == 10, ficou em %d" % estado.tick_atual)
		return false
	print("OK: simulação avança um tick determinístico por passo()")
	return true


func _testar_regioes_cobrem_terra() -> bool:
	var estado := GeradorDeMapa.gerar(1337, 64, 48)
	estado.regioes = GeradorDeRegioes.gerar(estado)
	if estado.regioes.is_empty():
		print("FALHA: geração de regiões não criou nenhuma região")
		return false
	for regiao in estado.regioes:
		if regiao.capacidade_alimento <= 0.0:
			print("FALHA: região %d sem capacidade positiva não devia existir" % regiao.id)
			return false
	print("OK: %d regiões geradas, todas com capacidade positiva" % estado.regioes.size())
	return true


func _testar_populacao_cresce_com_excedente() -> bool:
	var regiao := Regiao.new()
	regiao.capacidade_alimento = 100.0
	regiao.populacao_total = 40.0
	var inicial := regiao.populacao_total
	for i in range(20):
		SimulacaoPopulacional.avancar(regiao)
	if regiao.populacao_total <= inicial:
		print("FALHA: população não cresceu com excedente de comida")
		return false
	if regiao.populacao_total > regiao.capacidade_alimento:
		var msg := "FALHA: população ultrapassou a capacidade (%f > %f)"
		print(msg % [regiao.populacao_total, regiao.capacidade_alimento])
		return false
	print("OK: população cresce com excedente e respeita o teto de capacidade")
	return true


func _testar_populacao_cai_com_escassez() -> bool:
	var regiao := Regiao.new()
	regiao.capacidade_alimento = 10.0
	regiao.populacao_total = 100.0
	var inicial := regiao.populacao_total
	for i in range(20):
		SimulacaoPopulacional.avancar(regiao)
	if regiao.populacao_total >= inicial:
		print("FALHA: população não caiu com escassez de comida")
		return false
	print("OK: população cai com escassez (fome)")
	return true


func _testar_catalogo_governos() -> bool:
	var catalogo := CatalogoDeGovernos.catalogo()
	if catalogo.size() < 4:
		print("FALHA: catálogo de governos tem menos de 4 entradas")
		return false
	for id in catalogo:
		var tipo: TipoDeGoverno = catalogo[id]
		if tipo.id != id:
			print("FALHA: chave do catálogo '%s' não bate com o id do tipo '%s'" % [id, tipo.id])
			return false
	print("OK: catálogo de governos consistente (%d tipos)" % catalogo.size())
	return true


func _testar_estabilidade_reage_a_prosperidade() -> bool:
	var polity := Polity.new()
	polity.legitimidade = 0.5
	polity.estabilidade = 0.5
	var tipo_governo: TipoDeGoverno = CatalogoDeGovernos.catalogo()["republica_democratica"]

	var regiao_prospera := Regiao.new()
	regiao_prospera.capacidade_alimento = 100.0
	regiao_prospera.populacao_total = 50.0
	regiao_prospera.riqueza_media = 0.9
	regiao_prospera.humor_medio = 0.9

	for i in range(50):
		CalculadoraDeEstabilidade.avancar(polity, tipo_governo, [regiao_prospera])

	if polity.estabilidade <= 0.5:
		print("FALHA: estabilidade não subiu com prosperidade/moral altas")
		return false
	print("OK: estabilidade sobe com prosperidade e moral altas")
	return true


func _testar_simulacao_politica_nao_quebra() -> bool:
	var estado := GeradorDeMapa.gerar(7, 32, 24)
	estado.regioes = GeradorDeRegioes.gerar(estado)
	if estado.regioes.is_empty():
		print("FALHA: sem regiões pra testar SimulacaoPolitica")
		return false

	estado.tipos_de_governo = CatalogoDeGovernos.catalogo()
	var lider := Lider.new()
	lider.id = 0
	lider.ambicao = 0.5
	lider.competencia = 0.5
	estado.lideres[0] = lider

	var polity := Polity.new()
	polity.id = 0
	polity.tipo_governo_id = "tribo"
	polity.leader_id = 0
	polity.region_ids = [estado.regioes[0].id]
	estado.regioes[0].owner_polity_id = 0
	estado.polities[0] = polity

	for i in range(10):
		SimulacaoPolitica.avancar(estado)

	if polity.tesouro < 0.0 or is_nan(polity.tesouro):
		print("FALHA: tesouro inválido após SimulacaoPolitica (%f)" % polity.tesouro)
		return false
	if polity.estabilidade < 0.0 or polity.estabilidade > 1.0 or is_nan(polity.estabilidade):
		print("FALHA: estabilidade fora de [0,1] (%f)" % polity.estabilidade)
		return false
	print("OK: SimulacaoPolitica roda 10 ticks sem produzir estado inválido")
	return true
