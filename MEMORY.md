# MEMORY.md — estado do projeto

Curto e curado. Atualize só via PR. Detalhes ficam nos links.

## Agora
- Fase: requisitos e modelagem (cronograma: nov/2026–fev/2027).
- Sprint atual: —
- Concluído: configuração do repo para agentes (PR #2).
- Concluído: ADR da escolha do Flutter aceito (spike na branch spike/flutter-basico).
- Concluído (aguardando revisão): núcleo da fila em Dart puro, em
  `app/fila_core` (branch feat/nucleo-fila). Ver "Núcleo da fila" abaixo.
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

## Estrutura do código
- `app/` é onde o app mora: todo o código fica nela, uma subpasta por parte
  (cada uma com o seu `pubspec.yaml`). Ver app/README.md.
- `app/fila_core/`: núcleo da fila, Dart puro (sem tela, internet ou banco).

## Núcleo da fila (app/fila_core)
- Mecanismo fixo: `Fila` com `entrar`, `chamarProximo`, `posicaoDe`, `tamanho`,
  `estaVazia`. Regra de ordenação trocável: interface `RegraOrdenacao`
  (padrão Strategy).
- Regras existentes: `RegraOrdemDeChegada` e `RegraPrioridadeLegal`.
- **HIPÓTESE (não confirmada):** `RegraPrioridadeLegal` ordena por 80+, depois
  prioridade legal (Leis 10.048/2000, 10.741/2003, 13.466/2017, 13.146/2015),
  depois os demais, desempatando por chegada. Veio do conhecimento geral da
  legislação, não de documento da unidade. Em unidade de saúde a classificação
  de risco clínico costuma vir antes da prioridade legal; esta versão não a
  considera. Confirmar na visita à unidade e com a orientadora.
- Fora do escopo por enquanto: telas, backend, persistência, notificações,
  classificação de risco, estimativa de tempo de espera.
- Testes: `cd app/fila_core && dart test`.

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
- Confirmar ou substituir a regra de prioridade (HIPÓTESE) do núcleo da fila:
  qual critério a unidade usa e como combina risco clínico com prioridade legal.
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
