# Requisitos — rascunho v0

Status: **rascunho para revisão da dupla e da orientadora**. Nenhum requisito
abaixo foi validado com a unidade de saúde. Isso só acontece nas visitas de
campo.

Issue de origem: #12. Ordem dos sprints: conforme o MEMORY.md (fonte: cronograma
do projeto PIBIC).

## Como ler

- **ID**: `RF` = requisito funcional, `RNF` = não funcional.
- **Origem**:
  - `código`: já existe no núcleo da fila (`app/fila_core`);
  - `cronograma`: previsto no plano de sprints;
  - `hipótese`: inferido por nós, sem documento da unidade;
  - `a confirmar`: depende de resposta da unidade ou da orientadora.
- Nível de detalhe: o Sprint 1 está mais detalhado. Os demais são só tópicos e
  serão refinados quando o sprint se aproximar.

## Atores (provisório)

| Ator | Descrição |
|------|-----------|
| Paciente | Quem usa o app para entrar na fila e acompanhá-la. |
| Recepção | Quem recebe o paciente na unidade. **A confirmar** se é um ator distinto do profissional de saúde. |
| Profissional de saúde | Quem chama o próximo paciente. |
| Administrador | Quem configura a unidade (consultórios, regras). **A confirmar** quem exerce esse papel. |

## Sprint 1 — Check-in digital

