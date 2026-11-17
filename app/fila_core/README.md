# fila_core — núcleo da fila

Pacote **Dart puro** (sem Flutter) com a lógica da fila de atendimento. Não tem
tela, internet nem banco de dados: só as regras, que podem ser testadas
sozinhas.

> ⚠️ **A regra de prioridade desta versão é uma HIPÓTESE.** Ela existe para o
> núcleo funcionar e ser testado, e **não foi confirmada** com a unidade de
> saúde nem com a orientadora. Veja [a seção sobre a hipótese](#a-regra-de-prioridade-é-uma-hipótese).

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
ser confirmada na visita à unidade e com a orientadora. Antes de citar as leis em
qualquer relatório, confira o texto atual no site do Planalto.

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
