# 2026-11-24 — Etapas e estados do paciente

Status: Aceito
Autor: Claude (rascunho a pedido de Miguel)   Aprovado por: Miguel (2026-11-26)

> Issue: #23. **Escopo:** este ADR trata só do **código da fila**: como
> representar as duas etapas e quais estados o paciente tem. **Onde esse código
> roda** (um servidor Dart próprio, com Supabase e FCM) é outra decisão, no ADR
> `2026-11-24-servidor-dart-para-a-logica-da-fila.md` (PR #27).
>
> A decisão foi tomada com o que a visita de 2026-11-19 mostrou. As dúvidas que
> a visita não resolveu estão no fim e **não mudam a forma de representar as
> etapas**: cada regra de ordem é trocável (`RegraOrdenacao`). As regras de
> ordem escolhidas abaixo são **HIPÓTESE**.

## Contexto
O `app/fila_core` (PR #8) é Dart puro, com a regra de ordem trocável
(`RegraOrdenacao`, padrão Strategy). A visita de 2026-11-19 mostrou que a
unidade tem **duas etapas** (triagem e consulta) numa chamada só (RF25), com o
risco atribuído na triagem e a falta marcada após 3 chamadas sem resposta,
enquanto o núcleo é **uma fila só**.

Pergunta deste ADR: **como representar as duas etapas**, e quais estados o
paciente pode ter. O modelo de estados em
`docs/modelagem/estados-do-paciente.md` (status Provisório, vindo da mesma
visita) é o ponto de partida.

## Alternativas consideradas
- **Uma fila por etapa** (duas `Fila`, uma regra em cada). Simples e aproveita o
  núcleo como está, mas o paciente que muda de etapa sai de uma e entra em
  outra, e o `posicaoDe` devolve `null` para quem está em triagem ou em
  consulta (PR #22).
- **Uma lista só, com o estado de cada paciente** (aguardando triagem, em
  triagem, aguardando consulta, em consulta, falta), e a ordem calculada por
  estado. Guarda bem a história do paciente, mas obriga a mexer mais no núcleo.

## Decisão
As duas ideias se combinam, porque o servidor Dart lê o banco a cada pedido:

- **O estado do paciente fica num registro único** (uma tabela no banco), com
  os cinco estados da visita: aguardando triagem, em triagem, aguardando
  consulta, em consulta e falta.
- **Há uma `Fila` do `fila_core` por etapa**, montada a partir dos pacientes
  que esperam em cada etapa, cada uma com a sua regra de ordem:
  - **triagem:** por ordem de chegada (`RegraOrdemDeChegada`);
  - **consulta:** por risco, com desempate por chegada. A regra por risco ainda
    não existe no núcleo.
  - **As duas regras são HIPÓTESE (premissa P3)**, a confirmar com a
    orientadora ou numa nova observação.
- A `Fila` continua só enxergando quem espera. "Em triagem", "em consulta" e
  "falta" ficam no registro, fora da `Fila`. Passar de etapa é mudar o estado
  no registro: o paciente sai de uma `Fila` e aparece na outra na próxima
  leitura. O app mostra a etapa pelo estado, e a posição só para quem espera.

É a forma mais fácil de desfazer: trocar uma regra de ordem não mexe nas
etapas, e mudar os estados não mexe no núcleo.

## Consequências
- Atualizar `docs/modelagem/estados-do-paciente.md` quando os estados deixarem
  de ser provisórios, e o RF25 e o RF27 em `requisitos.md` quando a regra por
  risco e a falta forem implementadas.
- O núcleo ganha a regra por risco e uma forma de mudar o paciente de etapa.
  As pendências do `fila_core` (desistência, falta, unicidade do `id`, issue
  #24) seguem abertas.
- Se a visita ou a orientadora mudarem a ordem real (P3) ou o fluxo, trocar a
  regra ou o estado, sem refazer a representação.

## Dúvidas em aberto
Não resolvidas por este ADR (a visita não mostrou, e viraram premissa):
- **A ordem real de cada fila** (premissa P3): só se viu "um pouco de tudo?"
  (risco, prioridade, chegada).
- **Quem avança a fila** e como o fim da consulta é marcado (pergunta 8, RF24).
- **O que acontece depois da falta** (é definitiva? a fila anda sem o paciente
  voltar à posição?) e o **intervalo entre as chamadas** (premissa P5, RF27).
- **Um mesmo `id` pode voltar à fila depois de chamado?** (hoje pode; README do
  `fila_core`, item 5.) Depende também de como o paciente se identifica (RF01,
  RF23, issue #19).
- `chamarProximo` tira o paciente da fila na hora; o RF27 prevê 3 chamadas antes
  da falta. As duas coisas são o mesmo passo?
- O cálculo da estimativa de espera (RF13) fica junto da regra de ordem ou
  separado?
