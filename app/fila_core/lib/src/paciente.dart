/// Tipo de prioridade que um paciente tem direito por lei.
///
/// Um `enum` é uma lista fechada de valores possíveis: uma variável desse tipo
/// só pode valer um destes três. Isso evita erros de digitação (com texto
/// solto, "legal" e "Legal" seriam coisas diferentes).
///
/// ⚠️ HIPÓTESE: estes três valores são um ponto de partida. A classificação
/// real da unidade (por exemplo, risco clínico por cores) ainda não foi
/// definida e será confirmada na visita à unidade de saúde.
enum TipoPrioridade {
  /// Sem prioridade legal. Atendido por ordem de chegada.
  nenhuma,

  /// Prioridade legal: idosos (60+), gestantes, lactantes, pessoas com criança
  /// de colo, pessoas com deficiência (Lei 10.048/2000 e outras).
  legal,

  /// Prioridade legal especial: idosos com mais de 80 anos
  /// (Lei 13.466/2017, que alterou o Estatuto da Pessoa Idosa).
  legal80,
}

/// Uma pessoa que está (ou vai entrar) na fila.
///
/// É uma classe **imutável**: depois de criada, nenhum campo muda (`final`).
/// Em vez de alterar um paciente, cria-se outro. Isso deixa o código mais
/// previsível, porque ninguém muda um paciente "por baixo dos panos".
///
/// 🔒 LGPD: use apenas dados fictícios (nomes inventados, senhas como "A001").
/// Nunca coloque dados reais de pacientes no repositório.
class Paciente {
  /// Identificador único dentro da fila (por exemplo, a senha "A001").
  /// Duas pessoas na mesma fila não podem ter o mesmo `id`.
  final String id;

  /// Nome fictício, usado só para exibir e depurar.
  final String nome;

  /// Momento em que a pessoa chegou (fez o check-in).
  /// Quem chegou antes tem a data/hora menor.
  final DateTime chegada;

  /// Prioridade legal do paciente. Se não informada, é [TipoPrioridade.nenhuma].
  final TipoPrioridade prioridade;

  /// Construtor: cria um paciente.
  ///
  /// Os parâmetros entre chaves `{}` são **nomeados**: na hora de chamar,
  /// escreve-se o nome de cada um (`Paciente(id: 'A001', ...)`), o que deixa a
  /// chamada fácil de ler. A palavra `required` obriga a informar o valor.
  const Paciente({
    required this.id,
    required this.nome,
    required this.chegada,
    this.prioridade = TipoPrioridade.nenhuma,
  });

  /// Texto curto para facilitar a leitura de mensagens de teste e de depuração.
  @override
  String toString() => 'Paciente($id, $nome, ${prioridade.name})';
}
