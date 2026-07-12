## Geração procedural do mundo — PDF 04 §4: semente → ruído → altitude
## (+ latitude) → biomas. Determinístico: a mesma semente sempre produz
## o mesmo mapa (PDF 03 §4). Tamanho aqui é o placeholder do M0; o alvo de
## referência da lente País (1024×1024, PDF 24) chega quando o renderizador
## de tiles evoluir além do `_draw()` simples desta primeira versão.
class_name GeradorDeMapa
extends RefCounted


static func gerar(semente: int, largura: int, altura: int) -> EstadoDoMundo:
	var ruido := FastNoiseLite.new()
	ruido.seed = semente
	ruido.frequency = 0.06

	var estado := EstadoDoMundo.new()
	estado.semente = semente
	estado.largura = largura
	estado.altura = altura
	estado.biomas = PackedByteArray()
	estado.biomas.resize(largura * altura)

	for y in range(altura):
		# 0.0 no equador (meio do mapa), 1.0 nos polos (topo/base).
		var latitude := absf(float(y) / float(altura) - 0.5) * 2.0
		for x in range(largura):
			var elevacao := ruido.get_noise_2d(x, y)  # -1..1
			estado.biomas[y * largura + x] = _classificar_bioma(elevacao, latitude)

	return estado


static func _classificar_bioma(elevacao: float, latitude: float) -> int:
	if elevacao < -0.15:
		return Bioma.Tipo.OCEANO
	if elevacao > 0.45:
		return Bioma.Tipo.MONTANHA
	if latitude > 0.7:
		return Bioma.Tipo.TUNDRA
	if latitude < 0.25 and elevacao < 0.05:
		return Bioma.Tipo.DESERTO
	if elevacao > 0.15:
		return Bioma.Tipo.FLORESTA
	return Bioma.Tipo.PLANICIE
