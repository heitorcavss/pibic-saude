# PIBIC — Transformação Digital em Saúde

Aplicativo móvel para gestão de filas de triagem e atendimento em uma
unidade pública de saúde de Inhumas-GO. Projeto de Iniciação Científica
(PIBIC/IFG) "Gestão em Saúde Pública: Transformação Digital para a
Otimização de Atendimento".

## Perfis de usuário
- **Paciente:** faz o check-in e acompanha a fila.
- **Administrador:** profissional da triagem ou recepção; confirma no
  sistema cada etapa concluída, o que faz a fila avançar.

## Funcionalidades previstas (backlog inicial)
1. **Check-in digital:** o paciente registra a chegada pelo app, no lugar
   da retirada de senhas e dos registros manuais.
2. **Monitoramento da fila, em duas etapas:**
   - Triagem: ordem de chegada.
   - Atendimento: ordem por fator de risco; risco igual, ordem de chegada.
   - Em ambas, o app mostra a posição e uma estimativa de tempo até o
     chamado (média dos atendimentos anteriores e pacientes à frente;
     na segunda etapa, também o fator de risco).
3. **Notificações push** quando a vez estiver próxima, indicando a etapa e
   o local de atendimento, mesmo com o app fechado.

Limitação conhecida: as notificações dependem de internet (rede da
unidade ou dados móveis do paciente).

## Equipe
Miguel e Heitor (Eng. de Software, IFG). Orientação: Profa. Celyce Lula.

## Como rodar
O app mobile usa Flutter (ver docs/adr/). O app ainda não existe na `main`;
um spike descartável está na branch `spike/flutter-basico`.

Pré-requisitos para desenvolver:
1. Git.
2. Flutter SDK (canal stable) no PATH; confira com `flutter doctor`.
3. Um editor com o plugin Dart/Flutter (por exemplo, IntelliJ IDEA).
4. Para Android: Android Studio (SDK e emulador).

Comandos do dia a dia: ver a seção "Comandos" do AGENTS.md.

## Organização
- AGENTS.md: regras para agentes de IA.
- MEMORY.md: estado atual do projeto.
- docs/adr/: decisões de arquitetura.
- docs/requisitos/, docs/modelagem/: requisitos e diagramas.
