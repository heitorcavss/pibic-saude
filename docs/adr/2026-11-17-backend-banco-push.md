# 2026-11-17 — Backend, banco de dados e notificações push

Status: Proposto
Autor: Heitor   Aprovado por: —

> Rascunho de estrutura. A pesquisa das alternativas ainda não foi feita:
> os campos marcados "a pesquisar" devem ser preenchidos com dados das
> documentações oficiais antes de qualquer decisão.

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
próximo de zero, e nenhum dado real no repositório (somente dados fictícios).

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
Todas as células abaixo estão **a pesquisar**.

| Critério | Firebase (Firestore + Auth + FCM) | Supabase (Postgres + Auth + Realtime) | Backend próprio (API + Postgres) |
|---|---|---|---|
| Tempo real | a pesquisar | a pesquisar | a pesquisar |
| Push | a pesquisar | a pesquisar (provavelmente FCM à parte) | a pesquisar |
| LGPD / região | a pesquisar | a pesquisar | a pesquisar |
| Custo | a pesquisar | a pesquisar | a pesquisar |
| Esforço | a pesquisar | a pesquisar | a pesquisar |
| Pacote Flutter | a pesquisar | a pesquisar | a pesquisar |
| Regras de acesso | a pesquisar | a pesquisar | a pesquisar |
| Dependência | a pesquisar | a pesquisar | a pesquisar |

- **Firebase:** sugerido numa conversa anterior; ainda sem análise própria.
- **Supabase:** alternativa com banco relacional.
- **Backend próprio:** referência de máximo controle e máximo trabalho.

## Decisão
Em aberto. Será preenchida depois da pesquisa, e só um humano muda o status
para "Aceito".

## Consequências
A preencher junto com a decisão. Ao aceitar, atualizar no mesmo PR:
- `AGENTS.md`: seção "Stack" (backend, banco e push deixam de ser
  "não definidos") e a seção "Comandos", se houver novos.
- `MEMORY.md`: "Decisões vigentes" e "Pendências".

## Perguntas em aberto
- Os dados da fila identificam o paciente ou usam só senha/código?
- Quantas pessoas usam por dia (estimar pelas visitas de campo)?
- A equipe aceita depender de um serviço de terceiros?
- O que o Deep Research de LGPD (Gemini) diz sobre armazenamento fora do
  Brasil e transferência internacional de dados?
