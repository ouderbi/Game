## Relógio da simulação — PDF 03 §4, PDF 02 §2.
## Autoload global "Relogio" (ver project.godot [autoload]). SEM class_name
## de propósito: o Godot 4 recusa um autoload cujo nome colide com uma
## classe global de mesmo nome ("Can't add Autoload: Invalid name..."),
## e ninguém no projeto usa este script como type hint — só como o
## singleton "Relogio" mesmo. Acumula tempo real e emite um "tick" em
## intervalos fixos, multiplicados pela velocidade escolhida (1x/2x/3x).
## Pausar não avança nenhum tick.
extends Node

signal tick
signal velocidade_alterada(multiplicador: float)
signal pausa_alterada(pausado: bool)

## Segundos por tick em velocidade 1x.
@export var intervalo_base_segundos: float = 0.5

var pausado: bool = false
var multiplicador_velocidade: float = 1.0

var _acumulador: float = 0.0


func _process(delta: float) -> void:
	if pausado:
		return
	_acumulador += delta * multiplicador_velocidade
	while _acumulador >= intervalo_base_segundos:
		_acumulador -= intervalo_base_segundos
		tick.emit()


func alternar_pausa() -> void:
	pausado = not pausado
	pausa_alterada.emit(pausado)


func definir_velocidade(multiplicador: float) -> void:
	multiplicador_velocidade = multiplicador
	velocidade_alterada.emit(multiplicador)
