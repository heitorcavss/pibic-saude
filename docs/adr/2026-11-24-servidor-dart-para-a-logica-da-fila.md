# 2026-11-24 — Servidor em Dart para a lógica da fila

Status: Proposto
Autor: Heitor (rascunho com apoio do Claude)   Aprovado por: —

> Rascunho para a dupla discutir. Só um humano muda o status para Aceito
> (AGENTS.md). **Se aceito, altera uma consequência do ADR de backend
> aceito** (`2026-11-17-backend-banco-push.md`: "não há servidor para manter;
> a lógica da fila fica em SQL"). Relacionado: issue #23. Este ADR trata só da
> arquitetura (onde roda o código da fila); o PR #26 trata de como representar
> as duas etapas e os estados do paciente.
> Os números de planos gratuitos vêm de buscas feitas em 2026-11-24 e **devem
> ser reconferidos nas páginas oficiais** antes de aceitar.

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

**Hospedagem inicial: Render (plano grátis, sem cartão).** Mantém a regra de
custo zero do ADR de backend. **Possível mudança para o Google Cloud Run**, se
a espera do Render atrapalhar (ver Consequências).

## Alternativas consideradas
Todas respondem a mesma pergunta: **onde roda o código que decide a ordem da
fila?** As alternativas A a D vieram do rascunho do PR #26 (issue #23) e foram
trazidas para cá, porque esta é uma decisão de arquitetura.

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

### E. Servidor Dart próprio (esta proposta)
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
  Fica como opção de troca.
- **E com Fly.io:** sem plano grátis permanente para contas novas (fontes de
  2026).

## Consequências
**Fica mais fácil:** a regra de ordem em Dart, testável sem banco (RNF08) e
reaproveitando o `fila_core`; uma linguagem só nos dois lados.

**Fica mais difícil:**
- **Hospedagem.** No Render grátis o servidor dorme após 15 min parado e leva
  cerca de 1 min para acordar; o primeiro acesso do dia seria lento. Mitigação:
  ping periódico (o mesmo truque previsto para o Supabase). Foi esse tipo de
  limite que levou o ADR de backend a descartar o "backend próprio".
- **Segurança.** O servidor escreve no banco com a chave de administrador
  (`service_role`), que passa por cima da RLS. A segurança de escrita passa a
  depender do código Dart, e essa chave nunca pode ir para dentro do app.
- **Login.** O servidor precisa validar o token que o Supabase deu ao usuário
  para saber quem está pedindo.
- **Mais peças:** Dart, TypeScript (Edge Function) e SQL (tabelas), com
  Supabase, servidor e FCM para operar. A dupla domina Python e SQL; Dart no
  servidor é novidade.

**Se trocar para o Cloud Run (a decidir com o Miguel e a orientadora):**
- Exige alguém cadastrar um cartão na conta de cobrança. A cota gratuita
  (cerca de 2 milhões de requisições por mês, segundo as fontes) fica muito
  acima da estimativa do projeto (cerca de 60 mil mensagens por mês).
- Um alerta de orçamento só avisa e não corta o gasto. Reduzir o risco com o
  máximo de instâncias baixo e o mínimo em zero.
- Há menção a um "Starter Tier" do Google sem cartão; as fontes divergem sobre
  servir para o Cloud Run. Conferir antes de contar com ele.

**Se aceito:**
- Escrever o ADR que **substitui** a consequência "sem servidor" do ADR de
  backend, e marcar a relação nos dois.
- Atualizar `app/README.md`, a seção "Núcleo da fila" e as pendências do
  MEMORY.md, e os RF que citam onde a fila é calculada (ver PR #26).
- O AGENTS.md hoje diz "sem servidor próprio nesta fase": só um humano muda
  essa regra.
- Qualquer que seja a alternativa escolhida (A a E), atualizar os RF que citam
  operações do Dart ou dependem de onde a fila é calculada (RF03, RF05, RF07,
  RF09, RF10 e RF14 em `requisitos.md`) e o `app/README.md`.
- As alternativas A, D e E mudam uma consequência do ADR de backend aceito
  (a lógica da fila deixa de ficar só em SQL); B e C não o alteram.

## Perguntas em aberto
- O Miguel aceita o servidor próprio e a hospedagem no Render (ou no Cloud
  Run, com cartão)?
- Qual framework Dart usar (Dart Frog, Serverpod ou Shelf)? Pesquisar antes.
- O Supabase aceita chamar o servidor externo (webhook ou chamada do app)? O
  desenho assume que sim; **não foi verificado na documentação**.
- A espera de cerca de 1 min do Render é aceitável para as demonstrações?
- As perguntas sobre o comportamento da fila (o `id` que volta à fila, as 3
  chamadas antes da falta, a estimativa junto da ordem ou separada) e como
  representar as duas etapas e os estados do paciente ficam no PR #26, e não
  mudam com esta decisão.
