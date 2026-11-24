import 'paciente.dart';
import 'regra_ordenacao.dart';

/// A fila de atendimento: guarda quem está esperando e decide quem é o próximo.
///
/// A [Fila] é o **mecanismo** (entrar, chamar, consultar). O **critério** de
/// ordem vem de fora, na forma de uma [RegraOrdenacao] (padrão Strategy).
/// Ela não tem tela, internet nem banco de dados: é só lógica, por isso pode
/// ser testada sozinha com `dart test`.
///
/// ## Convenções desta classe
///
/// - **Ausência esperada devolve `null`; contrato violado lança erro.** Pedir o
///   próximo de uma fila vazia ou a posição de um id que não está na fila são
///   situações normais (a fila esvazia, o paciente já foi chamado), então o
///   resultado é `null` e quem chama decide o que fazer. Já entrar com um id
///   repetido é um erro de quem chama, e esconder isso corromperia a fila,
///   então lança [ArgumentError].
/// - **A posição começa em 1**, como o paciente lê na tela ("você é o 1º").
///   Os índices internos da lista começam em 0, mas isso não vaza para fora.
/// - **A fila só usa o `id` do paciente** (para saber quem é quem). `chegada` e
///   `prioridade` pertencem à [RegraOrdenacao]; a fila nunca os lê.
/// - **A ordem é calculada na hora da consulta**, e não mantida na lista. É
///   mais simples, nunca fica desatualizada e continua certa se uma regra
///   futura depender do tempo (por exemplo, subir a prioridade de quem espera
///   há muito). O custo é irrelevante para filas de unidade de saúde.
class Fila {
  /// Regra que decide quem vem antes. Entregue na criação da fila.
  final RegraOrdenacao _regra;

  /// Quem está esperando, **na ordem em que entrou**. A lista não é mantida
  /// ordenada; a ordem de atendimento é calculada por [_comparar] sempre que
  /// precisamos dela. O `_` no começo do nome torna o item privado: só este
  /// arquivo enxerga.
  final List<_Entrada> _esperando = [];

  /// Número que será dado a quem entrar a seguir. Só cresce, nunca repete, por
  /// isso serve de desempate final mesmo depois de pessoas saírem da fila.
  int _proximaOrdemDeEntrada = 0;

  /// Cria uma fila que usa [regra] para decidir a ordem de atendimento.
  Fila(this._regra);

  /// Quantas pessoas estão esperando.
  int get tamanho => _esperando.length;

  /// `true` se ninguém está esperando.
  bool get estaVazia => _esperando.isEmpty;

  /// Coloca [paciente] na fila.
  ///
  /// Lança [ArgumentError] se já houver alguém com o mesmo `id` esperando,
  /// porque o `id` é o que identifica a pessoa (veja [posicaoDe]). A unicidade
  /// vale só entre quem espera: quem já foi chamado saiu da lista.
  void entrar(Paciente paciente) {
    final jaExiste = _esperando.any((e) => e.paciente.id == paciente.id);
    if (jaExiste) {
      throw ArgumentError.value(
        paciente.id,
        'paciente.id',
        'já existe um paciente com este id na fila',
      );
    }
    _esperando.add(_Entrada(paciente, _proximaOrdemDeEntrada++));
  }

  /// Chama o próximo paciente: remove-o da fila e o devolve.
  ///
  /// Devolve `null` se a fila estiver vazia. O tipo `Paciente?` (com `?`)
  /// significa "um Paciente ou nada (null)"; quem chama é obrigado a tratar
  /// o caso de não haver ninguém.
  ///
  /// Para achar o primeiro basta uma passada pela lista, sem ordená-la inteira.
  Paciente? chamarProximo() {
    if (estaVazia) {
      return null;
    }
    final proximo = _esperando.reduce((a, b) => _comparar(a, b) <= 0 ? a : b);
    _esperando.remove(proximo);
    return proximo.paciente;
  }

  /// Posição de quem tem o [id] informado: 1 é o próximo a ser chamado.
  ///
  /// Devolve `null` se não houver ninguém com esse `id` na fila.
  /// Para saber "quantos estão na frente", use `posicaoDe(id)! - 1`.
  int? posicaoDe(String id) {
    final indice = _entradasEmOrdem().indexWhere((e) => e.paciente.id == id);
    return indice == -1 ? null : indice + 1;
  }

  /// Retrato da fila na ordem em que as pessoas serão chamadas.
  ///
  /// Devolve uma **lista nova a cada chamada** (cópia): quem recebe pode mexer
  /// nela à vontade sem bagunçar a fila por dentro, e ela **não acompanha** o
  /// que acontece depois (quem entrar ou sair em seguida não aparece nela).
  /// Os [Paciente] dentro dela são imutáveis, então copiar a lista basta.
  List<Paciente> get pacientesEmOrdem =>
      _entradasEmOrdem().map((e) => e.paciente).toList();

  /// Cópia das entradas ordenada segundo a regra.
  List<_Entrada> _entradasEmOrdem() {
    final copia = List<_Entrada>.of(_esperando);
    copia.sort(_comparar);
    return copia;
  }

  /// Compara duas entradas no formato do `List.sort`: negativo se [a] vem
  /// antes, positivo se [b] vem antes, zero só para a mesma entrada.
  ///
  /// Se a regra considerar os dois empatados (resultado 0), vale a ordem em que
  /// entraram na fila. Esse desempate é a última palavra, e não um critério da
  /// unidade: quem define critérios é a [RegraOrdenacao]. Ele é necessário
  /// porque o `List.sort` do Dart não garante manter a ordem original entre
  /// empatados. Note que a ordem de entrada não é a hora de chegada: alguém
  /// pode entrar depois com chegada anterior.
  int _comparar(_Entrada a, _Entrada b) {
    final resultado = _regra.comparar(a.paciente, b.paciente);
    if (resultado != 0) {
      return resultado;
    }
    return a.ordemDeEntrada.compareTo(b.ordemDeEntrada);
  }
}

/// Um paciente esperando, junto do número da sua entrada na fila.
///
/// É um detalhe interno da [Fila] (por isso o `_`): o [Paciente] não precisa
/// saber em que ordem entrou, e a regra de ordenação também não.
class _Entrada {
  final Paciente paciente;
  final int ordemDeEntrada;

  const _Entrada(this.paciente, this.ordemDeEntrada);
}
