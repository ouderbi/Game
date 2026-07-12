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
const Decisor = preload("res://brains/decider.gd")
const DecisorHeuristico = preload("res://brains/heuristic.gd")
const Manutencao = preload("res://world/manutencao.gd")
const EstadoDoMundo = preload("res://world/world_state.gd")
const TransicaoDeGoverno = preload("res://world/transicao_governo.gd")


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
	ok = _testar_ruido_da_heuristica_e_deterministico() and ok
	ok = _testar_catalogo_cobre_todas_eras() and ok
	ok = _testar_manutencao_falhando_desestabiliza() and ok
	ok = _testar_colapso_vira_estado_falido() and ok
	ok = _testar_transicao_e_deterministica() and ok
	ok = _testar_transicao_respeita_era() and ok

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
	if catalogo.size() < 50:
		print("FALHA: catálogo de governos tem menos de 50 entradas (%d)" % catalogo.size())
		return false
	if not catalogo.has("tribo"):
		print("FALHA: catálogo sem 'tribo' (governo inicial)")
		return false
	for id in catalogo:
		var tipo: TipoDeGoverno = catalogo[id]
		if tipo.id != id:
			print("FALHA: chave do catálogo '%s' não bate com o id do tipo '%s'" % [id, tipo.id])
			return false
		if tipo.manutencao_recurso == "":
			print("FALHA: governo '%s' sem recurso de manutenção" % id)
			return false
	print("OK: catálogo de governos consistente (%d tipos, todos com manutenção)" % catalogo.size())
	return true


func _testar_catalogo_cobre_todas_eras() -> bool:
	var catalogo := CatalogoDeGovernos.catalogo()
	var eras := [
		"pedra",
		"antiguidade",
		"classica",
		"medieval",
		"industrial",
		"moderna",
		"informacao",
		"alta_tecnologia",
		"espacial",
		"interplanetaria",
		"estelar",
		"intergalactica",
	]
	var eras_presentes := {}
	for id in catalogo:
		eras_presentes[catalogo[id].era] = true
	for era in eras:
		if not eras_presentes.has(era):
			print("FALHA: nenhuma forma de governo na era '%s'" % era)
			return false
	print("OK: as 12 eras têm ao menos uma forma de governo")
	return true


func _testar_manutencao_falhando_desestabiliza() -> bool:
	# Uma tribo faminta (manutenção 'comida' falhando) deve perder mais
	# estabilidade que uma tribo farta, tudo o mais igual.
	var tipo_governo: TipoDeGoverno = CatalogoDeGovernos.catalogo()["tribo"]
	var lider := Lider.new()
	lider.competencia = 0.5
	lider.corruptibilidade = 0.5

	var farta := Polity.new()
	farta.estabilidade = 0.6
	farta.legitimidade = 0.6
	var regiao_farta := Regiao.new()
	regiao_farta.capacidade_alimento = 100.0
	regiao_farta.populacao_total = 10.0  # muita comida sobrando
	regiao_farta.humor_medio = 0.6
	regiao_farta.riqueza_media = 0.3

	var faminta := Polity.new()
	faminta.estabilidade = 0.6
	faminta.legitimidade = 0.6
	var regiao_faminta := Regiao.new()
	regiao_faminta.capacidade_alimento = 100.0
	regiao_faminta.populacao_total = 98.0  # população quase no teto: excedente ínfimo
	regiao_faminta.humor_medio = 0.6
	regiao_faminta.riqueza_media = 0.3

	for i in range(40):
		CalculadoraDeEstabilidade.avancar(farta, tipo_governo, lider, [regiao_farta])
		CalculadoraDeEstabilidade.avancar(faminta, tipo_governo, lider, [regiao_faminta])

	if faminta.estabilidade >= farta.estabilidade:
		print(
			(
				"FALHA: manutenção falhando não reduziu estabilidade (faminta %.3f >= farta %.3f)"
				% [faminta.estabilidade, farta.estabilidade]
			)
		)
		return false
	print("OK: governo com manutenção falhando fica menos estável que um mantido")
	return true


func _testar_estabilidade_reage_a_prosperidade() -> bool:
	var polity := Polity.new()
	polity.legitimidade = 0.5
	polity.estabilidade = 0.5
	var tipo_governo: TipoDeGoverno = CatalogoDeGovernos.catalogo()["republica_democratica"]
	var lider := Lider.new()
	lider.competencia = 0.8
	lider.corruptibilidade = 0.2

	var regiao_prospera := Regiao.new()
	regiao_prospera.capacidade_alimento = 100.0
	regiao_prospera.populacao_total = 50.0
	regiao_prospera.riqueza_media = 0.9
	regiao_prospera.humor_medio = 0.9

	for i in range(50):
		CalculadoraDeEstabilidade.avancar(polity, tipo_governo, lider, [regiao_prospera])

	if polity.estabilidade <= 0.5:
		print("FALHA: estabilidade não subiu com prosperidade/moral altas")
		return false
	print("OK: estabilidade sobe com prosperidade e moral altas")
	return true


