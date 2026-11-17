import 'paciente.dart';
import 'regra_ordenacao.dart';

/// A fila de atendimento: guarda quem está esperando e decide quem é o próximo.
///
/// A [Fila] é o **mecanismo** (entrar, chamar, consultar). O **critério** de
/// ordem vem de fora, na forma de uma [RegraOrdenacao] (padrão Strategy).
/// Ela não tem tela, internet nem banco de dados: é só lógica, por isso pode
/// ser testada sozinha com `dart test`.
class Fila {
  /// Regra que decide quem vem antes. Entregue na criação da fila.
  final RegraOrdenacao _regra;

  /// Pacientes que estão esperando, **na ordem em que entraram**.
  /// A lista não é mantida ordenada; a ordem de atendimento é calculada por
  /// [_emOrdemDeAtendimento] sempre que precisamos dela. O `_` no começo do
  /// nome torna o item privado: só este arquivo enxerga.
  final List<Paciente> _esperando = [];

  /// Cria uma fila que usa [regra] para decidir a ordem de atendimento.
  Fila(this._regra);

  /// Quantas pessoas estão esperando.
  int get tamanho => _esperando.length;

  /// `true` se ninguém está esperando.
  bool get estaVazia => _esperando.isEmpty;

  /// Coloca [paciente] na fila.
  ///
  /// Lança [ArgumentError] se já houver alguém com o mesmo `id` esperando,
  /// porque o `id` é o que identifica a pessoa (veja [posicaoDe]).
  void entrar(Paciente paciente) {
    final jaExiste = _esperando.any((p) => p.id == paciente.id);
    if (jaExiste) {
      throw ArgumentError.value(
        paciente.id,
        'paciente.id',
        'já existe um paciente com este id na fila',
      );
    }
    _esperando.add(paciente);
  }

  /// Chama o próximo paciente: remove-o da fila e o devolve.
  ///
  /// Devolve `null` se a fila estiver vazia. O tipo `Paciente?` (com `?`)
  /// significa "um Paciente ou nada (null)"; quem chama é obrigado a tratar
  /// o caso de não haver ninguém.
  Paciente? chamarProximo() {
    if (estaVazia) {
      return null;
    }
    final proximo = _emOrdemDeAtendimento().first;
    _esperando.remove(proximo);
    return proximo;
  }

  /// Posição de quem tem o [id] informado: 1 é o próximo a ser chamado.
  ///
  /// Devolve `null` se não houver ninguém com esse `id` na fila.
  /// Para saber "quantos estão na frente", use `posicaoDe(id)! - 1`.
  int? posicaoDe(String id) {
    final ordenada = _emOrdemDeAtendimento();
    final indice = ordenada.indexWhere((p) => p.id == id);
    return indice == -1 ? null : indice + 1;
  }

  /// Cópia da fila na ordem em que as pessoas serão chamadas.
  ///
  /// Devolve uma **cópia** (`List.of`): quem recebe pode olhar à vontade, mas
  /// não consegue bagunçar a fila por dentro.
  List<Paciente> get pacientesEmOrdem => _emOrdemDeAtendimento();

  /// Ordena uma cópia da lista segundo a regra.
  ///
  /// Se a regra considerar dois pacientes empatados (resultado 0), vale a ordem
  /// em que entraram na fila. Esse desempate extra é necessário porque o
  /// `List.sort` do Dart não garante manter a ordem original entre empatados.
  List<Paciente> _emOrdemDeAtendimento() {
    final copia = List<Paciente>.of(_esperando);
    copia.sort((a, b) {
      final resultado = _regra.comparar(a, b);
      if (resultado != 0) {
        return resultado;
      }
      return _esperando.indexOf(a).compareTo(_esperando.indexOf(b));
    });
    return copia;
  }
}
