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
Ainda não definida. Não presuma linguagem, framework ou banco.
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
conforme a convenção da linguagem. Detalhes entram após o ADR da stack.

## Comandos
A definir junto com a stack (build, testes, lint).
