# MEMORY.md — estado do projeto

Curto e curado. Atualize só via PR. Detalhes ficam nos links.

## Agora
- Fase: requisitos e modelagem (cronograma: nov/2026–fev/2027).
- Sprint atual: —
- Concluído: configuração do repo para agentes (PR #2).
- Concluído: ADR da escolha do Flutter aceito (spike na branch spike/flutter-basico).
- Concluído: núcleo da fila em Dart puro, em `app/fila_core` (PR #8). Ver
  "Núcleo da fila" abaixo.
- Concluído: ADR de backend, banco e push aceito (Supabase + FCM).
- Concluído: visita de campo a uma UPA de urgência em 2026-11-19. Síntese:
  docs/pesquisa/2026-11-19-visita-upa-sintese.md (PR #21, aceito). Ver
  "Unidade visitada" abaixo.
- Em andamento: confirmar o app em Android.
- Em andamento: requisitos e modelagem (issue #12, PR #18). Requisitos
  reescritos com a visita; as premissas P1 a P7 não foram validadas com a
  unidade.

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

## Unidade visitada (UPA, 2026-11-19)
- Alvo do projeto: UPA de urgência (não é UBS). Uma tarde, ~1 h 20 min de
  observação; vale só para esse turno.
- Estrutura: 1 guichê, 1 sala de triagem, cerca de 3 consultórios. Fila única e mista:
  a mesma chamada serve à triagem e à consulta.
- Fluxo: guichê (cadastro na hora; nome, nascimento ou documento, e o que o
  paciente sente) → triagem (risco em pulseira colorida; vimos verde e
  amarelo) → consulta.
- Não há senha. A chamada é pelo nome completo e pelo consultório, por voz e TV.
  Sem resposta em 3 chamadas, é marcada falta. Não vimos quem opera o painel
  nem se a fila anda sem o paciente (suposição, P5). Fora da sala quase não se
  ouve a chamada.
- A unidade não informa o tempo de espera. Observado (9 pacientes): de 2 a
  pelo menos 10 min até a triagem e de 3 a mais de 36 min da triagem à
  consulta; as esperas mais longas foram depois da triagem (gargalo não
  confirmado).
- A dupla não tem acesso à unidade para perguntar. O que a observação não
  mostrou virou premissa (P1 a P7), em docs/requisitos/requisitos.md.

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
  considera. A visita não confirmou o critério real (só "um pouco de tudo?") e
  a unidade lista idosos 60+ como prioritários; ver premissa P3.
- A unidade tem duas etapas (triagem e consulta) e o núcleo é uma fila só.
  Precisa evoluir (RF25), por um ADR que ainda não foi escrito.
- Decisões de projeto do algoritmo (ordenar a cada consulta, desempate,
  null versus erro, ausência de desistência etc.) e pendências: seção
  "Decisões de projeto do algoritmo" em app/fila_core/README.md.
- Fora do escopo por enquanto: telas, backend, persistência, notificações,
  classificação de risco, estimativa de tempo de espera.
- Testes: `cd app/fila_core && dart test`.

## Decisões vigentes (ADRs aceitos)
- Flutter (Dart) como plataforma mobile: docs/adr/2026-11-16-escolha-do-flutter.md.
- Backend, banco e push: Supabase (Postgres, Auth, Realtime, RLS) + FCM, sem
  servidor próprio nesta fase: docs/adr/2026-11-17-backend-banco-push.md
  (aceito por Miguel em 2026-11-18; issue #5).

## Propostas abertas
- ADR da fila em duas etapas (triagem e consulta, RF25): a propor, ainda não
  escrito.

## Pendências e dúvidas
- Alguém tem conta Apple Developer (paga) para o push no iOS? Sem ela, o push
  só é validado no Android.
- O projeto gratuito do Supabase pausa após 1 semana sem uso: confirmar o
  ping e planejar as demonstrações.
- Reconferir os limites do plano gratuito do Supabase (inclusive se as
  mensagens do Realtime contam por aparelho conectado) e os termos de dados
  frente à LGPD, antes de usar dados reais.
- Confirmar o app em Android (emulador ou aparelho): o spike foi só web.
- Migrar ou não para o pacote material_ui (aviso de obsolescência do
  material.dart no Flutter 3.50).
- Antes de usar qualquer dataset público, checar licença e LGPD. Links
  levantados: docs/pesquisa/2026-11-17-links-datasets-simulacao-filas.md.
- Respondidas pela visita (ver requisitos.md): o risco é atribuído na triagem;
  recepção, triagem e consulta são etapas distintas; não há senha; o cadastro
  usa documento ou nome e nascimento no guichê.
- Regra de prioridade do núcleo (HIPÓTESE): a visita não resolveu. Decidir com
  a orientadora o padrão do protótipo (risco antes da prioridade legal, ou o
  contrário). Premissa P3.
- Escala de risco: parcial. Premissa P1 (Manchester, 5 cores); confirmar
  quando for possível.
- Tempo de espera: caminho mantido (faixa, valor inicial por etapa, depois a
  média real). A unidade não registra o fim da consulta; decidir como o app
  marca esse fim (RF24).
- Como o paciente se identifica no app: decisão da dupla (gov.br é a issue
  #19).
- Local de atendimento: o que vimos coincide com a opção A (fila única, o
  consultório só na chamada). Decisão da dupla.
- Quem é o "cliente" que autoriza o app e a exibição do nome? Perguntar à
  orientadora (premissa P7, issue #19).
- Quem opera o painel e avança a fila (recepção, triagem ou médico)? Não foi
  visto (pergunta 8 em requisitos.md).
- Uma segunda observação, sem perguntar à unidade, fecharia P1, P3 e P5 e a
  etapa que limita o fluxo. Depende de a unidade permitir.
- Fontes de pesquisa das premissas: conferidas nos textos originais em
  2026-11-23. Sem conferir: o manual da UPA 24h do Ministério da Saúde (leitura
  parcial), o Estatuto da Pessoa Idosa além do art. 39 e a fonte oficial do
  COFEN.

## Glossário do domínio
- Triagem: sala onde um profissional classifica o risco do paciente, com
  pulseira colorida.
- Fila de triagem: ordem de chegada (HIPÓTESE). Na visita, a espera até a
  triagem foi de 2 a pelo menos 10 min nos casos com hora; a ordem real não
  foi confirmada.
- Fila de atendimento (consulta): ordenada por fator de risco, empate por
  chegada (HIPÓTESE, P3).
- Recepção: cadastra o paciente no guichê (visita). Quem opera o painel não
  foi visto.
- Administrador: quem configura a unidade e as regras. A confirmar quem
  exerce esse papel.
- Fator de risco: grau de prioridade atribuído na triagem, em cor; define a
  ordem na fila de atendimento (HIPÓTESE, P3).
- Falta: paciente que não responde a 3 chamadas. Que a fila ande sem ele é
  suposição (P5).
- Estimativa de tempo: tempo previsto até o chamado, mostrado como faixa e
  calculado pela média dos atendimentos anteriores e pelos pacientes à frente.
