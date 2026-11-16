# 2026-11-16 — Escolha do Flutter para o app mobile

Status: Proposto
Autor: Heitor   Aprovado por: —

## Contexto
O projeto é um aplicativo móvel de gestão de filas (check-in, monitoramento
da fila e notificações push). A equipe tem duas pessoas, o prazo é o do
cronograma do PIBIC, e o app precisa chegar a pacientes com aparelhos
diferentes. A stack ainda não estava definida (ver AGENTS.md).

## Decisão
Usar Flutter (linguagem Dart) para o aplicativo mobile.

## Alternativas consideradas
- React Native: também multiplataforma, mas exigiria aprender JavaScript e
  o ecossistema React; sem vantagem clara para a dupla.
- Nativo (Android e iOS separados): dobra o trabalho de uma equipe de duas
  pessoas.
- PWA (aplicativo web): mais simples de publicar, mas as notificações push
  e o comportamento com o app fechado são mais limitados, e esse é um
  requisito central do projeto.

## Consequências
- Um único código para Android e iOS.
- É preciso aprender Dart e Flutter; o protótipo `spike/` ajuda nisso.
- Backend, banco e serviço de push continuam em aberto, com ADRs próprios.
- Ao aceitar este ADR, o AGENTS.md passa a ter a seção de comandos
  (build, testes, lint) do Flutter e a seção "Stack" é atualizada.
