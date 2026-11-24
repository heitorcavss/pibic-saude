# Requisitos — rascunho v0

Status: **rascunho para revisão da dupla e da orientadora**. Parte dos
requisitos vem da visita de 2026-11-19 a uma UPA de urgência (síntese em
`docs/pesquisa/2026-11-19-visita-upa-sintese.md`). Nenhum foi validado com a
unidade: o que a visita não mostrou virou premissa (seção "Premissas").

Issue de origem: #12. Ordem dos sprints: conforme o MEMORY.md (fonte: cronograma
do projeto PIBIC).

## Como ler

- **ID**: `RF` = requisito funcional, `RNF` = não funcional.
- **Origem**:
  - `código`: já existe no núcleo da fila (`app/fila_core`);
  - `cronograma`: previsto no plano de sprints;
  - `visita`: observado na visita de 2026-11-19 (UPA de urgência);
  - `hipótese`: inferido por nós, sem documento da unidade;
  - `premissa (Pn)`: depende de uma premissa assumida sem validação (seção
    "Premissas");
  - `a confirmar`: depende de resposta da unidade ou da orientadora.
- Nível de detalhe: o Sprint 1 está mais detalhado. Os demais são só tópicos e
  serão refinados quando o sprint se aproximar.

## Atores (provisório)

| Ator | Descrição |
|------|-----------|
| Paciente | Quem usa o app para entrar na fila e acompanhá-la. |
| Recepção | Quem recebe o paciente no guichê e faz o cadastro (visita). Quem opera o painel e avança a fila (recepção, triagem ou médico) não foi visto, então fica a confirmar (pergunta 8). É distinta do profissional de saúde. |
| Profissional da triagem | Quem classifica o risco na sala de triagem, anexa à recepção (visita). A categoria profissional é premissa (P4). |
| Profissional de saúde | Quem atende na consulta (cerca de 3 consultórios na unidade visitada). |
| Administrador | Quem configura a unidade (consultórios, regras). **A confirmar** quem exerce esse papel. |

## Sprint 1 — Check-in digital

