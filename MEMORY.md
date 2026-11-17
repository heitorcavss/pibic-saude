# MEMORY.md — estado do projeto

Curto e curado. Atualize só via PR. Detalhes ficam nos links.

## Agora
- Fase: requisitos e modelagem (cronograma: nov/2026–fev/2027).
- Sprint atual: —
- Concluído: configuração do repo para agentes (PR #2).
- Concluído: ADR da escolha do Flutter aceito (spike na branch spike/flutter-basico).
- Em andamento: confirmar o app em Android e escolher backend, banco e push (ADR próprio).

## Plano de sprints (fonte: cronograma do projeto PIBIC)
- Sprint 1: check-in digital.
- Sprint 2: monitoramento da fila de espera.
- Sprint 3: notificações automáticas.
- Sprint 4: integração e testes.
- Não começar um sprint fora desta ordem sem registrar a mudança aqui.

## Combinados da dupla
- Os dois usam Claude Code; AGENTS.md vale para qualquer outra ferramenta.
- Memória compartilhada: este arquivo, na raiz. Só muda via PR.
- Idioma: português, com identificadores técnicos em inglês.
- A main é protegida; todo PR é revisado pelo colega.
- Spikes (experimentos descartáveis) ficam em branches spike/* e não entram na main.

## Decisões vigentes (ADRs aceitos)
- Flutter (Dart) como plataforma mobile: docs/adr/2026-11-16-escolha-do-flutter.md.

## Propostas abertas
- (nenhuma ainda)

## Pendências e dúvidas
- Definir backend, banco e serviço de push (próximo ADR; o tempo real da fila
  entra junto).
- Confirmar o app em Android (emulador ou aparelho): o spike foi só web.
- Migrar ou não para o pacote material_ui (aviso de obsolescência do
  material.dart no Flutter 3.50).
- Antes de usar qualquer dataset público, checar licença e LGPD. Links
  levantados: docs/pesquisa/2026-11-17-links-datasets-simulacao-filas.md.
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
