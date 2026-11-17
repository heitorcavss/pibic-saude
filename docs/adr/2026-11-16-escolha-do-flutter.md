# 2026-11-16 — Escolha do Flutter para o app mobile

Status: Aceito
Autor: Heitor   Aprovado por: Miguel (2026-11-16)
Revisão cruzada: Heitor (pendente, no PR que aceita este ADR)

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

## Evidência do spike
Spike descartável na branch `spike/flutter-basico` (commit `93d670e`, pasta
`spike_flutter_basico/`). Ele não entra na `main`; serve só de evidência.

- Ambiente: Flutter 3.50.0 (stable), Dart 3.14, Windows 10, alvo web (Chrome).
- O que foi feito: uma tela com 4 pacientes fictícios em memória (nome e hora)
  e o botão "Chamar próximo", que remove o primeiro da lista; ao esvaziar, a
  tela mostra "Fila vazia" e o botão é desabilitado. Dois testes de widget.
- Resultados:
  - `flutter create --platforms=web`: ok.
  - `flutter test`: 2 de 2 testes passaram, sem emulador nem navegador.
  - `flutter analyze`: 2 avisos informativos, sem erros. Eles dizem que
    `package:flutter/material.dart` está obsoleto e que o recomendado é
    `package:material_ui/material_ui.dart`. A migração não foi feita; fica
    como decisão pendente (ver MEMORY.md).
- Aprendizado (ponto de vista de quem vem de Java):
  - A interface é uma árvore de widgets escrita em código, sem XML nem layout
    separado. O estado mutável fica num objeto `State` à parte, e `setState`
    manda redesenhar a tela.
  - Dart não tem `private`; um `_` no início do nome torna o item privado ao
    arquivo. Getters são implícitos, e `final`, `const` e parâmetros nomeados
    com `required` fazem o papel de POJO e construtor.
  - Dificuldades: lista mutável exige `List.of` (uma `const` quebra o
    `removeAt`); distinguir `StatelessWidget` de `StatefulWidget` e entender
    `const` nos widgets leva tempo.
- Ainda não validado, e portanto não sustentado por este ADR:
  - execução em emulador ou aparelho Android/iOS (o spike foi só web);
  - notificações push com o app fechado (exigem Android/iOS e um serviço de
    push, a decidir em ADR próprio);
  - qualquer dado real; todos os dados do spike são fictícios.

## Consequências
- Um único código para Android e iOS.
- É preciso aprender Dart e Flutter; o spike mostrou que escrever, testar e
  rodar é viável, e o ciclo de teste não depende de emulador.
- Backend, banco e serviço de push continuam em aberto, com ADRs próprios.
- O AGENTS.md passa a ter a seção "Stack" atualizada e a seção "Comandos"
  (análise, testes e execução) do Flutter, neste mesmo PR.
- Antes do primeiro sprint, é preciso confirmar o app em Android (emulador ou
  aparelho), porque as notificações push dependem disso.
