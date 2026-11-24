# 2026-11-24 — Fila em duas etapas e papel do `fila_core`

Status: Proposto
Autor: Claude (rascunho a pedido de Miguel)   Aprovado por: —

> Rascunho para a dupla discutir. Ele **não escolhe** por vocês: lista as
> alternativas, o que cada uma custa e o que ainda falta saber. Só um humano
> muda o status para Aceito (AGENTS.md). Issue: #23.

## Contexto
Duas decisões já tomadas puxam em direções diferentes:

- O ADR de backend (aceito) põe a lógica da fila e da estimativa de espera em
  SQL no Supabase, com regras de acesso por RLS e Realtime
  (`2026-11-17-backend-banco-push.md`, seção Consequências).
- O `app/fila_core` (PR #8) é Dart puro, sem banco nem internet, com a regra de
  ordem trocável (`RegraOrdenacao`, padrão Strategy). O `app/README.md` diz que
  telas e backend "se conectam ao núcleo".

E a visita de 2026-11-19 mostrou que a unidade tem **duas etapas** (triagem e
consulta) numa chamada só (RF25), enquanto o núcleo é **uma fila só**.

Duas perguntas ficam em aberto, e uma depende da outra:
1. **Onde mora a lógica da fila** (quem decide a ordem e quem avança o
   paciente): no app (Dart), no banco (SQL) ou nos dois?
2. **Como representar as duas etapas**, e quais estados o paciente pode ter.

O que já é fato e não está em discussão: Flutter e Supabase + FCM são decisões
aceitas; o modelo de estados em `docs/modelagem/estados-do-paciente.md`
(PR #20, status Provisório) é só um ponto de partida.

## O que ainda não sabemos
Estas dúvidas **não são resolvidas** por este ADR e limitam a escolha:
- A ordem real de cada fila (premissa P3).
- Quem avança a fila e como o fim da consulta é marcado (pergunta 8, RF24).
- O que acontece depois das 3 chamadas sem resposta (premissa P5, RF27).
- Como o paciente se identifica no app e o que é o `id` (RF01, RF23, issue #19).

Por isso a decisão abaixo deve ser a mais fácil de desfazer.

## Alternativas consideradas

### A. O `fila_core` roda no app (Dart é a fonte da regra)
O app calcula a ordem e a posição; o Supabase só guarda e distribui os dados.
- Fica mais fácil: reaproveita o que já existe e tem testes; a regra de ordem
  é testada sem banco (RNF08).
- Fica mais difícil: cada aparelho teria de chegar à mesma ordem. Com vários
  aparelhos mexendo na mesma fila, é preciso um "dono" do estado, e o ADR de
  backend previa a lógica no servidor. Muda uma consequência de um ADR aceito.
  Além disso, o aviso de "vez próxima" sai do banco (webhook e Edge Function),
  que não enxerga a ordem calculada no aparelho; a posição teria de estar
  gravada no servidor.

### B. A regra mora no banco (SQL); o `fila_core` vira referência
O Supabase calcula ordem, posição e estimativa (funções e gatilhos). O
`fila_core` fica como protótipo executável e como especificação dos testes que
a versão em SQL deve cumprir.
- Fica mais fácil: segue o ADR aceito sem mudar nada; um só lugar decide a
  ordem para todos os aparelhos; o push já nasce do banco.
- Fica mais difícil: a regra passa a existir em duas linguagens, e é preciso
  manter as duas coerentes (por exemplo, rodando os mesmos casos de teste nas
  duas). Trocar a regra exige mexer no SQL.

### C. Descartar o `fila_core`
Escrever tudo em SQL e apagar o pacote.
- Fica mais fácil: uma só implementação.
- Fica mais difícil: joga fora o trabalho feito e o material de estudo
  (testes e decisões de projeto), sem ganho claro agora.

### D. Dividir a responsabilidade
O banco guarda o estado e as etapas do paciente (quem está onde); o Dart
calcula só a ordenação de uma etapa, recebendo a lista pronta.
- Fica mais fácil: aproveita o núcleo para o que ele faz bem, a ordem.
- Fica mais difícil: dois lugares mexem na fila, e o limite entre eles precisa
  ser desenhado com cuidado para não gerar conflito. Como a A, também muda uma
  consequência do ADR de backend aceito: a ordenação deixaria de ficar só em
  SQL.

## Duas etapas: formas de representar
Independente de A a D:
- **Uma fila por etapa** (duas `Fila`, uma regra em cada). Simples, mas o
  paciente que muda de etapa sai de uma e entra em outra, e o `posicaoDe`
  devolve `null` para quem está em triagem ou em consulta (PR #22).
- **Uma lista só, com o estado de cada paciente** (aguardando triagem, em
  triagem, aguardando consulta, em consulta, falta), e a ordem calculada por
  estado. Os 5 estados ficam numa camada acima da `Fila`.

## Decisão
**Pendente.** A dupla escolhe entre A, B, C ou D (e a forma das etapas). O
rascunho não recomenda uma por convicção: a B é a que menos contradiz os ADRs
aceitos, e a D só vale se a regra por risco (P3) ficar clara. Revisar quando a
P3 e a pergunta 8 forem resolvidas.

## Consequências (a preencher depois da decisão)
- **B e C** seguem o ADR de backend aceito e não o alteram.
- **A e D** mudam uma consequência do ADR de backend (a lógica da fila deixa
  de ficar só em SQL). Isso exige um novo ADR que altere o de backend, aceito
  por um humano; este rascunho não basta.
- Em qualquer caso, atualizar: RF03, RF05, RF07, RF09, RF10 e RF14 em
  `requisitos.md` (hoje citam operações do Dart ou dependem de onde a fila é
  calculada), `app/README.md`, a seção "Núcleo da fila" do MEMORY.md e as
  pendências do `fila_core` (issue #24: desistência, falta, unicidade do
  `id`).

## Perguntas em aberto
- Um mesmo `id` pode voltar à fila depois de chamado? (hoje pode; README do
  `fila_core`, item 5.)
- `chamarProximo` tira o paciente da fila na hora; o RF27 prevê 3 chamadas antes
  da falta. As duas coisas são o mesmo passo?
- O cálculo da estimativa de espera (RF13) fica junto da regra de ordem ou
  separado?
