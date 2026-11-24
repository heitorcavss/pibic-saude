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
| Provisório | Vem da visita à unidade (uma tarde, uma UPA) e do projeto oficial, sem validação com a unidade. Revisar se uma nova observação ou a orientadora mudarem o fluxo. |

## Índice

| Arquivo | O que mostra | Status |
|---|---|---|
| [arquitetura-e-fluxo.md](arquitetura-e-fluxo.md) | Peças do sistema e o caminho de um check-in até a notificação | Estável |
| [estados-do-paciente.md](estados-do-paciente.md) | Por quais situações o paciente passa, da chegada à consulta | Provisório |

## Ainda não existem

Casos de uso, classes e sequência (cronograma: jan/2027). A síntese da visita já
existe (`docs/pesquisa/2026-11-19-visita-upa-sintese.md`); falta a resposta da
orientadora sobre o escopo do UML (issue #13) e as decisões que os requisitos
ainda listam como abertas.
