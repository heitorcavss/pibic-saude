/// Biblioteca do núcleo da fila.
///
/// Este arquivo só "reexporta" o que é público: quem usa o pacote escreve
/// `import 'package:fila_core/fila_core.dart';` e já enxerga todas as classes
/// abaixo, sem precisar saber em qual arquivo cada uma está.
library;

export 'src/fila.dart';
export 'src/paciente.dart';
export 'src/regra_ordenacao.dart';
export 'src/regra_prioridade_legal.dart';
