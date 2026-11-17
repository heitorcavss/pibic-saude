import 'paciente.dart';
import 'regra_ordenacao.dart';

/// Regra de ordenação por **prioridade legal**, com desempate por chegada.
///
/// Ordem de atendimento:
/// 1. pacientes com mais de 80 anos ([TipoPrioridade.legal80]);
/// 2. demais pacientes com prioridade legal ([TipoPrioridade.legal]);
/// 3. pacientes sem prioridade ([TipoPrioridade.nenhuma]).
///
/// Dentro de cada grupo, quem chegou primeiro é atendido primeiro.
///
/// ⚠️ HIPÓTESE — REGRA PROVISÓRIA (placeholder), NÃO confirmada:
/// esta regra foi escolhida só para o núcleo da fila poder funcionar e ser
/// testado. Ela vem do conhecimento geral da legislação brasileira, não de
/// um documento da unidade de saúde nem do projeto:
/// - Lei 10.048/2000: prioridade a idosos, gestantes, lactantes, pessoas com
///   criança de colo e pessoas com deficiência;
/// - Estatuto da Pessoa Idosa (Lei 10.741/2003): prioridade a partir dos 60 anos;
/// - Lei 13.466/2017: prioridade especial para quem tem mais de 80 anos;
/// - Lei Brasileira de Inclusão (Lei 13.146/2015): reforça a prioridade da
///   pessoa com deficiência.
///
/// Em unidade de saúde, a **classificação de risco clínico** costuma vir ANTES
/// da prioridade legal (um caso grave passa na frente de um idoso estável).
/// Esta regra ainda não considera risco clínico. A regra real deve ser
/// confirmada na visita à unidade e pesquisas posteriores. Confira também o texto
/// atual das leis no site do Planalto antes de citá-las em qualquer relatório.
class RegraPrioridadeLegal implements RegraOrdenacao {
  const RegraPrioridadeLegal();

  @override
  int comparar(Paciente a, Paciente b) {
    // 1º critério: o grupo de prioridade. Quem tem "peso" menor vem antes.
    final porPrioridade = _peso(a.prioridade).compareTo(_peso(b.prioridade));
    if (porPrioridade != 0) {
      return porPrioridade;
    }

    // 2º critério (desempate): empatou na prioridade? Vale a ordem de chegada.
    return a.chegada.compareTo(b.chegada);
  }

  /// Converte o tipo de prioridade em um número: quanto MENOR, mais cedo é
  /// atendido. O `switch` abaixo é uma "expressão": devolve um valor para cada
  /// caso, e o Dart avisa se esquecermos algum valor do enum.
  int _peso(TipoPrioridade tipo) => switch (tipo) {
    TipoPrioridade.legal80 => 0,
    TipoPrioridade.legal => 1,
    TipoPrioridade.nenhuma => 2,
  };
}
