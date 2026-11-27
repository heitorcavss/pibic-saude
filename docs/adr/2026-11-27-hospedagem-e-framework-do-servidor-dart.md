# 2026-11-27 — Hospedagem e framework do servidor Dart

Status: Proposto
Autor: Heitor (rascunho com apoio do Claude)   Aprovado por: —

> Rascunho para a dupla discutir. Só um humano muda o status para Aceito
> (AGENTS.md). Fecha as duas perguntas que o ADR
> `2026-11-24-servidor-dart-para-a-logica-da-fila.md` (aceito em 2026-11-26)
> deixou "a definir pela equipe": onde hospedar o servidor e qual framework
> usar. Não muda a decisão daquele ADR. Revê só uma mitigação dele (o ping
> periódico; ver Consequências).
>
> Pesquisa feita em 2026-11-27 nas documentações oficiais (fontes no fim). Os
> planos gratuitos mudam: reconferir antes de aceitar. O que não foi
> verificado está marcado "a confirmar".

## Contexto
O ADR do servidor Dart decidiu que a lógica da fila (`fila_core`) roda num
servidor Dart próprio, que não guarda a fila na memória: a cada pedido lê o
Supabase, calcula e grava. Faltava escolher a hospedagem (Render grátis ou
Google Cloud Run) e o framework (Dart Frog, Shelf ou Serverpod).

Restrições que pesam na escolha:
- Custo zero e sem cartão de crédito (ADR de backend).
- Equipe de duas pessoas, sem experiência com Dart no servidor.
- Banco, login, RLS, tempo real e push ficam no Supabase e FCM. O framework
  não deve trazer outro banco ou outro login.
- Só dados fictícios nesta fase (LGPD).

## Decisão
- **Hospedagem: Render, plano grátis**, com o servidor empacotado em Docker,
  na região **Virgínia (EUA)**, a mais próxima do Supabase em São Paulo entre
  as regiões do Render.
- **Framework: Dart Frog.**
- O Google Cloud Run fica como plano B, se o Render atrapalhar. Como o
  servidor sai em Docker e o Dart Frog tem guia oficial de Cloud Run, trocar
  depois sai barato.

## Alternativas consideradas

### Hospedagem
| Critério | Render grátis | Cloud Run |
|---|---|---|
| Cartão | Não pede para criar o serviço. Sem forma de pagamento, passar do limite suspende os serviços, sem cobrança | Fora do Starter Tier, exige conta de cobrança (cartão), inclusive para a cota gratuita |
| Dart | Sem runtime nativo; publica a partir de um Dockerfile do repositório | Publica container; o Dart Frog tem guia oficial |
| Espera | Dorme após 15 min sem tráfego e leva cerca de 1 min para acordar | Escala a zero; a espera ao acordar não foi medida |
| Limites | 750 h de instância por mês por workspace (dá um serviço ligado o mês todo); instância de 0,1 CPU e 512 MB; pode reiniciar a qualquer momento; disco apagado ao reiniciar | Cota gratuita de 2 milhões de requisições por mês, 180 mil vCPU-segundos e 360 mil GB-segundos |
| Região no Brasil | Não há (Oregon, Ohio, Virgínia, Frankfurt, Singapura); a região não muda depois de criar o serviço | Há São Paulo; se a cota gratuita vale lá não foi confirmado |
| Uso indicado | "Não use para aplicações em produção": serve para testes e projetos pessoais | Produção |

- **Cloud Run com cartão:** tecnicamente melhor, mas fere a regra de custo
  zero do ADR de backend, e alguém teria de cadastrar um cartão.
- **Cloud Run pelo Starter Tier (sem cartão):** a documentação só fala em apps
  publicados pelo Google AI Studio. Não diz se aceita o nosso próprio
  container, não dá os limites nem a região, e restringe a "territórios
  atendidos" sem listar o Brasil. Não dá para contar com ele.

### Framework
- **Dart Frog (escolhido):** mantido (versão 1.2.8, publicada em
  novembro de 2026, hoje pela organização dart-frog.dev, criada pela Very Good
  Ventures). O comando `dart_frog build` gera um Dockerfile, que serve tanto
  para o Render quanto para o Cloud Run. Rotas por pastas. O pacote
  `dart_frog_auth` traz um middleware de token Bearer: a equipe escreve só a
  função que valida o token. Roda em cima do Shelf.
- **Shelf:** mantido pela equipe do Dart (versão 1.4.3), o mais leve. Serve,
  mas rotas, middleware e Dockerfile são montados à mão. Como o Dart Frog roda
  em cima dele, o que se aprender vale para os dois.
