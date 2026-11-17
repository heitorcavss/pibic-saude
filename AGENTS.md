# AGENTS.md — regras para agentes neste repositório

Leia este arquivo e o MEMORY.md antes de qualquer tarefa.

## Projeto
App móvel de gestão de filas para uma unidade pública de saúde
(Inhumas-GO). Pesquisa PIBIC/IFG, desenvolvimento incremental (MVP),
Scrum adaptado com sprints de ~1 mês. Equipe: Miguel e Heitor;
orientação: Profa. Celyce Lula. Contexto detalhado: README.md.

## Estado atual
Ver MEMORY.md. Ele é a fonte do que está decidido e em andamento.

## Stack
- App mobile: Flutter (Dart), conforme o ADR 2026-11-16-escolha-do-flutter.
- Backend, banco e serviço de push: ainda não definidos. Não presuma.
  Se a tarefa exigir essa escolha, proponha um ADR (docs/adr/) e pare.

## Como trabalhar
- Comece cada tarefa com um plano curto e espere aprovação humana.
- Execute apenas a tarefa pedida; não avance para a seguinte sozinho.
- Mudanças pequenas e revisáveis; um assunto por PR.
- Decisão de arquitetura = ADR com status "Proposto". Só um humano aceita.
- Ao terminar, proponha a atualização do MEMORY.md no mesmo PR.
- Se algo estiver ambíguo, pergunte. Não mude regras deste arquivo
  nem decisões de ADRs aceitos por conta própria.

## Git
- Nunca faça push na main nem merge de PR.
- Branch: tipo/descricao-curta (feat, fix, docs, refactor, spike).
- Commits: Conventional Commits, em português (ex.: "feat: check-in do paciente").

## Dados e segurança
- Nenhum dado real de paciente ou das visitas de campo no repositório (LGPD).
  Use apenas dados fictícios.
- Nenhuma credencial ou chave no código; use variáveis de ambiente.

## Código
Comentários e nomes de domínio em português; identificadores técnicos
conforme a convenção da linguagem (Dart: `dart format` e as regras do
`flutter_lints`). Mais detalhes entram conforme o projeto crescer.

## Comandos
Rode dentro da pasta do app Flutter (o local do app ainda será definido na
primeira implementação).
- `flutter pub get`: baixa as dependências.
- `flutter analyze`: análise estática (equivale ao compilador e linter).
- `flutter test`: roda os testes automatizados.
- `flutter run -d chrome`: executa o app no navegador; é interativo, então
  um humano confere o resultado.
- Android e iOS (emulador ou aparelho): ainda não validados; ver o ADR.
