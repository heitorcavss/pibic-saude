# 2026-11-24 — Servidor em Dart para a lógica da fila

Status: Aceito
Autor: Heitor (rascunho com apoio do Claude)   Aprovado por: Miguel (2026-11-26)

> **Complementa o ADR de backend** (`2026-11-17-backend-banco-push.md`), sem
> substituí-lo: aquele foi o primeiro passo (Supabase + FCM) e este acrescenta
> um servidor Dart para a lógica da fila. O trecho "sem servidor próprio nesta
> fase" e a consequência "não há servidor para manter; a lógica da fila fica em
> SQL" foram revistos aqui. O resto do ADR de backend continua valendo.
>
> **O que foi aceito:** a decisão de arquitetura (a lógica da fila roda num
> servidor Dart próprio). **Hospedagem e framework do servidor ainda estão a
> definir pela equipe.** Os números de planos gratuitos vêm de buscas feitas em
> 2026-11-24 e **devem ser reconferidos nas páginas oficiais** antes de
> escolher a hospedagem.
>
> Relacionado: issue #23. Este ADR trata só da arquitetura (onde roda o código
> da fila); o ADR `2026-11-24-etapas-e-estados-do-paciente.md` (PR #26) trata de
> como representar as duas etapas e os estados do paciente.

## Contexto
O ADR aceito põe a lógica da fila (ordem, posição, estimativa) em SQL no
Supabase. O `app/fila_core` é Dart puro e não roda dentro do Supabase: as Edge
Functions são em TypeScript (Deno), e a documentação consultada não menciona
Dart. Para o `fila_core` valer como código de produção, e não só como modelo,
ele precisa rodar num servidor nosso.

Motivos para considerar isso, ditos pela dupla:
- Entregar algo mais **autoral**: a regra da fila é o centro da pesquisa e
  ficaria em Dart, com uma linguagem só no app e no servidor.
- O prazo vai até setembro de 2027, então há tempo para construir mais.

A ressalva: login, banco e segurança dos dados são as partes mais arriscadas
de se escrever do zero. Por isso o desenho **mantém essas partes no Supabase**.

## Decisão
A lógica da fila roda num **servidor Dart próprio** (com o `fila_core`). O
Supabase continua com banco, login, regras de acesso (RLS) e tempo real, e a
Edge Function mais o FCM continuam enviando o push.

```
Celular (Flutter)
   ├─► Servidor Dart (fila_core) ──► Supabase (banco + RLS)
   └─► Supabase (login, leitura e tempo real, com RLS)

Supabase: mudança no banco ──► Edge Function ──► FCM ──► celular
```

**O servidor não guarda a fila na memória.** A cada pedido, ele lê no Supabase
os pacientes que esperam, monta a `Fila` do `fila_core`, calcula e grava o
resultado. Isso combina com o núcleo, que já calcula a ordem na hora, e
funciona mesmo que o servidor durma ou reinicie. É o desenho interno da
alternativa D (o banco guarda o estado; o Dart calcula a ordem) dentro da E.

**Hospedagem e framework: a definir pela equipe.** O que se levantou até agora
(nada disso está decidido):
- Hospedagem: Render (plano grátis, sem cartão) ou Google Cloud Run (exige
  cartão). A regra de custo zero do ADR de backend vale ao escolher.
- Framework: Dart Frog, Serverpod ou Shelf.
- Seja qual for a escolha, empacotar o servidor com Docker deixa barato trocar
  de hospedagem depois.

## Alternativas consideradas
Todas respondem a mesma pergunta: **onde roda o código que decide a ordem da
fila?** As alternativas A a D vieram do rascunho do PR #26 (issue #23) e foram
trazidas para cá, porque esta é uma decisão de arquitetura. **Escolhida: E.**
A, B e C ficam descartadas, e a D vira o desenho interno da E.

### A. O `fila_core` roda no app
O app calcula a ordem e a posição; o Supabase só guarda e distribui os dados.
- Mais fácil: reaproveita o que existe e tem testes; a regra é testada sem
  banco (RNF08).
- Mais difícil: cada aparelho teria de chegar à mesma ordem, e com vários
  aparelhos mexendo na mesma fila falta um "dono" do estado. O aviso de "vez
  próxima" sai do banco (webhook e Edge Function), que não enxerga a ordem
  calculada no aparelho. Muda uma consequência do ADR de backend aceito.
- O celular do paciente não pode decidir a ordem (burla e conflito entre
  aparelhos).

### B. A regra mora no banco (SQL); o `fila_core` vira referência
O Supabase calcula ordem, posição e estimativa (funções e gatilhos). O
`fila_core` fica como protótipo executável e como especificação dos testes que
a versão em SQL deve cumprir.
- Mais fácil: segue o ADR aceito sem mudar nada; um só lugar decide a ordem; o
  push já nasce do banco; não exige hospedar nada.
- Mais difícil: a regra existe em duas linguagens, e é preciso mantê-las
  coerentes (por exemplo, com os mesmos casos de teste nas duas). Trocar a
  regra exige mexer no SQL. Menos autoral.

### C. Descartar o `fila_core`
Escrever tudo em SQL e apagar o pacote.
- Mais fácil: uma só implementação.
- Mais difícil: joga fora o trabalho feito e o material de estudo (testes e
  decisões de projeto), sem ganho claro agora.

### D. Dividir a responsabilidade
O banco guarda o estado e as etapas do paciente (quem está onde); o Dart
calcula só a ordenação de uma etapa, recebendo a lista pronta.
- Mais fácil: aproveita o núcleo no que ele faz bem, a ordem.
- Mais difícil: dois lugares mexem na fila, e o limite entre eles precisa ser
  desenhado com cuidado. Como a A, muda uma consequência do ADR de backend
  aceito.
- Rodando no servidor da E, é este o desenho interno adotado (ver Decisão).

### E. Servidor Dart próprio (escolhida)
O `fila_core` roda num servidor nosso, e o Supabase fica com banco, login,
RLS, tempo real e push (ver Decisão).
- Mais fácil: regra autoral em Dart e testável sem banco; uma linguagem só nos
  dois lados; ordem decidida num lugar só, fora do celular.
- Mais difícil: hospedagem, chave de administrador e validação do login (ver
  Consequências).

### Variações descartadas ou em segundo plano
- **Regra em TypeScript numa Edge Function:** fica dentro do Supabase, mas
  reescreve o `fila_core` em outra linguagem.
- **E com Cloud Run desde o início:** melhor tecnicamente (sem a espera do
  Render), mas exige conta de cobrança com cartão, o que fere "sem verba".
  Continua como opção de hospedagem a definir.
- **E com Fly.io:** sem plano grátis permanente para contas novas (fontes de
  2026).

## Consequências
**Fica mais fácil:** a regra de ordem em Dart, testável sem banco (RNF08) e
reaproveitando o `fila_core`; uma linguagem só nos dois lados.

**Fica mais difícil:**
- **Hospedagem (depende da escolha).** No Render grátis o servidor dorme após
  15 min parado e leva cerca de 1 min para acordar; o primeiro acesso do dia
  seria lento. Mitigação: ping periódico (o mesmo truque previsto para o
  Supabase). Foi esse tipo de limite que levou o ADR de backend a descartar o
  "backend próprio".
- **Segurança.** O servidor escreve no banco com a chave de administrador
  (`service_role`), que passa por cima da RLS. A segurança de escrita passa a
  depender do código Dart, e essa chave nunca pode ir para dentro do app.
- **Login.** O servidor precisa validar o token que o Supabase deu ao usuário
  para saber quem está pedindo.
- **LGPD e região.** O servidor é mais um lugar por onde passam dados de
  pacientes, e o ADR de backend já cuidou da região do Supabase (São Paulo).
  Pelo que se sabe, o Render não tem região no Brasil e o Cloud Run tem São
  Paulo (**a confirmar nas páginas oficiais**). Com dados fictícios isso não
  pesa; deve ser revisto antes de qualquer dado real (RNF01).
- **Mais peças:** Dart, TypeScript (Edge Function) e SQL (tabelas), com
  Supabase, servidor e FCM para operar. A dupla domina Python e SQL; Dart no
  servidor é novidade.

**Se a hospedagem escolhida for o Cloud Run (a definir pela equipe e pela
orientadora):**
- Exige alguém cadastrar um cartão na conta de cobrança. A cota gratuita
  (cerca de 2 milhões de requisições por mês, segundo as fontes) fica muito
  acima da estimativa do projeto (cerca de 60 mil mensagens por mês).
- Um alerta de orçamento só avisa e não corta o gasto. Reduzir o risco com o
  máximo de instâncias baixo e o mínimo em zero.
- Há menção a um "Starter Tier" do Google sem cartão; as fontes divergem sobre
  servir para o Cloud Run. Conferir antes de contar com ele.

**Próximos passos (feitos à parte, no PR "Atualizar documentação após as ADRs"):**
- O ADR de backend ganha, no topo, um aviso de que foi complementado por este
  (já incluído neste PR). O resto dele não muda.
- Atualizar `AGENTS.md` (seção Stack, que dizia "sem servidor próprio nesta
  fase"; mudança aprovada por Miguel em 2026-11-26 junto com este ADR),
  `app/README.md`, a seção "Núcleo da fila" e as pendências do `MEMORY.md`,
  `docs/modelagem/arquitetura-e-fluxo.md` e os RF que citam onde a fila é
  calculada (RF03, RF05, RF07, RF09, RF10 e RF14 em `requisitos.md`).

## Perguntas em aberto
- Qual hospedagem usar: Render grátis ou Cloud Run, com cartão? A equipe
  decide, e a orientadora entra se for preciso cartão.
- Qual framework Dart usar (Dart Frog, Serverpod ou Shelf)? Fazer um
  experimento curto antes de escolher. O Serverpod traz banco e login próprios,
  o que pode conflitar com manter essas partes no Supabase.
- O Supabase consegue chamar um servidor externo (webhook do banco)? O app
  chama o servidor direto, então isso só importa se o banco precisar acionar o
  servidor (por exemplo, para o aviso de "vez próxima"). **Não foi verificado
  na documentação.**
- Se for o Render, a espera de cerca de 1 min é aceitável nas demonstrações?
- As perguntas sobre o comportamento da fila (o `id` que volta à fila, as 3
  chamadas antes da falta, a estimativa junto da ordem ou separada) e a forma de
  representar as duas etapas e os estados do paciente ficam no ADR do PR #26, e
  não mudam com esta decisão.
