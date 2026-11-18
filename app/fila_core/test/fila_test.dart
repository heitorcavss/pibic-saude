// Testes do MECANISMO da fila (entrar, chamar, consultar), usando a regra mais
// simples: ordem de chegada. Cada teste descreve em português o que a fila
// deve fazer; se um teste falhar, uma regra do sistema foi quebrada.
//
// Para rodar: `dart test` (dentro da pasta app/fila_core).
import 'package:fila_core/fila_core.dart';
import 'package:test/test.dart';

/// Cria um paciente fictício. `minuto` é o minuto de chegada depois das 08:00,
/// então minuto 0 chegou primeiro e minuto 10 chegou depois.
Paciente criarPaciente(
  String id, {
  int minuto = 0,
  TipoPrioridade prioridade = TipoPrioridade.nenhuma,
}) {
  return Paciente(
    id: id,
    nome: 'Paciente $id', // nome fictício (nunca use dados reais)
    chegada: DateTime(2026, 1, 1, 8, minuto),
    prioridade: prioridade,
  );
}

void main() {
  group('Fila (mecanismo, com ordem de chegada)', () {
    late Fila fila; // `late`: será criada no setUp, antes de cada teste.

    setUp(() {
      fila = Fila(const RegraOrdemDeChegada());
    });

    test('fila vazia retorna nulo ao chamar o próximo', () {
      expect(fila.estaVazia, isTrue);
      expect(fila.tamanho, 0);
      expect(fila.chamarProximo(), isNull);
    });

    test('entrar aumenta o tamanho e a fila deixa de ser vazia', () {
      fila.entrar(criarPaciente('A001'));

      expect(fila.estaVazia, isFalse);
      expect(fila.tamanho, 1);
    });

    test('ordem de chegada sem prioridade: quem chegou primeiro é chamado primeiro', () {
      // Entram fora de ordem de propósito: a regra olha a hora de chegada,
      // não a ordem em que o método entrar() foi chamado.
      fila.entrar(criarPaciente('B', minuto: 10));
      fila.entrar(criarPaciente('A', minuto: 0));
      fila.entrar(criarPaciente('C', minuto: 20));

      expect(fila.chamarProximo()?.id, 'A');
      expect(fila.chamarProximo()?.id, 'B');
      expect(fila.chamarProximo()?.id, 'C');
      expect(fila.chamarProximo(), isNull);
    });

    test('chamar o próximo remove o paciente da fila', () {
      fila.entrar(criarPaciente('A', minuto: 0));
      fila.entrar(criarPaciente('B', minuto: 5));

      fila.chamarProximo();

      expect(fila.tamanho, 1);
      expect(fila.posicaoDe('A'), isNull); // já foi chamado
    });

    test('posição começa em 1 e o paciente ausente não tem posição', () {
      fila.entrar(criarPaciente('A', minuto: 0));
      fila.entrar(criarPaciente('B', minuto: 5));

      expect(fila.posicaoDe('A'), 1);
      expect(fila.posicaoDe('B'), 2);
      expect(fila.posicaoDe('XYZ'), isNull);
    });

    test('posição atualiza após chamar o próximo', () {
      fila.entrar(criarPaciente('A', minuto: 0));
      fila.entrar(criarPaciente('B', minuto: 5));
      fila.entrar(criarPaciente('C', minuto: 10));
      expect(fila.posicaoDe('C'), 3);

      fila.chamarProximo(); // sai o A

      expect(fila.posicaoDe('B'), 1);
      expect(fila.posicaoDe('C'), 2);
    });

    test('empate de chegada é resolvido pela ordem de entrada na fila', () {
      // Mesmo minuto de chegada: a regra considera empate (resultado 0).
      fila.entrar(criarPaciente('primeiro', minuto: 3));
      fila.entrar(criarPaciente('segundo', minuto: 3));

      expect(fila.chamarProximo()?.id, 'primeiro');
      expect(fila.chamarProximo()?.id, 'segundo');
    });

    test('id repetido na fila lança erro e não altera a fila', () {
      fila.entrar(criarPaciente('A'));

      expect(
        () => fila.entrar(criarPaciente('A', minuto: 9)),
        throwsArgumentError,
      );
      expect(fila.tamanho, 1);
    });

    test('pacientesEmOrdem devolve cópia: mexer nela não altera a fila', () {
      fila.entrar(criarPaciente('A', minuto: 0));

      final copia = fila.pacientesEmOrdem;
      copia.clear();

      expect(fila.tamanho, 1);
    });
  });
}
