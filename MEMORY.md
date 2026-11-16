# MEMORY.md — estado do projeto

Curto e curado. Atualize só via PR. Detalhes ficam nos links.

## Agora
- Fase: requisitos e modelagem (cronograma: nov/2026–fev/2027).
- Sprint atual: —
- Em andamento: configuração do repo para agentes.

## Decisões vigentes (ADRs aceitos)
- (nenhuma ainda)

## Propostas abertas
- (nenhuma ainda)

## Pendências e dúvidas
- Definir stack mobile, backend e serviço de push.
- Quem atribui o fator de risco: o profissional de saúde ou o administrador?
- Qual escala de risco será usada (níveis, cores ou protocolo existente)?
- Como estimar o tempo de espera no início, sem média de atendimentos anteriores?
- Como o paciente se identifica (cadastro e login), respeitando a LGPD?
- Como o app conhece o local de atendimento (cadastro de consultórios/salas)?

## Glossário do domínio
- Fila de triagem: ordem de chegada.
- Fila de atendimento: ordenada por fator de risco; empate por chegada.
- Administrador: profissional da triagem/recepção que avança a fila.
- Fator de risco: grau de prioridade atribuído após a triagem; define a
  ordem na fila de atendimento.
- Estimativa de tempo: tempo previsto até o chamado, calculado pela média
  dos atendimentos anteriores e pelos pacientes à frente.
