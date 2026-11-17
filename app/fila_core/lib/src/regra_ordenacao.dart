import 'paciente.dart';

/// Contrato de uma regra de ordenação: responde "entre dois pacientes, quem
/// vem antes na fila?".
///
/// Isto é o padrão de projeto **Strategy** (estratégia): a [Fila] não sabe *como*
/// a ordem é decidida; ela só pergunta a uma [RegraOrdenacao]. Assim, quando a
/// unidade de saúde definir o critério real (por exemplo, classificação de risco
/// por cores), basta escrever uma nova regra e entregá-la à fila. A [Fila] e os
/// testes dela não mudam.
///
/// `abstract interface class` é um contrato puro: diz **o que** toda regra deve
/// ter (o método [comparar]), mas não diz **como** fazer. Cada regra concreta
/// usa `implements RegraOrdenacao` e escreve o seu próprio [comparar].
abstract interface class RegraOrdenacao {
  /// Compara dois pacientes e diz quem deve ser atendido primeiro.
  ///
  /// O resultado segue a convenção usada pelo `List.sort` do Dart:
  /// - **negativo**: [a] vem antes de [b];
  /// - **positivo**: [b] vem antes de [a];
  /// - **zero**: a regra considera os dois empatados.
  int comparar(Paciente a, Paciente b);
}

/// Regra mais simples possível: quem chegou primeiro é atendido primeiro
/// (é a "fila de triagem" descrita no README: ordem de chegada).
class RegraOrdemDeChegada implements RegraOrdenacao {
  const RegraOrdemDeChegada();

  @override
  int comparar(Paciente a, Paciente b) => a.chegada.compareTo(b.chegada);
}