- **Serverpod:** a documentação mostra que dá para rodar sem banco (basta
  omitir a seção `database` da configuração) e validar um token externo com
  `authenticationHandler`. Isso corrige a ressalva do ADR do servidor Dart.
  Mas o forte dele é justamente banco, login e geração de código, que aqui
  ficam no Supabase. Seria peso sem retorno.

## Consequências
**Fica mais fácil:** custo zero sem cartão; um Dockerfile gerado pelo próprio
framework; troca para o Cloud Run sem reescrever o servidor; validação do
login concentrada num middleware.

**Fica mais difícil:**
- **Espera nas demonstrações.** O primeiro acesso depois de 15 min parado
  leva cerca de 1 min. A documentação oficial não fala do ping periódico, e a
  própria equipe do Render pede, no fórum da comunidade, para não manter o
  serviço acordado artificialmente. **Mitigação revista:** acordar o servidor
  cerca de 1 min antes de cada demonstração, em vez de depender do ping
  previsto no ADR do servidor Dart.
- **Latência.** O app (Brasil) fala com o servidor (Virgínia), que fala com o
  Supabase (São Paulo) a cada pedido. Medir no experimento; para uma fila, é
  provável que algumas centenas de milissegundos sejam aceitáveis.
- **LGPD.** Os dados passam por um servidor fora do Brasil. Com dados
  fictícios não pesa; rever antes de qualquer dado real (RNF01), e então o
  Cloud Run em São Paulo vira o candidato natural.
- **Reinícios.** O plano grátis pode reiniciar o serviço e apaga o disco. Não
  afeta o desenho, porque o servidor não guarda estado (ADR do servidor Dart).
- **Login.** O Dart Frog não valida JWT sozinho. A documentação do Supabase
  recomenda chaves assimétricas (ES256) e verificar o token no próprio
  servidor pela chave pública do endereço JWKS do projeto
  (`/auth/v1/.well-known/jwks.json`), e desaconselha o segredo compartilhado
  (HS256). Candidatos em Dart: `jose` (trabalha com chaves JWK e ES256) e
  `dart_jsonwebtoken` (suporta ES256; a página só mostra chaves em PEM). A
  alternativa de perguntar ao Supabase a cada pedido (`/auth/v1/user`) é mais
  simples, mas mais lenta, ainda mais com o servidor nos EUA.
- **Plano grátis do Render:** 750 h por mês valem para o workspace inteiro.
  Um segundo serviço grátis dividiria essas horas.

**AGENTS.md:** a seção Stack já cita o servidor Dart desde o PR "Atualizar
documentação após as ADRs" (#28). Se este ADR for aceito, acrescentar lá
"hospedado no Render, com Dart Frog". Só um humano muda o AGENTS.md.

## Antes de aceitar (experimento curto, branch `spike/*`)
- Publicar um "olá mundo" do Dart Frog no Render grátis via Docker. A
  documentação não diz explicitamente se serviços Docker entram no plano
  grátis (**a confirmar**).
- Ver no painel do Supabase se o projeto já usa chaves assimétricas.
- Validar um token do Supabase no servidor com `jose` ou `dart_jsonwebtoken`
  e escolher um dos dois.
- Medir o tempo de um pedido completo (app → servidor → Supabase) e a espera
  ao acordar.

## Perguntas em aberto
- A espera de cerca de 1 min ao acordar é aceitável nas demonstrações, com a
  mitigação de acordar antes?
- O Starter Tier do Google aceita um container nosso, e em que região? Só
  importa se o Render atrapalhar.
- A cota gratuita do Cloud Run vale na região de São Paulo? Não foi possível
  ler a página de preços; só importa no plano B.

## Fontes (consultadas em 2026-11-27)
- Render: render.com/docs/free, render.com/docs/regions, render.com/docs/docker.
- Google Cloud: docs.cloud.google.com/docs/starter-tier,
  docs.cloud.google.com/free/docs/free-cloud-features.
- Dart Frog: dart-frog.dev (getting-started, deploy/google-cloud-run,
  advanced/authentication), pub.dev/packages/dart_frog,
  github.com/dart-frog-dev/dart_frog.
- Shelf: pub.dev/packages/shelf, pub.dev/packages/shelf_router.
- Serverpod: docs.serverpod.dev (concepts/server-fundamentals/configuration,
  concepts/authentication/custom-overrides).
- Supabase e JWT: supabase.com/docs/guides/auth/jwts,
  supabase.com/docs/guides/auth/signing-keys, pub.dev/packages/jose,
  pub.dev/packages/dart_jsonwebtoken.
