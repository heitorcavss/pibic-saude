# app/ — onde o app mora

Esta pasta guarda **todo o código do aplicativo**. O que não é código (regras
para agentes, decisões, requisitos, pesquisa) fica fora dela, na raiz e em
`docs/`.

## O que há aqui

| Pasta | O que é | Estado |
|---|---|---|
| [`fila_core/`](fila_core/) | Núcleo da fila: as regras de quem entra e de quem é chamado. Dart puro, sem tela, sem internet, sem banco. | Implementado (regra de prioridade ainda é HIPÓTESE) |

## Como o app será dividido (visão geral)

1. **Telas (Flutter):** o que o paciente e o administrador veem. *Ainda não existe.*
2. **Núcleo da fila (`fila_core`):** as regras. As telas pedem ao servidor
   "chame o próximo", e o servidor usa o núcleo para dizer quem é.
3. **Servidor Dart:** roda o núcleo, lendo e gravando a fila no Supabase.
   *Decidido (ver `docs/adr/2026-11-24-servidor-dart-para-a-logica-da-fila.md`);
   hospedagem e framework ainda a definir pela equipe. Ainda não existe.*
4. **Backend e banco:** guardam a fila na nuvem, cuidam do login e do tempo
   real e enviam notificações. *Decidido: Supabase + FCM (ver
   `docs/adr/2026-11-17-backend-banco-push.md`).*

O servidor e as telas vão se conectar ao núcleo, em vez de o núcleo depender
deles. Por isso ele pôde ser feito primeiro.

## Regra de organização

Cada parte do app é uma subpasta própria de `app/`, com o seu `pubspec.yaml`.
Comandos (`dart pub get`, `dart analyze`, `dart test`) são rodados **dentro** da
subpasta da parte que se quer verificar. Exemplo para o núcleo:

```bash
cd app/fila_core
dart pub get
dart test
```
