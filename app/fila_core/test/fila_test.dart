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

  group('Convenções da Fila', () {
    late Fila fila;

    setUp(() {
      fila = Fila(const RegraOrdemDeChegada());
    });

    test('ausência esperada devolve nulo; contrato violado lança erro', () {
      // Ausência esperada: a fila esvazia e o paciente pode já ter sido chamado.
      expect(fila.chamarProximo(), isNull);
      expect(fila.posicaoDe('inexistente'), isNull);

      // Contrato violado: dois pacientes com o mesmo id.
      fila.entrar(criarPaciente('A'));
      expect(() => fila.entrar(criarPaciente('A')), throwsArgumentError);
    });

    test('a posição do próximo a ser chamado é 1, e não 0', () {
      fila.entrar(criarPaciente('A', minuto: 0));

      expect(fila.posicaoDe('A'), 1);
    });

    test('o mesmo id pode entrar de novo depois de ser chamado', () {
      // A unicidade vale só entre quem espera (decisão registrada no README).
      fila.entrar(criarPaciente('A'));
      fila.chamarProximo();

      fila.entrar(criarPaciente('A', minuto: 5));

      expect(fila.tamanho, 1);
    });

    test('desempate por entrada continua certo depois de saídas da fila', () {
      // Todos com a mesma chegada: só a ordem de entrada decide.
      fila.entrar(criarPaciente('A', minuto: 3));
      fila.entrar(criarPaciente('B', minuto: 3));
      fila.entrar(criarPaciente('C', minuto: 3));
      expect(fila.chamarProximo()?.id, 'A');

      fila.entrar(criarPaciente('D', minuto: 3));

      expect(fila.pacientesEmOrdem.map((p) => p.id), ['B', 'C', 'D']);
    });

    test('quem entra depois com chegada anterior passa na frente', () {
      // Ordem de entrada não é hora de chegada: a regra manda, o desempate não.
      fila.entrar(criarPaciente('tarde', minuto: 20));
      fila.entrar(criarPaciente('cedo', minuto: 1));

      expect(fila.chamarProximo()?.id, 'cedo');
    });

    test(
      'pacientesEmOrdem é um retrato: não acompanha mudanças posteriores',
      () {
        fila.entrar(criarPaciente('A', minuto: 0));
        final retrato = fila.pacientesEmOrdem;

        fila.entrar(criarPaciente('B', minuto: 5));
        fila.chamarProximo();

        expect(retrato.map((p) => p.id), ['A']);
        expect(fila.pacientesEmOrdem.map((p) => p.id), ['B']);
      },
    );

    test('a fila obedece a regra recebida e não lê chegada nem prioridade', () {
      // Regra inventada: ordem alfabética do id. Se a Fila lesse a chegada ou
      // a prioridade por conta própria, este teste falharia.
      final alfabetica = Fila(_RegraAlfabetica());
      alfabetica.entrar(
        criarPaciente('Z', minuto: 0, prioridade: TipoPrioridade.legal80),
      );
      alfabetica.entrar(criarPaciente('A', minuto: 30));

      expect(alfabetica.chamarProximo()?.id, 'A');
      expect(alfabetica.chamarProximo()?.id, 'Z');
    });

    test('a ordem de chegada ignora a prioridade (quem decide é a regra)', () {
      fila.entrar(
        criarPaciente('idoso', minuto: 30, prioridade: TipoPrioridade.legal80),
      );
      fila.entrar(criarPaciente('comum', minuto: 0));

      expect(fila.chamarProximo()?.id, 'comum');
    });

    test('fila grande sai exatamente na ordem de chegada', () {
      // Sustenta a decisão de calcular a ordem na hora: 2000 pessoas, entrando
      // em ordem embaralhada, saem corretas. Não mede tempo (testes de tempo
      // são frágeis); a medição está descrita no README.
      const total = 2000;
      for (var i = 0; i < total; i++) {
        final minutoEmbaralhado = (i * 37) % total; // 37 e 2000 são coprimos
        fila.entrar(
          Paciente(
            id: 'P$minutoEmbaralhado',
            nome: 'Paciente $minutoEmbaralhado',
            chegada: DateTime(
              2026,
              1,
              1,
              8,
            ).add(Duration(minutes: minutoEmbaralhado)),
          ),
        );
      }

      for (var esperado = 0; esperado < total; esperado++) {
        expect(fila.chamarProximo()?.id, 'P$esperado');
      }
      expect(fila.estaVazia, isTrue);
    });
  });
}

/// Regra de teste: ordem alfabética do id, ignorando chegada e prioridade.
class _RegraAlfabetica implements RegraOrdenacao {
  @override
  int comparar(Paciente a, Paciente b) => a.id.compareTo(b.id);
}
