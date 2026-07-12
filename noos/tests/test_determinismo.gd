## Teste headless de determinismo — checklist "pronto" do PDF 20 §4.
## Rodar (sem editor, sem janela):
##   godot4 --headless --path noos --script res://tests/test_determinismo.gd
## Sai com código 0 se tudo passar, 1 se algo falhar (útil pra CI).
extends SceneTree


func _initialize() -> void:
	var ok := true
	ok = _testar_geracao_deterministica() and ok
	ok = _testar_tick_avanca() and ok

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
