# fila_core — núcleo da fila

Pacote **Dart puro** (sem Flutter) com a lógica da fila de atendimento. Não tem
tela, internet nem banco de dados: só as regras, que podem ser testadas
sozinhas.

> ⚠️ **A regra de prioridade desta versão é uma HIPÓTESE.** Ela existe para o
> núcleo funcionar e ser testado, e **não foi confirmada** com a unidade de
> saúde nem por pesquisas posteriores. Veja [a seção sobre a hipótese](#a-regra-de-prioridade-é-uma-hipótese).

## O que ele faz

- **Entrar:** registra um paciente na fila.
- **Chamar o próximo:** escolhe quem é atendido primeiro, tira da fila e devolve.
- **Consultar:** informa a posição de um paciente e quantos estão esperando.

## Peças (em `lib/src/`)

| Arquivo | Peça | Papel |
|---|---|---|
| `paciente.dart` | `Paciente`, `TipoPrioridade` | Dados de quem está na fila: id, nome (fictício), hora de chegada e prioridade (`nenhuma`, `legal`, `legal80`). |
| `regra_ordenacao.dart` | `RegraOrdenacao`, `RegraOrdemDeChegada` | O contrato "quem vem antes?" e a regra mais simples (ordem de chegada). |
| `regra_prioridade_legal.dart` | `RegraPrioridadeLegal` | A regra provisória: 80+, depois prioridade legal, depois os demais; chegada desempata. |
| `fila.dart` | `Fila` | O mecanismo: `entrar`, `chamarProximo`, `posicaoDe`, `tamanho`, `estaVazia`, `pacientesEmOrdem`. |

Quem usa o pacote importa tudo de uma vez:
`import 'package:fila_core/fila_core.dart';`.

## Por que a regra é uma peça separada (padrão Strategy)

A `Fila` não sabe *como* a ordem é decidida: ela só pergunta a uma
`RegraOrdenacao`. Assim:

- o **mecanismo** (entrar, chamar, consultar) é fixo;
- a **regra** (quem vem antes) é trocável.

Quando a unidade definir o critério real (por exemplo, classificação de risco
por cores), escreve-se uma nova classe que `implements RegraOrdenacao` e entrega-se
à `Fila`. A `Fila` e os testes dela não mudam. Também dá para comparar duas
regras sobre os mesmos pacientes simulados, o que serve ao relatório do PIBIC.

```dart
final fila = Fila(const RegraPrioridadeLegal());
fila.entrar(Paciente(id: 'A001', nome: 'Fulano Fictício', chegada: DateTime.now()));
final proximo = fila.chamarProximo(); // Paciente? (nulo se a fila estiver vazia)
```

## A regra de prioridade é uma hipótese

`RegraPrioridadeLegal` vem do conhecimento geral da legislação brasileira, e não
de um documento da unidade:

- Lei 10.048/2000: idosos, gestantes, lactantes, pessoas com criança de colo e
  pessoas com deficiência;
- Estatuto da Pessoa Idosa (Lei 10.741/2003): prioridade a partir de 60 anos;
- Lei 13.466/2017: prioridade especial para mais de 80 anos;
- Lei Brasileira de Inclusão (Lei 13.146/2015): reforça a prioridade da pessoa
  com deficiência.

**Ressalva importante:** em unidade de saúde, a *classificação de risco clínico*
costuma vir **antes** da prioridade legal (um caso grave passa na frente de um
idoso estável). Esta versão **não considera risco clínico**. A regra real deve
ser confirmada na visita à unidade e em pesquisas posteriores. Antes de citar as
leis em qualquer relatório, confira o texto atual no site do Planalto.

## Decisões de projeto do algoritmo

Escolhas feitas ao escrever a `Fila`. Todas são **discutíveis**: vale revisá-las
quando houver dados reais ou necessidade nova. Quando uma for decidida de vez e
tiver impacto no restante do app, vira ADR.

1. **Ordenar a cada consulta ou manter a lista ordenada.**
   - Hoje o código copia e ordena a lista em toda chamada de `chamarProximo`,
     `posicaoDe` e `pacientesEmOrdem`.
   - Vantagem: simples e sem risco de a lista ficar fora de ordem.
   - Custo: trabalho repetido, e o `indexOf` do desempate percorre a lista a
     cada empate.
   - Não há medição no projeto, então não se sabe se isso pesa para o tamanho
     real da fila. A alternativa é inserir já na posição certa.
2. **Empate resolvido pela ordem de entrada na fila**, e não por outro critério.
   A ordem de entrada não é a hora de chegada: um paciente pode entrar depois
   com chegada anterior (o teste "ordem de chegada sem prioridade" usa isso).
3. **Ausência vira `null`** em fila vazia (`chamarProximo`) e em id desconhecido
   (`posicaoDe`), mas **id repetido lança erro**. O código mistura os dois
   estilos. O comentário só justifica o erro do id; a escolha do `null` não tem
   justificativa escrita.
4. **A posição começa em 1**, enquanto os índices da lista começam em 0.
5. **A unicidade do id só vale entre quem espera.** Quem já foi chamado saiu da
   lista, então o mesmo id pode entrar de novo. É consequência do código; o
   comentário não discute.
6. **Cópia defensiva** em `pacientesEmOrdem`: quem recebe a lista não consegue
   bagunçar a fila por dentro.
7. **A `Fila` só usa o `id` do paciente.** `chegada` e `prioridade` ficam
   inteiramente com a regra de ordenação.
8. **Não existe método para tirar alguém sem chamá-lo** (por exemplo, uma
   desistência). É uma ausência no código, e não uma decisão registrada.

## Fora do escopo desta versão

Telas, backend, persistência, notificações, classificação de risco, estimativa
de tempo de espera e limites de espera.

## Como rodar

Precisa do Dart SDK (vem junto com o Flutter). Dentro desta pasta:

```bash
dart pub get     # baixa as dependências
dart analyze     # análise estática (linter)
dart test        # roda os testes
```

Os testes têm nomes em português e descrevem o comportamento esperado; leia-os
primeiro para entender o que a fila deve fazer. Os dados usados são sempre
fictícios (LGPD).
