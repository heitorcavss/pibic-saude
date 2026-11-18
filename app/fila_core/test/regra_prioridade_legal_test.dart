// Testes da regra HIPÓTESE de prioridade legal e da troca de regra na Fila.
// Lembrete: a regra é provisória; estes testes documentam o comportamento
// atual e devem ser revistos quando a unidade confirmar o critério real.
import 'package:fila_core/fila_core.dart';
import 'package:test/test.dart';

/// Cria um paciente fictício. `minuto` é o minuto de chegada depois das 08:00.
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
  group('RegraPrioridadeLegal (HIPÓTESE)', () {
    late Fila fila;

    setUp(() {
      fila = Fila(const RegraPrioridadeLegal());
    });

    test(
      'prioridade legal passa na frente de quem chegou antes sem prioridade',
      () {
        fila.entrar(criarPaciente('comum', minuto: 0));
        fila.entrar(
          criarPaciente(
            'gestante',
            minuto: 30,
            prioridade: TipoPrioridade.legal,
          ),
        );

        expect(fila.chamarProximo()?.id, 'gestante');
        expect(fila.chamarProximo()?.id, 'comum');
      },
    );

    test('80+ passa na frente de 60+ (prioridade legal comum)', () {
      fila.entrar(
        criarPaciente('idoso60', minuto: 0, prioridade: TipoPrioridade.legal),
      );
      fila.entrar(
        criarPaciente(
          'idoso80',
          minuto: 30,
          prioridade: TipoPrioridade.legal80,
        ),
      );

      expect(fila.chamarProximo()?.id, 'idoso80');
      expect(fila.chamarProximo()?.id, 'idoso60');
    });

    test('empate de prioridade é resolvido pela ordem de chegada', () {
      fila.entrar(
        criarPaciente('B', minuto: 20, prioridade: TipoPrioridade.legal),
      );
      fila.entrar(
        criarPaciente('A', minuto: 10, prioridade: TipoPrioridade.legal),
      );

      expect(fila.chamarProximo()?.id, 'A');
      expect(fila.chamarProximo()?.id, 'B');
    });

    test('ordem completa: 80+, depois legal, depois sem prioridade', () {
      fila.entrar(criarPaciente('comum1', minuto: 0));
      fila.entrar(
        criarPaciente('legal1', minuto: 5, prioridade: TipoPrioridade.legal),
      );
      fila.entrar(
        criarPaciente('80a', minuto: 10, prioridade: TipoPrioridade.legal80),
      );
      fila.entrar(criarPaciente('comum2', minuto: 15));
      fila.entrar(
        criarPaciente('legal2', minuto: 20, prioridade: TipoPrioridade.legal),
      );

      final ids = fila.pacientesEmOrdem.map((p) => p.id).toList();

      expect(ids, ['80a', 'legal1', 'legal2', 'comum1', 'comum2']);
    });

    test('quem tem prioridade chegando depois sobe de posição na fila', () {
      fila.entrar(criarPaciente('A', minuto: 0));
      fila.entrar(criarPaciente('B', minuto: 5));
      expect(fila.posicaoDe('B'), 2);

      fila.entrar(
        criarPaciente('C', minuto: 10, prioridade: TipoPrioridade.legal),
      );

      expect(fila.posicaoDe('C'), 1);
      expect(fila.posicaoDe('A'), 2);
      expect(fila.posicaoDe('B'), 3);
    });
  });

  group('Trocar a regra muda a ordem (padrão Strategy)', () {
    test('os mesmos pacientes saem em ordem diferente com outra regra', () {
      final comum = criarPaciente('comum', minuto: 0);
      final gestante = criarPaciente(
        'gestante',
        minuto: 30,
        prioridade: TipoPrioridade.legal,
      );

      // Duas filas iguais, com a MESMA classe Fila; só a regra é diferente.
      final porChegada = Fila(const RegraOrdemDeChegada());
      final porPrioridade = Fila(const RegraPrioridadeLegal());
      for (final fila in [porChegada, porPrioridade]) {
        fila.entrar(comum);
        fila.entrar(gestante);
      }

      expect(porChegada.chamarProximo()?.id, 'comum');
      expect(porPrioridade.chamarProximo()?.id, 'gestante');
    });

    test('uma regra nova qualquer funciona sem mudar a classe Fila', () {
      // Regra inventada só para o teste: ordem alfabética pelo id.
      final porId = Fila(_RegraAlfabetica());
      porId.entrar(criarPaciente('C', minuto: 0));
      porId.entrar(criarPaciente('A', minuto: 10));

      expect(porId.chamarProximo()?.id, 'A');
    });
  });
}

/// Regra de teste: quem tem o id "menor" em ordem alfabética vem antes.
class _RegraAlfabetica implements RegraOrdenacao {
  @override
  int comparar(Paciente a, Paciente b) => a.id.compareTo(b.id);
}
