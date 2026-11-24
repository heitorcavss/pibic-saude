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
2. **Núcleo da fila (`fila_core`):** as regras. As telas pedem "chame o
   próximo" e o núcleo responde quem é.
3. **Backend e banco:** guardam a fila na nuvem e enviam notificações.
   *Decidido: Supabase + FCM, sem servidor próprio (ver
   `docs/adr/2026-11-17-backend-banco-push.md`).*

As telas e o backend vão se conectar ao núcleo, em vez de o núcleo depender
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
