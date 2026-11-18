# 2026-11-17 — Backend, banco de dados e notificações push

Status: Proposto
Autor: Heitor   Aprovado por: —

> Pesquisa feita em 2026-11-18 com documentações oficiais e, onde indicado,
> fontes secundárias. Os números de planos gratuitos mudam; reconferir antes
> de aceitar. O que não foi verificado está marcado "a confirmar".

## Contexto
O app (Flutter, ver `2026-11-16-escolha-do-flutter.md`) precisa de:
- **Fila compartilhada em tempo real:** vários aparelhos enxergam a mesma
  fila e ela atualiza sem recarregar.
- **Notificações push:** avisar o paciente quando a vez estiver chegando,
  inclusive com o app fechado (requisito central do projeto).
- **Login** dos profissionais de saúde e controle de quem lê e altera o quê.
- **LGPD:** dados de saúde são dados pessoais sensíveis; importa onde ficam
  guardados e se é possível apagá-los.

Restrições: equipe de duas pessoas, prazo do cronograma do PIBIC, custo
zero (só planos gratuitos, sem verba), e nenhum dado real no repositório
(somente dados fictícios). O app é um protótipo de pesquisa, para Android e
iOS. A dupla domina Python e SQL e conhece um pouco de Node. O IFG não exigiu
servidor nacional ou próprio. A escala real só será conhecida após a pesquisa
de campo; assume-se uma UBS pequena de cidade do interior.

## Componentes a decidir
1. Banco de dados (filas, pacientes fictícios, atendimentos).
2. Backend / lógica no servidor (ordenação por risco, regras de acesso).
3. Serviço de push.
4. Autenticação.

## Critérios de avaliação
- Tempo real: atualiza a fila sem recarregar?
- Push: notificação nativa com o app fechado?
- LGPD: região dos dados, possibilidade de exclusão, termos de uso.
- Custo: o plano gratuito aguenta o projeto?
- Esforço: viável para duas pessoas nas sprints do cronograma?
- Flutter: existe pacote oficial e bem mantido (data da última versão)?
- Regras de acesso: dá para separar o que paciente e profissional enxergam?
- Dependência: o quanto fica difícil trocar de serviço depois?

## Alternativas consideradas
Fontes oficiais: supabase.com/pricing, supabase.com/docs (Realtime limits,
push notifications), firebase.google.com/pricing e /docs/firestore/locations,
render.com/docs/free, pub.dev.

| Critério | Firebase (Firestore + Auth + FCM) | Supabase (Postgres + Auth + Realtime) + FCM | Backend próprio (FastAPI + Postgres) |
|---|---|---|---|
| Tempo real | Listeners nativos do Firestore | Realtime nativo: no plano grátis, 200 conexões, 100 msg/s e 2 mi msgs/mês | Implementar WebSocket à mão |
| Push | FCM nativo | Sem push próprio; guia oficial usa webhook do banco + Edge Function (TypeScript) + API v1 do FCM | FCM via `firebase-admin` (Python) |
| LGPD / região | São Paulo (`southamerica-east1`) disponível; localização não muda depois | Região São Paulo (`sa-east-1`) aparece na listagem (termos de dados: a confirmar) | Depende da hospedagem |
| LGPD / exclusão | O dono do projeto (vocês) apaga os dados; Google atua como operador. Dados de usuário no Auth saem de sistemas ativos e backups em até 180 dias. Extensão "Delete User Data" apaga dados do Firestore ligados ao UID (por padrão, só o documento, sem subcoleções). Termos citam GDPR e CCPA, não a LGPD (a confirmar) | Vocês respondem ao titular; o Supabase só repassa pedidos (DPA). Apagar usuário: `auth.admin.deleteUser` (exige a chave `service_role`, só em servidor; quem tem objetos no Storage não pode ser apagado antes). Projeto apagado: dados removidos em até 30 dias; backups seguem outro prazo. Termos citam GDPR, não a LGPD (a confirmar) | Total (vocês mesmos apagam), mas a responsabilidade e a hospedagem são de vocês |
| Custo | Spark: 1 GiB, 50 mil leituras/dia, 20 mil escritas/dia; FCM grátis; **sem Cloud Functions** (exige Blaze, com cartão) | 500 MB, 50 mil usuários ativos/mês; **pausa após 1 semana sem uso** | Render grátis dorme após 15 min (~1 min para acordar); Postgres grátis expira em 30 dias; Railway sem plano grátis permanente; Fly.io: fontes conflitantes |
| Esforço | Baixo, mas o disparo do push exige servidor ou Blaze | Baixo: lógica em SQL/RLS; uma Edge Function em TypeScript para o push | Alto: a dupla mantém servidor e hospedagem |
| Pacote Flutter | `firebase_core`/`cloud_firestore` e `firebase_messaging` 17.1.0 (publisher firebase.google.com, verificado; Android, iOS, web) | `supabase_flutter` 2.18.3 (publisher supabase.io, verificado; Android, iOS, web, desktop) + `firebase_messaging` | `http`/`dio` + `firebase_messaging` |
| Regras de acesso | Regras de segurança do Firestore | RLS do Postgres | Código próprio |
| Dependência | Alta (NoSQL proprietário) | Média (Postgres padrão, dá para migrar) | Baixa |

