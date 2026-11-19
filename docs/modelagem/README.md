# Modelagem

Diagramas do sistema, escritos em [Mermaid](https://mermaid.js.org/) (o GitHub
desenha direto; no IntelliJ, use um plugin de Mermaid).

## Regra desta pasta

**Só entra no diagrama o que já está decidido.** O que ainda é dúvida fica
**fora** do desenho, listado na seção "Fora deste diagrama" de cada arquivo e
nas "Pendências e dúvidas" do MEMORY.md. Não se desenha "a confirmar".

Todo arquivo abre com:

- **Status**: `Estável` ou `Provisório` (ver abaixo);
- **Fonte**: de onde vem cada elemento (ADR aceito, projeto oficial ou código);
- **Fora deste diagrama**: o que foi deixado de fora de propósito.

| Status | Significa |
|---|---|
| Estável | Vem de ADR aceito ou de código existente. Só muda se o ADR mudar. |
| Provisório | Vem do projeto oficial, mas depende de a visita à unidade confirmar o fluxo real. Revisar depois da análise das visitas. |

## Índice

| Arquivo | O que mostra | Status |
|---|---|---|
| [arquitetura-e-fluxo.md](arquitetura-e-fluxo.md) | Peças do sistema e o caminho de um check-in até a notificação | Estável |
| [estados-do-paciente.md](estados-do-paciente.md) | Por quais situações o paciente passa na fila | Provisório |

## Ainda não existem

Casos de uso, classes e sequência (cronograma: jan/2027). Eles esperam a análise
das visitas de campo e a resposta da orientadora sobre o escopo do UML (issue #13).
