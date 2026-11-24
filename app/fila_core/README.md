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

Escolhas feitas ao escrever a `Fila`. Os pontos 1, 2, 3, 4, 6 e 7 são
**convenções internas**: não dependem de nenhuma regra da unidade de saúde e já
estão decididos e travados por testes (grupo "Convenções da Fila"). Os pontos 5
e 8 continuam em aberto porque dependem de decisões do projeto. Se uma decisão
tiver impacto no restante do app, vira ADR.

1. **Ordem calculada na hora, não mantida na lista. (Decidido)**
   - A lista guarda a ordem de entrada; a ordem de atendimento é calculada a
     cada consulta. Continua certa se uma regra futura depender do tempo.
   - Medição única, na máquina de desenvolvimento (Dart 3.14, 2000 pessoas,
     regra de prioridade legal): esvaziar a fila com `chamarProximo` levou
     cerca de 520 ms antes e 26 ms depois, porque `chamarProximo` agora acha o
     primeiro numa passada, sem ordenar tudo, e o desempate deixou de usar
     `indexOf`. Uma consulta de `posicaoDe` ficou em cerca de 1 ms nas duas
     versões. Para as dezenas de pessoas de uma fila real, a diferença não
     aparece. Números de uma execução só, apenas como ordem de grandeza.
2. **Desempate pela ordem de entrada. (Decidido)** Cada entrada recebe um
   número crescente que nunca se repete, e ele só decide quando a regra empata.
   A ordem de entrada não é a hora de chegada: quem entra depois com chegada
   anterior passa na frente. Critérios da unidade pertencem à regra, não à fila.
3. **Ausência esperada devolve `null`; contrato violado lança erro. (Decidido)**
   Fila vazia e id desconhecido são situações normais (`null`). Id repetido é
   erro de quem chama (`ArgumentError`). A justificativa está na documentação da
   classe `Fila`.
4. **A posição começa em 1. (Decidido)** É como o paciente lê na tela; os índices
   da lista (0) não vazam para fora.
5. **A unicidade do id só vale entre quem espera. (EM ABERTO)** É consequência do
   código: quem já foi chamado pode entrar de novo com o mesmo id (há um teste
   que registra isso). Depende de o que é o `id` (senha do dia ou pessoa), ou
   seja, de RF23, RF01 e RF07.
6. **`pacientesEmOrdem` é um retrato em cópia. (Decidido)** Quem recebe pode
   mexer sem bagunçar a fila, e a lista não acompanha o que acontece depois.
   Copiar a lista basta porque `Paciente` é imutável.
7. **A `Fila` só usa o `id` do paciente. (Decidido)** `chegada` e `prioridade`
   ficam inteiramente com a regra; um teste usa uma regra que ignora os dois.
8. **Não existe método para tirar alguém sem chamá-lo. (EM ABERTO)** Falta a
   operação de desistência (RF12). Nenhuma decisão foi tomada ainda.

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