- **Firebase:** o banco é NoSQL, e a dupla domina SQL. Cada atualização
  em tempo real consome leituras da cota diária. Sem Cloud Functions no plano
  grátis, o push precisaria de um servidor à parte.
- **Supabase + FCM:** banco relacional com a lógica da fila em SQL. O push
  usa o FCM de qualquer jeito (o Supabase não tem push próprio).
- **Backend próprio:** é o único caminho com Python, mas a hospedagem
  gratuita atual atrapalha demonstrações e deixa a dupla mantendo infra.

**FCM e exclusão:** o token do aparelho e o ID de instalação do Firebase
ficam retidos até uma chamada de exclusão do dono do projeto; os dados são
removidos de sistemas ativos e backups em até 180 dias, e apagar o token não
apaga o ID de instalação. A documentação diz que esses dados em geral não
identificam a pessoa. Se o app guardar o token junto do cadastro do paciente
(como no guia do Supabase), o token vira dado ligado a ele e entra na rotina
de exclusão.

**Fontes da exclusão:** supabase.com/legal/customer-resources/data-processing-addendum,
supabase.com/legal/privacy-resources/data-residency-and-transfers-faq,
supabase.com/docs/guides/auth/managing-user-data,
firebase.google.com/terms/data-processing-terms,
firebase.google.com/docs/extensions/official/delete-user-data,
firebase.google.com/docs/projects/manage-installations.
Os prazos são da documentação, não de parecer jurídico: confirmar com a
orientadora antes de qualquer uso com dados reais.

**Push no iOS (a confirmar, só fontes secundárias):** exige conta paga do
Apple Developer Program (cerca de US$ 99/ano) e aparelho físico para testar.
Sem essa conta, o push só pode ser validado no Android.

## Decisão
Em aberto. **Recomendação da pesquisa:** Supabase (banco, auth, tempo real,
regras de acesso) + FCM (push), sem servidor próprio nesta fase. Só um
humano muda o status para "Aceito".

## Consequências
Se a recomendação for aceita:
- Não há servidor para manter; a lógica da fila e da estimativa de espera
  fica em SQL (funções e gatilhos), e as regras de acesso em RLS.
- Python sai do caminho crítico; pode servir a scripts de simulação e teste
  com dados fictícios. A Edge Function de push é em TypeScript.
- Risco: o projeto gratuito pausa após 1 semana sem uso. Mitigar com ping
  periódico (a confirmar) ou acordar o projeto antes de demonstrações.
- Dependência de duas plataformas de terceiros (Supabase e Google/FCM).
- Push no iOS depende de conta Apple paga.
- Estimativa de escala (cálculo da pesquisa, sem dados reais): 50 pacientes
  com 40 atualizações por dia dão cerca de 60 mil mensagens Realtime por mês,
  contra 2 milhões de cota. Reavaliar após as visitas de campo.

Ao aceitar, atualizar no mesmo PR:
- `AGENTS.md`: seção "Stack" (backend, banco e push deixam de ser
  "não definidos") e a seção "Comandos", se houver novos.
- `MEMORY.md`: "Decisões vigentes" e "Pendências".

## Perguntas em aberto
- Alguém (IFG ou orientadora) tem conta Apple Developer para o push no iOS?
- Os dados da fila identificam o paciente ou usam só senha/código?
- Quantas pessoas usam por dia (estimar pelas visitas de campo)?
- O que o Deep Research de LGPD (Gemini) diz sobre armazenamento fora do
  Brasil e transferência internacional de dados? O uso com pacientes reais
  exige TCLE e comitê de ética (a tratar com a orientadora) e deve rever
  este ADR.
- A região São Paulo do Supabase está coberta pelos termos de dados deles?
