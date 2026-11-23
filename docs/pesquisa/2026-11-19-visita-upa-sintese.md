# Síntese da visita à UPA: 19/11/2026, tarde

> Síntese do relatório de observação, preenchido com o modelo `modelo-relatorio-visita-unidade.md` (issue #11).
> Segue a regra do modelo: no repositório vai só a síntese, sem dados pessoais. As folhas manuscritas ficam com a dupla.
> Pacientes aparecem só por código. As leituras duvidosas da letra foram conferidas pela dupla em 23/11/2026.

**Isto vale para 19/11/2026 (quinta-feira), turno da tarde, em uma UPA de urgência, durante cerca de 1 h 20 min de observação. Não generalizar.** Os números são hipóteses para confirmar em outras coletas.

## Resumo

Dois observadores acompanharam cerca de 1 h 20 min na recepção e na área externa de uma UPA de urgência, numa tarde de quinta-feira movimentada. A unidade tem 1 guichê, 1 sala de triagem e 3 consultórios.

**O que vimos**
1. **Fluxo em duas etapas, com fila única e mista.** O paciente passa pelo guichê (cadastro na hora), pela triagem (risco em pulseira, verde e amarelo vistos) e pela consulta. A mesma TV chama as duas etapas.
2. **Espera longa e desigual.** De 2 a 41 min até a triagem e de 3 a ~40 min da triagem à consulta, em cerca de 8 pacientes. Não deu para dizer qual etapa limita o fluxo.
3. **A unidade não informa quanto falta**, em nenhuma etapa.
4. **Não há senha.** A chamada é por nome e consultório, por voz e TV, feita pelo recepcionista. O nome fica exposto, e fora da sala a chamada quase não se ouve.
5. **Sem resposta em 3 chamadas, é marcada falta e a fila anda.**
6. **O critério real de ordem não apareceu.** Só a impressão "um pouco de tudo" (risco, prioridade legal, chegada).

**Como usar esta síntese**
- Vale só para essa tarde, com amostra pequena. Os tempos são ordem de grandeza.
- A dupla não tem acesso à unidade para perguntar. O que a observação não mostrou virou **premissa (P1 a P7)**, não resposta.
- Os pontos de dor e as ideias de funcionalidade (seção 5) alimentam os requisitos, no PR #18.

## 1. Cabeçalho

| Campo | Preenchimento |
|---|---|
| Data, dia e turno | 19/11/2026, quinta-feira, vespertino |
| Hora de chegada e de saída | chegada às 16:15; saída às 17:35 |
| Unidade e tipo | UPA (urgência), não é UBS |
| Observadores | A: Heitor; B: Miguel. Os dois na recepção/sala de espera |
| Condições do dia | bastante movimentado |
| Critério da contagem | recepção mais a área externa coberta |
| Estrutura vista | 1 guichê, 1 sala de triagem (classificação de risco), 3 consultórios |

## 2. Contagem a cada ~10 min

"Np e 1r" na folha quer dizer N pacientes e 1 recepcionista. O guichê era sempre 1, por isso a coluna não foi preenchida.

| Hora | Pacientes aguardando | Recepcionistas | Nota |
|---|---|---|---|
| 16:15 | 26 | 1 | |
| 16:30 | 21 | 1 | |
| 16:40 | 21 | 1 | anotado "22p (1 recepcionista)"; o total inclui a recepcionista |
| 16:51 | 21 | 1 | |
| 17:00 | 16 | 1 | anotado "17, 1 recepcionista"; o total inclui a recepcionista |
| 17:10 | 14 | 1 | |
| 17:20 | 12 | 1 | |

A contagem caiu de 26 para 12 pacientes em cerca de 65 min. As chegadas no período não foram contadas, então não dá para dizer se a fila caiu por atender mais rápido ou por chegar menos gente.

## 3. Pacientes acompanhados

Fatos anotados, em ordem por código. A cor de risco só é conhecida depois da triagem.

| Código | O que foi visto |
|---|---|
| A1 | Chegou à recepção às 16:21. Triagem às 16:28, com cerca de 6 min. Consulta às 16:48. Foi classificado como amarelo. Às 16:44 reclamou da demora (registro de B). |
| A2 | Amarelo. Foi à triagem às 16:24 e voltou às 16:27 (~3 min). Foi embora às 17:15. |
| A3 | Chegou às 16:48, esperou um tempo com o recepcionista fora do guichê e foi à triagem às 16:58. |
| A4 e A5 | Dois pacientes verdes entraram na consulta às 16:48 e 16:49. Um saiu às 16:55 (cerca de 6 min de consulta). |
| A6 | Idosa com problema de coluna. Recepção às 17:09, triagem às 17:11, saída da triagem às 17:15 e consulta às 17:26. |
| B1 | Observado já na triagem às 16:19, onde ficou de 2 a 5 min. Às 16:55 esperava havia 36 min. Foi chamado à consulta às 17:03 (44 min desde 16:19). |
| B2 e B3 | Paciente de pulseira verde com acompanhante. Já estavam esperando quando a observação começou. Às 16:41 somavam 41 min de espera (29 min na primeira anotação e mais 12 min até 16:41). |
| B4 | Chegou às 16:57, triagem às 17:03 e 17:08, consulta às 17:11. Quando os observadores foram embora, às 17:35, ele ainda não tinha voltado da consulta. |

Tempos por etapa, só dos casos acima:

| Etapa | Tempo observado |
|---|---|
| Cadastro na recepção | ~2 a 3 min |
| Espera até a triagem | 2 min (A6), 6 min (B4), 7 min (A1), ~10 min (A3), 41 min (B2 e B3) |
| Triagem | 2 a 6 min |
| Triagem até a consulta | 3 min (B4), ~11 min (A6), ~14 min (A1), ~40 min (B1) |
| Consulta | ~6 min (A4 e A5, completa); pelo menos 24 min (B4, ainda em consulta às 17:35) |

Impressões registradas (não são fatos):
- O observador B anotou "triagem morosa, só um profissional lá dentro, só uma sala" e "não há filas na recepção; o gargalo maior são as esperas de triagem/consulta".
- O observador B anotou que o tempo deveria ser "risco + prioridade + hora de chegada".

## 4. Conferência final

| Item | O que foi visto |
|---|---|
| 1. Entrada | Vai direto ao guichê. O recepcionista coleta os dados e coloca o paciente na fila, que aparece no painel. Não há senha. |
| 2. Quem é atendido primeiro | "Um pouco de tudo?" (risco, prioridade, chegada). Não confirmado. |
| 3. Recepção | 1 guichê. Cadastro no sistema, na hora, e envio ao painel. Leva 2 a 3 min. |
| 4. Triagem | Anexa à recepção. Há cores de risco; só vimos verde e amarelo. |
| 5. Chamada | Voz, painel e nome, com o consultório ("NOME – CONSULTÓRIO N"). Fora da sala é muito difícil de ouvir. O recepcionista chama pelo painel. Sem resposta em 3 chamadas, é marcada falta e a fila anda. A TV mostra um histórico com horário, nome e etapa (triagem ou consulta). |
| 6. Prioridades legais | Só vimos a possibilidade no panfleto. Registrados: idosos, criança de colo, pessoa com deficiência e gestante. Direito a acompanhante: idosos (>60), menores de 18 e mulheres em geral. |
| 7. Informam quanto falta | **Não.** |
| 8. Ferramentas | Computadores na recepção e na triagem. TV com som e imagem para chamar. Poucas pessoas no celular na espera, mais idosos. |
| 9. Problemas | Só reclamações sobre a demora (observado às 16:44, de paciente amarelo). |
| 10. Espera | ~30 assentos, banheiro para 2 pessoas, ar-condicionado, pouco ruído. |

## 5. Depois da visita

### Fluxo em 5 linhas

1. O paciente vai direto ao único guichê. O cadastro é feito na hora, com documento ou nome e nascimento (~2 a 3 min).
2. O recepcionista coloca o paciente na fila, que aparece no painel.
3. Espera a triagem: de 2 a 10 min na maioria dos casos acompanhados, e 41 min em dois pacientes de risco verde. Um profissional, na única sala, dá a cor do risco com pulseira (2 a 6 min).
4. Volta a esperar a consulta: de 3 a 14 min em quatro casos e ~40 min em outro. O recepcionista chama pelo painel, por nome e consultório, e sem resposta em 3 chamadas a fila anda.
5. Consulta, de ~6 min a mais de 24 min nos casos vistos, e na maioria das vezes o paciente só vai embora. Em nenhuma etapa a unidade informa quanto falta.

**Isto vale para 19/11/2026, tarde, UPA. Não generalizar.**

### Pontos de dor

| Ponto de dor | Horas do registro | Ideia de funcionalidade do app |
|---|---|---|
| Espera longa e desigual: de 2 a 41 min até a triagem e de 3 a ~40 min entre a triagem e a consulta, com 1 sala de triagem e 3 consultórios | 16:19, 16:41, 16:55, 17:03 | Mostrar posição e estimativa de espera em faixa |
| Nenhuma informação de quanto falta | 16:32, conferência 7 | Estimativa e etapa atual no app |
| Chamada quase inaudível na área externa | conferência 5 | Notificação "você foi chamado (consultório N)" |
| Nome completo exposto na TV | 16:27, 16:32 | Identificar o paciente no app por código, sem expor o nome |
| O paciente não vê o critério de ordem; o risco só aparece na pulseira | 16:35, 16:48 | Mostrar a etapa e a regra de ordem |
| Recepcionista sai do guichê e o paciente que chega fica esperando | 16:48 | Check-in no app antes de chegar ao guichê |

A etapa que limita o fluxo (gargalo) **não está determinada**. Houve espera longa nas duas etapas (41 min antes da triagem em B2 e B3, ~40 min depois dela em B1), e a duração de consulta variou de ~6 min a mais de 24 min. O próprio registro cita "triagem/consulta".

### Dúvidas que ficaram

| Dúvida do MEMORY.md | O que a visita mostrou | Esclareceu? |
|---|---|---|
| Quem atribui o fator de risco? | A triagem, um profissional na sala anexa (16:19, 16:35). A categoria profissional não foi vista. | sim |
| Qual escala de risco? | Cores em pulseira, verde e amarelo vistos. Vermelho é provável, mas não observado. Protocolo oficial não confirmado. | parcial |
| Como estimar a espera sem histórico? | A unidade não informa nada hoje. Os tempos acima servem só como ordem de grandeza. | parcial |
| Como o paciente se identifica? | Documento ou nome e nascimento no guichê (17:10). | sim |
| Como o app conhece o local? | Fila única mista, com o consultório dito na chamada (16:27, conferência 5). | parcial |

Outras dúvidas. **Não há acesso à unidade para perguntar**, então cada uma ganhou uma premissa (seção abaixo) ou vai à orientadora:
1. Qual é o critério real de ordem na triagem e na consulta (risco, prioridade legal, chegada)? Nos casos vistos, a ordem da triagem não parece ser só a de chegada.
2. Qual é o protocolo de classificação de risco, quem é o profissional da triagem e existem outras cores?
3. A falta é definitiva? O paciente pode voltar?
4. Qual o intervalo entre as 3 chamadas?
5. Consultas agendadas interferem na demanda espontânea? Não observamos nenhuma.
6. Quem autoriza o app e a exibição do nome? Registrado como "o próprio cliente"; confirmar quem é.

### Premissas assumidas

A dupla não tem como perguntar à unidade. Por isso, o que a visita não respondeu fica como **premissa**: uma suposição declarada, que o protótipo usa e que **não foi validada com a unidade**. Onde der, o app deixa a premissa configurável para não depender dela. As fontes de pesquisa abaixo vêm de buscas na web e ainda precisam ser conferidas nos textos originais.

| # | Premissa | Base | Como o app se protege |
|---|---|---|---|
| P1 | A escala de risco é a do Protocolo de Manchester, com 5 cores: vermelho, laranja, amarelo, verde e azul. Vimos só verde e amarelo. | Pesquisa: a UPA 24h usa Manchester ([Cofen/CBCEnf](https://inscricoes-cbcenf.cofen.gov.br/anais/21/30416/trabalhoresumodownload)). Não confirmado na unidade. | A escala é uma lista configurável, sem cor fixa no código. |
| P2 | Os prazos máximos por cor não são fixos. As fontes divergem: Rio de Janeiro 15, 30 e 60 min para laranja, amarelo e verde ([carioca.rio](https://carioca.rio/?p=71246)); Manchester em geral 10, 60, 120 e 240 min. | Pesquisa; não há tabela oficial do Ministério da Saúde nos resultados. | O app não usa prazo por cor na primeira versão. |
| P3 | A ordem de atendimento combina risco, prioridade legal e chegada, mas a combinação real é desconhecida. O protótipo usa uma regra padrão **marcada como hipótese**, a decidir com a orientadora. | Observado: "um pouco de tudo?" (conferência 2). Pesquisa: a literatura diverge entre risco primeiro e prioridade legal do 80+ ([Fiocruz](https://www.cadernos.prodisa.fiocruz.br/index.php/cadernos/article/download/462/522)). | A regra de ordenação é trocável (`RegraOrdenacao`, RF14). |
| P4 | O profissional da triagem é um enfermeiro. | Pesquisa: a classificação de risco é privativa do enfermeiro ([Normas Brasil](https://www.normasbrasil.com.br/norma/resolucao-423-2012_239586.html), norma revogada pela Resolução COFEN 661/2021). | Os requisitos dizem "profissional da triagem", sem categoria. |
| P5 | Quem não responde em 3 chamadas é marcado como falta e a fila anda, sem voltar à posição. | Observado (conferência 5, e o relato da dupla). O intervalo entre as chamadas é desconhecido. | O número de chamadas é configurável. |
| P6 | A UPA atende só demanda espontânea, sem consultas agendadas. | Nenhuma consulta agendada foi vista. É coerente com uma UPA de urgência, mas não foi confirmado. | Consulta agendada fica fora do escopo. |
| P7 | A unidade (o "cliente") autoriza o app e a exibição do nome. Quem é, concretamente, fica com a orientadora (issue #19). | Relato da dupla. | O protótipo usa só dados fictícios e um código no lugar do nome. |

Para fechar P1, P3 e P5 sem perguntar, caberia uma segunda observação só de observar: a ordem das chamadas contra a hora de chegada e a cor, o intervalo entre as 3 chamadas e as cores que aparecem. Isso depende de a unidade permitir nova visita.

### Limitações

- Um dia (quinta), um turno (tarde) e cerca de 1 h 20 min de observação.
- Só áreas públicas: não vimos o interior da triagem nem dos consultórios.
- Cerca de 8 pacientes acompanhados, poucos com a jornada completa. Os tempos são ordem de grandeza, não média.
- Duração de consulta: uma amostra completa (~6 min) e uma incompleta (pelo menos 24 min, ainda em curso quando fomos embora).
- Só vimos risco verde e amarelo. A cor só é conhecida depois da triagem, então a classificação dos pacientes é posterior à sua espera.
- Amarelo foi lido como nível de gravidade maior, não como o que o paciente sentia.
- A contagem não foi exatamente a cada 10 min e não registrou chegadas. O guichê não variou (sempre 1).
- Sem acesso à unidade para perguntas: o que a observação não mostrou virou premissa (P1 a P7), não resposta.
- É uma UPA de urgência. Em uma UBS o fluxo pode ser diferente.
- Os códigos A1 a A6 e B1 a B4 são de cada observador. Os números não repetem entre as folhas, mas a correspondência com a ordem original foi reconstruída na síntese.
