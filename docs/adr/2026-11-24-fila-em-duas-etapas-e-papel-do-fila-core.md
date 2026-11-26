# 2026-11-24 — Fila em duas etapas e estados do paciente

Status: Proposto
Autor: Claude (rascunho a pedido de Miguel)   Aprovado por: —

> Rascunho para a dupla discutir. Ele **não escolhe** por vocês: lista as
> alternativas, o que cada uma custa e o que ainda falta saber. Só um humano
> muda o status para Aceito (AGENTS.md). Issue: #23.
>
> **Escopo:** este ADR trata só do **código da fila**: como representar as duas
> etapas e quais estados o paciente tem. **Onde esse código roda** (app, banco
> ou servidor Dart próprio) é uma decisão de arquitetura e está no **PR #27**.

## Contexto
O `app/fila_core` (PR #8) é Dart puro, com a regra de ordem trocável
(`RegraOrdenacao`, padrão Strategy). A visita de 2026-11-19 mostrou que a
unidade tem **duas etapas** (triagem e consulta) numa chamada só (RF25),
enquanto o núcleo é **uma fila só**.

Pergunta deste ADR: **como representar as duas etapas**, e quais estados o
paciente pode ter. Vale qualquer que seja o lugar onde o código roda (PR #27).

O que já é fato e não está em discussão: o modelo de estados em
`docs/modelagem/estados-do-paciente.md` (PR #20, status Provisório) é só um
ponto de partida.

## O que ainda não sabemos
Estas dúvidas **não são resolvidas** por este ADR e limitam a escolha:
- A ordem real de cada fila (premissa P3).
- Quem avança a fila e como o fim da consulta é marcado (pergunta 8, RF24).
- O que acontece depois das 3 chamadas sem resposta (premissa P5, RF27).
- Como o paciente se identifica no app e o que é o `id` (RF01, RF23, issue #19).

Por isso a decisão abaixo deve ser a mais fácil de desfazer.

## Alternativas consideradas
- **Uma fila por etapa** (duas `Fila`, uma regra em cada). Simples, mas o
  paciente que muda de etapa sai de uma e entra em outra, e o `posicaoDe`
  devolve `null` para quem está em triagem ou em consulta (PR #22).
- **Uma lista só, com o estado de cada paciente** (aguardando triagem, em
  triagem, aguardando consulta, em consulta, falta), e a ordem calculada por
  estado. Os 5 estados ficam numa camada acima da `Fila`.

## Decisão
**Pendente.** A dupla escolhe a forma das etapas. Revisar quando a P3 e a
pergunta 8 forem resolvidas.

## Consequências (a preencher depois da decisão)
- Atualizar `docs/modelagem/estados-do-paciente.md`, RF25 e RF27 em
  `requisitos.md`, a seção "Núcleo da fila" do MEMORY.md e as pendências do
  `fila_core` (issue #24: desistência, falta, unicidade do `id`).

## Perguntas em aberto
- Um mesmo `id` pode voltar à fila depois de chamado? (hoje pode; README do
  `fila_core`, item 5.)
- `chamarProximo` tira o paciente da fila na hora; o RF27 prevê 3 chamadas antes
  da falta. As duas coisas são o mesmo passo?
- O cálculo da estimativa de espera (RF13) fica junto da regra de ordem ou
  separado?
