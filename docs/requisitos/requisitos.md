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
| RF01 | O paciente deve conseguir se identificar no app (cadastro e login), com o mínimo de dados necessário. Alternativas: login do Supabase (e-mail ou telefone), ou login gov.br (OAuth/OpenID Connect; entrega o CPF, que é dado pessoal, e exige cadastro do sistema junto ao governo, a confirmar com o IFG ou a orientadora; roteiro oficial: https://roteiro-tecnico.acesso.gov.br/). | cronograma; forma de identificação a confirmar |
| RF02 | O paciente deve conseguir fazer o check-in ao chegar à unidade. | cronograma |
| RF03 | O check-in deve inserir o paciente na fila (operação `Fila.entrar`). | código |
| RF04 | O paciente deve poder informar condição que dá prioridade legal (por exemplo, idade 80+, gestante, pessoa com deficiência), conforme as leis hoje assumidas pelo núcleo da fila. | hipótese (ver `RegraPrioridadeLegal`) |
| RF05 | Após o check-in, o app deve mostrar ao paciente a confirmação e a posição atual na fila (`Fila.posicaoDe`). | código |
| RF06 | A recepção deve poder ver quem fez check-in. | hipótese |
| RF07 | O check-in deve indicar o tipo de atendimento ou o local (consultório/sala). | a confirmar |
| RF08 | Deve ser possível validar que o paciente está de fato na unidade (por exemplo, QR code no local ou geolocalização). | hipótese |

## Sprint 2 — Monitoramento da fila de espera

| ID | Requisito | Origem |
|----|-----------|--------|
| RF09 | O paciente deve ver a própria posição e o tamanho da fila, atualizados sem recarregar a tela. | código (`posicaoDe`, `tamanho`); atualização em tempo real depende do ADR de backend |
| RF10 | O profissional deve poder chamar o próximo paciente (`Fila.chamarProximo`). | código |
| RF11 | A recepção deve ver a fila completa, na ordem definida pela regra de ordenação ativa. | hipótese |
| RF12 | O paciente deve poder desistir da fila. O núcleo ainda não tem essa operação. | pendência registrada no README do `fila_core` |
| RF13 | O app pode mostrar uma estimativa de tempo de espera. | a confirmar (sem histórico de atendimentos no início) |
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

Perguntas já registradas no MEMORY.md, que bloqueiam ou mudam requisitos:

1. Como o paciente se identifica, respeitando a LGPD? (RF01)
2. Como o app conhece o local de atendimento? Cadastro de consultórios e salas. (RF07)
3. Quem atribui o fator de risco e qual escala é usada? (RF15)
4. Qual critério de prioridade a unidade usa e como combina risco clínico com
   prioridade legal? (RF04, RF14)
5. Como estimar o tempo de espera sem histórico? (RF13)
6. Existe distinção entre recepção e profissional de saúde na unidade? (atores)

Todas dependem da visita à unidade ou de decisão da dupla.
