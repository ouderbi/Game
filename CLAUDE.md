# Convenções do Projeto Leviatã

## Fonte de verdade

Os documentos em `docs/specs/` são a especificação do produto. O roadmap em
`20_roadmap_convencoes.md` define a ordem de implementação e
`22_mapa_integracao_fluxo.md` define como os sistemas se conectam.

## Princípios obrigatórios

- Construir por marco e manter o jogo executável ao final de cada incremento.
- O núcleo da simulação usa tick fixo, semente e comportamento determinístico.
- Renderização e UI leem o estado; ações entram pelo pipeline da simulação.
- O corpo nunca espera rede, LLM ou outro provedor externo.
- A simulação deve ser completa no modo heurístico e offline.
- A engine valida toda decisão proposta pelo jogador ou por uma IA.
- Preferir poucos sistemas profundos a muitas variáveis desconectadas.
- Manter segredos e chaves de API fora do repositório.

## Qualidade

Todo módulo concluído deve:

1. integrar-se ao loop sem quebrar a execução headless;
2. possuir teste determinístico básico;
3. respeitar os schemas documentados;
4. encerrar o escopo do marco, sem subsistemas parcialmente implementados;
5. passar por Ruff, mypy e pytest.
