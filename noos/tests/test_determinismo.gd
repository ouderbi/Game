## Teste headless de determinismo e demografia — checklist "pronto" do
## PDF 20 §4. Rodar (sem editor, sem janela):
##   godot4 --headless --path noos --script res://tests/test_determinismo.gd
## Sai com código 0 se tudo passar, 1 se algo falhar (útil pra CI).
extends SceneTree


func _initialize() -> void:
	var ok := true
	ok = _testar_geracao_deterministica() and ok
	ok = _testar_tick_avanca() and ok
	ok = _testar_regioes_cobrem_terra() and ok
	ok = _testar_populacao_cresce_com_excedente() and ok
	ok = _testar_populacao_cai_com_escassez() and ok

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