| ID | Requisito | Origem |
|----|-----------|--------|
| RF01 | O paciente deve conseguir se identificar no app (cadastro e login), com o mínimo de dados necessário. Opções, em ordem de preferência: (1) login gov.br (OAuth/OpenID Connect; entrega o CPF, que é dado pessoal, e exige cadastro do sistema junto ao governo, a confirmar com o IFG ou a orientadora, issue #19; roteiro oficial: https://roteiro-tecnico.acesso.gov.br/); (2) cadastro simples próprio, com nome, senha e idade, só com dados fictícios, já que o app não será lançado; (3) login anônimo com código de atendimento. | cronograma; forma de identificação a confirmar; visita: no guichê a unidade pede nome ou nascimento, ou documento, e o que o paciente sente |
| RF02 | O paciente deve conseguir fazer o check-in ao chegar à unidade. | cronograma |
| RF03 | O check-in deve inserir o paciente na fila, na etapa "aguardando triagem" (RF25), pela operação `Fila.entrar`. | código; visita |
| RF04 | O paciente deve poder informar condição que dá prioridade legal: idoso (60+), gestante, lactante, pessoa com criança de colo, pessoa com deficiência, pessoa com transtorno do espectro autista, obeso, pessoa com mobilidade reduzida e doador de sangue (este por último), conforme a Lei 10.048/2000. A unidade lista só algumas (idosos, criança de colo, pessoa com deficiência e gestante), e não vimos como a prioridade é aplicada. Entre os idosos, os 80+ têm preferência especial, exceto em caso de emergência (Estatuto da Pessoa Idosa, art. 15, §7º). O núcleo (`RegraPrioridadeLegal`) hoje coloca 80+ antes das demais e precisa ser revisto. Como a prioridade legal se combina com o risco é a premissa P3. | visita (lista de prioridades); premissa P3; hipótese (ver `RegraPrioridadeLegal`) |
| RF05 | Após o check-in, o app deve mostrar ao paciente a confirmação, a etapa em que está (aguardando triagem ou aguardando consulta) e a posição atual na fila (`Fila.posicaoDe`). | código; visita |
| RF06 | A recepção deve poder ver quem fez check-in pelo app, além dos pacientes cadastrados no guichê. | hipótese; visita: hoje a recepção cadastra no guichê |
| RF07 | Na primeira versão a fila é única, e o consultório só aparece na chamada (RF26). O check-in não escolhe tipo de atendimento nem sala. Corresponde à opção A das perguntas em aberto; a escolha final é da dupla. | visita; a decidir pela dupla |
| RF23 | Ao entrar na fila, o paciente deve receber um código de atendimento anônimo (por exemplo, um número sequencial do dia), usado no lugar do nome para ser chamado. A unidade não usa senha hoje e chama por nome na TV. O núcleo da fila ainda não gera código. O ID segue a ordem de criação, não a de sprint. | visita (não há senha; nome na TV); proposta nossa, muda o que a unidade faz hoje |
| RF08 | Deve ser possível validar que o paciente está de fato na unidade (por exemplo, QR code no local ou geolocalização). | hipótese |
| RF25 | A fila tem duas etapas: aguardando triagem e aguardando consulta. O paciente passa para a segunda quando sai da triagem. A unidade visitada tem 1 sala de triagem e cerca de 3 consultórios, e a mesma chamada serve às duas etapas. O núcleo da fila hoje é uma fila só e precisa evoluir (ADR a propor; ver `docs/modelagem/estados-do-paciente.md`). O ID segue a ordem de criação. | visita |

## Sprint 2 — Monitoramento da fila de espera

| ID | Requisito | Origem |
|----|-----------|--------|
| RF09 | O paciente deve ver a própria posição e o tamanho da fila, atualizados sem recarregar a tela. | código (`posicaoDe`, `tamanho`); atualização em tempo real depende do ADR de backend |
| RF10 | Deve ser possível chamar o próximo paciente (`Fila.chamarProximo`). Na unidade vimos a chamada por voz e painel, mas não quem opera o painel (recepção, triagem ou médico). No app, a recepção chama até haver resposta. Quando a chamada é para a consulta, informa o consultório (RF26). | código; visita; a confirmar (pergunta 8) |
| RF11 | A recepção deve ver a fila completa, na ordem definida pela regra de ordenação ativa. | hipótese |
| RF12 | O paciente deve poder desistir da fila. O núcleo ainda não tem essa operação. | pendência registrada no README do `fila_core` |
| RF13 | O app deve mostrar uma estimativa de tempo de espera como faixa (por exemplo, 20 a 30 min), não como número exato, calculada por etapa (espera pela triagem e espera pela consulta). A unidade não informa o tempo restante hoje. Os valores iniciais usam a ordem de grandeza da visita, com faixa larga por causa da amostra pequena (espera até a triagem de 2 a pelo menos 10 min, triagem de 3 a 8 min, triagem até a consulta de 3 a mais de 36 min, consulta de ~6 a mais de 24 min). As esperas mais longas foram depois da triagem (dois pacientes de pulseira verde), mas a etapa que limita o fluxo não está confirmada. Depois passa a usar a média real medida pelo app. Sem prazo por cor (P2). | visita; hipótese; premissas P2 e P6; valores a refinar em nova observação |
| RF24 | O sistema deve registrar o início e o fim de cada etapa (triagem e consulta), para medir a duração real. Na unidade ninguém registra o fim da consulta: o paciente só vai embora. Como o fim será marcado (pela recepção, ou pela chamada seguinte no mesmo consultório) é decisão da dupla com a orientadora. O núcleo da fila só tem `chamarProximo`, sem o "fim". O ID segue a ordem de criação. | visita; hipótese; depende do RF13 |
| RF14 | A regra de ordenação deve ser trocável sem mudar a fila. | código (`RegraOrdenacao`); premissa P3 |
| RF15 | O app deve guardar o nível de risco do paciente depois da triagem, numa escala configurável (padrão: as 5 cores de Manchester). Na unidade o risco é atribuído na triagem e aparece em pulseira colorida; vimos verde e amarelo. Quem digita o risco no app (triagem ou recepção) é decisão da dupla. | visita; premissas P1 e P4 |
| RF26 | A chamada deve informar o consultório junto com o código do paciente (por exemplo, "CÓDIGO – CONSULTÓRIO 3"), como a TV da unidade faz com o nome. | visita |
| RF27 | Quem não responde após 3 chamadas deve ser marcado como falta. Na unidade vimos a falta após 3 chamadas; que a fila ande sem o paciente voltar à posição é suposição (P5). O número de chamadas é configurável. O intervalo entre as chamadas é desconhecido. O núcleo ainda não tem essa operação. O ID segue a ordem de criação. | visita; premissa P5 |

## Sprint 3 — Notificações automáticas

| ID | Requisito | Origem |
|----|-----------|--------|
| RF16 | O paciente deve receber notificação quando estiver perto de ser chamado. | cronograma |
| RF17 | O paciente deve receber notificação quando for chamado, informando o consultório (RF26). Na unidade a chamada por voz e painel é muito difícil de ouvir fora da sala. | cronograma; visita |
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
| RNF06 | A interface deve ser simples e acessível, considerando pacientes idosos e com pouca familiaridade tecnológica. O app complementa o painel e a recepção, que continuam existindo para quem não usa o celular. | hipótese; visita: poucas pessoas usavam o celular na espera e a maioria do público era idosa (impressão) |
| RNF07 | A atualização da fila deve ser perceptível em poucos segundos. O número exato é a confirmar. | hipótese |
| RNF08 | O núcleo da fila deve continuar independente de tela, internet e banco, para ser testável isoladamente. | código |
| RNF09 | Comentários e nomes de domínio em português; `dart format` e `flutter_lints`. | AGENTS.md |
| RNF10 | Nenhuma tela pública ou de uso coletivo deve mostrar o nome completo do paciente; usar o código de atendimento (RF23). Na unidade o nome aparece hoje na TV. | visita; LGPD (hipótese) |

## Perguntas em aberto

Perguntas já registradas no MEMORY.md, que bloqueiam ou mudam requisitos.

A visita de 2026-11-19 (UPA de urgência, observação de ~1 h 20 min) respondeu parte delas. A síntese está em `docs/pesquisa/2026-11-19-visita-upa-sintese.md`. A dupla **não tem acesso à unidade para perguntar**, então o que a observação não mostrou virou premissa (seção "Premissas" abaixo), não resposta.

1. Como o paciente se identifica, respeitando a LGPD? (RF01)
   **Visita:** no guichê, o paciente diz nome ou nascimento, ou entrega documento, e descreve o que sente; o cadastro é feito na hora (~2 a 3 min). A forma de identificação no app continua decisão da dupla.
2. Como o app conhece o local de atendimento? Cadastro de consultórios e salas. (RF07)
   **Parcialmente respondida.** A unidade tem 1 guichê, 1 sala de triagem e cerca de 3 consultórios (3 foi o maior número citado nas chamadas). A fila é única e mista (a mesma TV chama triagem e consulta), e a chamada diz o nome completo e o consultório. Isso coincide com a opção A. A escolha entre as opções segue com a dupla:
   - A: fila única da unidade; o local aparece só na chamada.
   - B: uma fila por tipo de atendimento, com salas cadastradas.
   - C: uma fila por sala (pesada para o protótipo).
3. Quem atribui o fator de risco e qual escala é usada? (RF15)
   **Parcialmente respondida.** O risco é atribuído na triagem, por um profissional na sala anexa à recepção, e aparece em pulseira colorida. Vimos verde e amarelo. A escala completa e a categoria profissional são premissas (P1, P4).
4. Qual critério de prioridade a unidade usa e como combina risco clínico com
   prioridade legal? (RF04, RF14)
   **Não respondida.** Há a impressão "um pouco de tudo" (risco, prioridade, chegada) e uma anotação de preferência na fila ligada ao risco (verde e amarelo, às 16:38). A unidade lista como prioritários idosos, criança de colo, pessoa com deficiência e gestante. Premissa P3.
5. Como estimar o tempo de espera sem histórico? (RF13, RF24)
   Caminho escolhido: opção C (faixa de tempo; valor inicial por etapa e depois média real medida pelo app).
   **Visita:** a unidade não informa o tempo restante em nenhuma etapa. Os tempos observados servem só como ordem de grandeza, por causa da amostra pequena: espera até a triagem de 2 a pelo menos 10 min, triagem de 3 a 8 min, triagem até a consulta de 3 a mais de 36 min, consulta de ~6 min a mais de 24 min. As consultas agendadas não foram vistas (premissa P6).
6. Existe distinção entre recepção e profissional de saúde na unidade? (atores)
   **Respondida pela visita.** Sim. Recepção (cadastro), triagem e consulta são etapas distintas. Quem opera o painel não foi visto (pergunta 8).
7. Como a unidade chama o paciente hoje (senha impressa, nome, número)? Qual é o formato da senha? (RF23)
   **Respondida pela visita.** **Não há senha.** Chama pelo nome completo e pelo consultório, por voz e painel; sem resposta em 3 chamadas, é marcada falta. Se a fila anda sem o paciente é suposição (P5). Fora da sala a chamada é muito difícil de ouvir.
8. Quem opera o painel e avança a fila: recepção, triagem ou médico? (RF10, atores)
   **Não respondida.** Não vimos. No app, a recepção chama até haver resposta.

Sem acesso à unidade, o que resta depende de decisão da dupla, da orientadora ou de uma nova observação, caso a unidade permita.

## Premissas (sem validação com a unidade)

Suposições declaradas que o protótipo usa. Nenhuma foi confirmada pela unidade. Detalhes e fontes de pesquisa (conferidas nos textos originais em 2026-11-23, com exceções registradas na síntese) em `docs/pesquisa/2026-11-19-visita-upa-sintese.md`, seção "Premissas assumidas".

| # | Premissa | Requisitos afetados | Como o app se protege |
|---|----------|---------------------|-----------------------|
| P1 | A escala de risco segue o Protocolo de Manchester (ou uma adaptação), com 5 cores (vermelho, laranja, amarelo, verde, azul). Não há protocolo nacional único. Vimos só verde e amarelo. | RF15 | Escala configurável; nenhuma cor fixa no código. |
| P2 | Os prazos máximos por cor não são fixos; as fontes divergem. | RF13 | O app não usa prazo por cor na primeira versão. |
| P3 | A ordem combina risco, prioridade legal e chegada, mas a combinação real é desconhecida. A regra padrão do protótipo é hipótese, a decidir com a orientadora. | RF04, RF14 | Regra de ordenação trocável (`RegraOrdenacao`). |
| P4 | O profissional da triagem é enfermeiro (a Resolução COFEN 661/2021 torna a classificação privativa do enfermeiro na equipe de enfermagem). | RF15, atores | Os requisitos dizem "profissional da triagem", sem categoria. |
| P5 | Quem não responde em 3 chamadas é marcado como falta e a fila anda, sem voltar à posição. Intervalo entre as chamadas desconhecido. | RF27 | Número de chamadas configurável. |
| P6 | A UPA atende só demanda espontânea, sem consultas agendadas. | RF13 | Consulta agendada fora do escopo. |
| P7 | A unidade (o "cliente") autoriza o app e a exibição do nome. Quem é, concretamente, fica com a orientadora (issue #19). | RF01, RF23, RNF01, RNF10 | Só dados fictícios; código no lugar do nome. |

Os requisitos acima já refletem estas premissas: onde um deles depende de uma, a coluna de origem cita o número (P1 a P7).