func _testar_ruido_da_heuristica_e_deterministico() -> bool:
	var decisor := DecisorHeuristico.new()
	var briefing := {
		"tesouro_baixo": 0.5,
		"moral_baixa": 0.5,
		"ambicao": 0.5,
		"competencia": 0.3,
		"agressao": 0.5,
		"paranoia": 0.5,
		"semente_ruido": 42,
	}
	var decisao_a := decisor.decidir(briefing)
	var decisao_b := decisor.decidir(briefing)
	if str(decisao_a) != str(decisao_b):
		print("FALHA: mesma semente_ruido produziu decisões diferentes")
		return false

	var houve_variacao := false
	for semente in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]:
		briefing["semente_ruido"] = semente
		var decisao := decisor.decidir(briefing)
		if str(decisao) != str(decisao_a):
			houve_variacao = true
			break
	if not houve_variacao:
		print("FALHA: 10 sementes de ruído diferentes produziram sempre a mesma decisão")
		return false

	print("OK: ruído da heurística é determinístico por semente e varia entre sementes")
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


## Monta um EstadoDoMundo com uma polity Tribo em crise profunda (baixa
## estabilidade/legitimidade, alta corrupção, moral péssima) — usado
## pelos testes de transição de governo abaixo.
func _construir_estado_em_crise(semente: int, tick: int) -> EstadoDoMundo:
	var estado := EstadoDoMundo.new()
	estado.semente = semente
	estado.tick_atual = tick

	var regiao := Regiao.new()
	regiao.id = 0
	regiao.tiles = [Vector2i(0, 0)]
	regiao.capacidade_alimento = 10.0
	regiao.populacao_total = 5.0
	regiao.humor_medio = 0.05
	regiao.owner_polity_id = 0
	estado.regioes = [regiao]

	var polity := Polity.new()
	polity.id = 0
	polity.tipo_governo_id = "tribo"
	polity.era = "pedra"
	polity.estabilidade = 0.15  # baixa, mas acima do limiar de colapso (0.08)
	polity.legitimidade = 0.1
	polity.corrupcao = 0.9
	polity.region_ids = [0]
	estado.polities[0] = polity

	return estado


func _testar_colapso_vira_estado_falido() -> bool:
	var estado := _construir_estado_em_crise(99, 5)
	var polity: Polity = estado.polities[0]
	polity.estabilidade = 0.02  # abaixo do LIMIAR_COLAPSO (0.08)
	var tipo_governo: TipoDeGoverno = CatalogoDeGovernos.catalogo()["tribo"]

	TransicaoDeGoverno.avaliar_e_aplicar(estado, polity, tipo_governo)

	if polity.tipo_governo_id != "estado_falido":
		var msg := "FALHA: estabilidade abaixo do limiar de colapso não virou estado_falido ('%s')"
		print(msg % polity.tipo_governo_id)
		return false
	print("OK: colapso total (estabilidade < limiar) sempre vira estado_falido")
	return true


func _testar_transicao_e_deterministica() -> bool:
	var tipo: TipoDeGoverno = CatalogoDeGovernos.catalogo()["tribo"]
	for tick in range(1, 200):
		var estado_a := _construir_estado_em_crise(123, tick)
		var polity_a: Polity = estado_a.polities[0]
		TransicaoDeGoverno.avaliar_e_aplicar(estado_a, polity_a, tipo)

		if polity_a.tipo_governo_id == "tribo":
			continue  # não disparou nesse tick, tenta o próximo

		var estado_b := _construir_estado_em_crise(123, tick)
		var polity_b: Polity = estado_b.polities[0]
		TransicaoDeGoverno.avaliar_e_aplicar(estado_b, polity_b, tipo)

		if polity_a.tipo_governo_id != polity_b.tipo_governo_id:
			var msg := "FALHA: mesma semente/tick produziu transições diferentes (%s vs %s)"
			print(msg % [polity_a.tipo_governo_id, polity_b.tipo_governo_id])
			return false
		print(
			(
				"OK: transição é determinística (tick %d: tribo -> %s reproduzido)"
				% [tick, polity_a.tipo_governo_id]
			)
		)
		return true
	print("FALHA: nenhuma transição disparou em 200 ticks de crise — não deu pra testar")
	return false


func _testar_transicao_respeita_era() -> bool:
	var tipo: TipoDeGoverno = CatalogoDeGovernos.catalogo()["tribo"]
	var catalogo := CatalogoDeGovernos.catalogo()
	var achou_transicao := false

	for tick in range(1, 300):
		var estado := _construir_estado_em_crise(456, tick)
		var polity: Polity = estado.polities[0]
		TransicaoDeGoverno.avaliar_e_aplicar(estado, polity, tipo)

		if polity.tipo_governo_id == "tribo":
			continue
		achou_transicao = true

		var alvo: TipoDeGoverno = catalogo.get(polity.tipo_governo_id)
		if alvo == null:
			print("FALHA: transição foi pra um id inexistente '%s'" % polity.tipo_governo_id)
			return false
		if alvo.era != "pedra" and alvo.era != "qualquer":
			var msg := "FALHA: transição foi pra um governo da era '%s' (polity era 'pedra')"
			print(msg % alvo.era)
			return false

	if not achou_transicao:
		print("FALHA: nenhuma transição disparou em 300 ticks — não deu pra testar o filtro de era")
		return false
	print("OK: transições respeitam a era da polity")
	return true