| ID | Requisito | Origem |
|----|-----------|--------|
| RF01 | O paciente deve conseguir se identificar no app (cadastro e login), com o mínimo de dados necessário. Opções, em ordem de preferência: (1) login gov.br (OAuth/OpenID Connect; entrega o CPF, que é dado pessoal, e exige cadastro do sistema junto ao governo, a confirmar com o IFG ou a orientadora, issue #19; roteiro oficial: https://roteiro-tecnico.acesso.gov.br/); (2) cadastro simples próprio, com nome, senha e idade, só com dados fictícios, já que o app não será lançado; (3) login anônimo com código de atendimento. | cronograma; forma de identificação a confirmar |
| RF02 | O paciente deve conseguir fazer o check-in ao chegar à unidade. | cronograma |
| RF03 | O check-in deve inserir o paciente na fila (operação `Fila.entrar`). | código |
| RF04 | O paciente deve poder informar condição que dá prioridade legal (por exemplo, idade 80+, gestante, pessoa com deficiência), conforme as leis hoje assumidas pelo núcleo da fila. | hipótese (ver `RegraPrioridadeLegal`) |
| RF05 | Após o check-in, o app deve mostrar ao paciente a confirmação e a posição atual na fila (`Fila.posicaoDe`). | código |
| RF06 | A recepção deve poder ver quem fez check-in. | hipótese |
| RF07 | O check-in deve indicar o tipo de atendimento ou o local (consultório/sala). | a confirmar |
| RF23 | Ao entrar na fila, o paciente deve receber uma senha de atendimento (por exemplo, um número sequencial do dia), para ser chamado por ela. O núcleo da fila ainda não gera senha. O ID segue a ordem de criação, não a de sprint. | hipótese; formato da senha a confirmar na unidade |
| RF08 | Deve ser possível validar que o paciente está de fato na unidade (por exemplo, QR code no local ou geolocalização). | hipótese |

## Sprint 2 — Monitoramento da fila de espera

| ID | Requisito | Origem |
|----|-----------|--------|
| RF09 | O paciente deve ver a própria posição e o tamanho da fila, atualizados sem recarregar a tela. | código (`posicaoDe`, `tamanho`); atualização em tempo real depende do ADR de backend |
| RF10 | O profissional deve poder chamar o próximo paciente (`Fila.chamarProximo`). | código |
| RF11 | A recepção deve ver a fila completa, na ordem definida pela regra de ordenação ativa. | hipótese |
| RF12 | O paciente deve poder desistir da fila. O núcleo ainda não tem essa operação. | pendência registrada no README do `fila_core` |
| RF13 | O app deve mostrar uma estimativa de tempo de espera como faixa (por exemplo, 20 a 30 min), não como número exato. Ela começa com a duração média por tipo de atendimento coletada na visita à unidade e passa a usar a média real medida pelo app. | hipótese; durações a coletar na visita |
| RF24 | O sistema deve registrar o início e o fim de cada atendimento, para medir a duração real. O núcleo da fila só tem `chamarProximo`, sem o "fim". O ID segue a ordem de criação. | hipótese; depende do RF13 |
| RF14 | A regra de ordenação deve ser trocável sem mudar a fila. | código (`RegraOrdenacao`) |
| RF15 | Quem atribui o fator de risco e qual escala é usada (níveis, cores ou protocolo existente). | a confirmar |

## Sprint 3 — Notificações automáticas

| ID | Requisito | Origem |
|----|-----------|--------|
| RF16 | O paciente deve receber notificação quando estiver perto de ser chamado. | cronograma |
| RF17 | O paciente deve receber notificação quando for chamado. | cronograma |
| RF18 | O paciente deve poder desativar as notificações. | hipótese |
| RF19 | O limite de proximidade (quantas posições antes de avisar) deve ser configurável. | hipótese |

## Sprint 4 — Integração e testes

| ID | Requisito | Origem |
|----|-----------|--------|
| RF20 | O fluxo completo (check-in, monitoramento, notificação) deve funcionar de ponta a ponta. | cronograma |
| RF21 | Deve haver testes automatizados do núcleo e dos fluxos principais. | cronograma |
| RF22 | O app deve ser validado em Android e iOS. O push no iOS depende de conta Apple Developer. | cronograma; pendência no MEMORY |

## Requisitos não funcionais (valem para todos os sprints)

| ID | Requisito | Origem |
|----|-----------|--------|
| RNF01 | **LGPD**: nenhum dado real de paciente no repositório. O app trata só dados fictícios no protótipo e coleta o mínimo necessário. | AGENTS.md |
| RNF02 | Deve haver caminho para exclusão dos dados do paciente. | ADR de backend (proposto) |
| RNF03 | Nenhuma credencial ou chave no código; uso de variáveis de ambiente. | AGENTS.md |
| RNF04 | O protótipo deve usar apenas planos gratuitos. | premissa informada pela dupla |
| RNF05 | O app deve rodar em Android e iOS (Flutter). | ADR do Flutter |
| RNF06 | A interface deve ser simples e acessível, considerando pacientes idosos e com pouca familiaridade tecnológica. | hipótese |
| RNF07 | A atualização da fila deve ser perceptível em poucos segundos. O número exato é a confirmar. | hipótese |
| RNF08 | O núcleo da fila deve continuar independente de tela, internet e banco, para ser testável isoladamente. | código |
| RNF09 | Comentários e nomes de domínio em português; `dart format` e `flutter_lints`. | AGENTS.md |

## Perguntas em aberto

Perguntas já registradas no MEMORY.md, que bloqueiam ou mudam requisitos.

A visita de 2026-11-19 (UPA de urgência, observação de ~1 h 20 min) respondeu parte delas. A síntese está em `docs/pesquisa/2026-11-19-visita-upa-sintese.md`. A dupla **não tem acesso à unidade para perguntar**, então o que a observação não mostrou virou premissa (seção "Premissas" abaixo), não resposta.

1. Como o paciente se identifica, respeitando a LGPD? (RF01)
   **Visita:** no guichê, com documento de identificação ou nome e nascimento, e o cadastro é feito na hora (~2 a 3 min). A forma de identificação no app continua decisão da dupla.
2. Como o app conhece o local de atendimento? Cadastro de consultórios e salas. (RF07)
   **Parcialmente respondida.** A unidade tem 1 guichê, 1 sala de triagem e 3 consultórios. A fila é única e mista (a mesma TV chama triagem e consulta), e a chamada diz o consultório ("NOME – CONSULTÓRIO N"). Isso coincide com a opção A. A escolha entre as opções segue com a dupla:
   - A: fila única da unidade; o local aparece só na chamada.
   - B: uma fila por tipo de atendimento, com salas cadastradas.
   - C: uma fila por sala (pesada para o protótipo).
3. Quem atribui o fator de risco e qual escala é usada? (RF15)
   **Parcialmente respondida.** O risco é atribuído na triagem, por um profissional na sala anexa à recepção, e aparece em pulseira colorida. Vimos verde e amarelo. A escala completa e a categoria profissional são premissas (P1, P4).
4. Qual critério de prioridade a unidade usa e como combina risco clínico com
   prioridade legal? (RF04, RF14)
   **Não respondida.** Só há a impressão "um pouco de tudo" (risco, prioridade, chegada). A unidade lista como prioritários idosos, criança de colo, pessoa com deficiência e gestante. Premissa P3.
5. Como estimar o tempo de espera sem histórico? (RF13, RF24)
   Caminho escolhido: opção C (faixa de tempo; valor inicial por etapa e depois média real medida pelo app).
   **Visita:** a unidade não informa o tempo restante em nenhuma etapa. Os tempos observados servem só como ordem de grandeza, por causa da amostra pequena: espera até a triagem de 2 a 41 min, triagem de 2 a 6 min, triagem até a consulta de 3 a ~40 min, consulta de ~6 min a mais de 24 min. As consultas agendadas não foram vistas (premissa P6).
6. Existe distinção entre recepção e profissional de saúde na unidade? (atores)
   **Respondida pela visita.** Sim. Recepção (cadastro e painel), triagem e consulta são etapas distintas. É o recepcionista quem chama pelo painel.
7. Como a unidade chama o paciente hoje (senha impressa, nome, número)? Qual é o formato da senha? (RF23)
   **Respondida pela visita.** **Não há senha.** Chama por nome e consultório, por voz e painel, 3 vezes; sem resposta, é marcada falta e a fila anda. Fora da sala a chamada é muito difícil de ouvir.

Sem acesso à unidade, o que resta depende de decisão da dupla, da orientadora ou de uma nova observação, caso a unidade permita.

## Premissas (sem validação com a unidade)

Suposições declaradas que o protótipo usa. Nenhuma foi confirmada pela unidade. Detalhes e fontes de pesquisa (ainda a conferir nos textos originais) em `docs/pesquisa/2026-11-19-visita-upa-sintese.md`, seção "Premissas assumidas".

| # | Premissa | Requisitos afetados | Como o app se protege |
|---|----------|---------------------|-----------------------|
| P1 | A escala de risco é a do Protocolo de Manchester, com 5 cores (vermelho, laranja, amarelo, verde, azul). Vimos só verde e amarelo. | RF15 | Escala configurável; nenhuma cor fixa no código. |
| P2 | Os prazos máximos por cor não são fixos; as fontes divergem. | RF13 | O app não usa prazo por cor na primeira versão. |
| P3 | A ordem combina risco, prioridade legal e chegada, mas a combinação real é desconhecida. A regra padrão do protótipo é hipótese, a decidir com a orientadora. | RF04, RF14 | Regra de ordenação trocável (`RegraOrdenacao`). |
| P4 | O profissional da triagem é enfermeiro. | RF15, atores | Os requisitos dizem "profissional da triagem", sem categoria. |
| P5 | Quem não responde em 3 chamadas é marcado como falta e a fila anda, sem voltar à posição. Intervalo entre as chamadas desconhecido. | RF10, RF17 | Número de chamadas configurável. |
| P6 | A UPA atende só demanda espontânea, sem consultas agendadas. | RF13 | Consulta agendada fora do escopo. |
| P7 | A unidade (o "cliente") autoriza o app e a exibição do nome. Quem é, concretamente, fica com a orientadora (issue #19). | RF01, RNF01 | Só dados fictícios; código no lugar do nome. |

Os requisitos RF04, RF10, RF13, RF23 e RF24 e os requisitos novos que a visita sugere (fila em duas etapas, chamada com consultório, falta após 3 chamadas) ainda **não foram reescritos** neste rascunho.
