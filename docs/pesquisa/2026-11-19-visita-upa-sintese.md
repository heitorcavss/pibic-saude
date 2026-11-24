# Síntese da visita à UPA: 19/11/2026, tarde

> Síntese do relatório de observação, preenchido com o modelo `modelo-relatorio-visita-unidade.md` (issue #11).
> Segue a regra do modelo: no repositório vai só a síntese, sem dados pessoais. As folhas manuscritas ficam com a dupla.
> Pacientes aparecem só por código. As leituras duvidosas da letra foram conferidas pela dupla em 23/11/2026.

**Isto vale para 19/11/2026 (quinta-feira), turno da tarde, em uma UPA de urgência, durante cerca de 1 h 20 min de observação. Não generalizar.** Os números são hipóteses para confirmar em outras coletas.

## Resumo

Dois observadores acompanharam cerca de 1 h 20 min na recepção e na área externa de uma UPA de urgência, numa tarde de quinta-feira movimentada. A unidade tem 1 guichê, 1 sala de triagem e cerca de 3 consultórios.

**O que vimos**
1. **Fluxo em duas etapas, com fila única e mista.** O paciente passa pelo guichê (cadastro na hora), pela triagem (risco em pulseira, verde e amarelo vistos) e pela consulta. A mesma TV chama as duas etapas.
2. **Espera longa e desigual.** Até a triagem, de 2 a pelo menos 10 min. Depois da triagem, de 3 a 14 min em três casos e pelo menos 36 min em dois pacientes de pulseira verde (B1 e B2; em B2 a chamada não foi vista, e a espera passava de 41 min às 16:41). Nos 9 pacientes acompanhados, a espera mais longa ficou entre a triagem e a consulta.
3. **A unidade não informa quanto falta**, em nenhuma etapa.
4. **Não há senha.** A chamada é pelo nome completo e pelo consultório, por voz e TV. O nome fica exposto, e fora da sala a chamada quase não se ouve. Não vimos quem opera o painel.
5. **Sem resposta em 3 chamadas, é marcada falta.**
6. **O critério de ordem não ficou claro.** A anotou preferência na fila ligada ao risco (16:38: amarelo passando mal; verde) e B anotou "um pouco de tudo" (risco, prioridade legal, chegada).

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
| Estrutura vista | 1 guichê, 1 sala de triagem (classificação de risco), cerca de 3 consultórios (3 foi o maior número citado nas chamadas) |

## 2. Contagem a cada ~10 min

Os totais são de pessoas na recepção e na área externa, incluindo pacientes, acompanhantes e a equipe (recepção e triagem). O guichê era sempre 1, por isso a coluna não foi preenchida.

| Hora | Pessoas na área | Recepcionistas |
|---|---|---|
| 16:15 | 26 | 1 |
| 16:30 | 22 | 1 |
| 16:40 | 22 | 1 |
| 16:51 | 22 | 1 |
| 17:00 | 17 | 1 |
| 17:10 | 15 | 1 |
| 17:20 | 13 | 1 |

A contagem caiu de 26 para 13 pessoas em cerca de 65 min. As chegadas no período não foram contadas, então não dá para dizer se a fila caiu por atender mais rápido ou por chegar menos gente.

## 3. Pacientes acompanhados

Fatos anotados, em ordem por código. A cor de risco só é conhecida depois da triagem.

| Código | O que foi visto |
|---|---|
| A1 | Chegou à recepção às 16:21 passando mal. Triagem às 16:28, com cerca de 6 min. Consulta às 16:48. Foi classificado como amarelo. Às 16:44 reclamou da demora (registro de B). |
| A2 | Amarelo. Foi à triagem às 16:24 e voltou às 16:27 (~3 min). Foi embora às 17:15. |
| A3 | Registrado às 16:48 esperando na recepção, com o recepcionista fora do guichê. Foi à triagem às 16:58. |
| A4 e A5 | Dois pacientes verdes entraram na consulta às 16:48 e 16:49. Um saiu às 16:55 (cerca de 6 min de consulta). |
| A6 | Idosa com problema de coluna. Recepção às 17:09, triagem às 17:11, saída da triagem às 17:15 e consulta às 17:26. |
| B1 | Pulseira verde. Observada na triagem a partir do registro das 16:19: triagem de 7 a 8 min, e pacientes reclamaram de como demorou. Às 16:55 esperava havia 36 min depois da triagem. Chamada à consulta às 17:03. |
| B2 e B3 | B2, paciente de pulseira verde, e B3, o acompanhante. Já estavam na espera pós-triagem quando a observação começou. Segundo a anotação de B, às 16:41 somavam 41 min de espera pela consulta (29 min na primeira anotação e mais 12 min até 16:41); o tempo real é maior, porque já estavam esperando quando os observadores chegaram. A chamada à consulta não foi vista. |
| B4 | Chegou às 16:57, triagem às 17:03 e 17:08, consulta às 17:11. Quando os observadores foram embora, às 17:35, ele ainda não tinha voltado da consulta. |

Tempos por etapa, só dos casos acima:

| Etapa | Tempo observado |
|---|---|
| Cadastro na recepção | ~2 a 3 min |
| Espera até a triagem | 2 min (A6), 6 min (B4), 7 min (A1), pelo menos ~10 min (A3) |
| Triagem | ~3 min (A2), 4 min (A6), 5 min (B4), ~6 min (A1), 7 a 8 min (B1) |
| Triagem até a consulta | 3 min (B4), ~11 min (A6), ~14 min (A1), pelo menos 36 min (B1), pelo menos 41 min (B2, sem chamada vista) |
| Consulta | ~6 min (A4 e A5, completa); pelo menos 24 min (B4, ainda em consulta às 17:35) |

Outro fato anotado por A: às 16:38, "há preferência na fila", ligada às cores verde e amarelo (amarelo: passando mal).

Impressões registradas (não são fatos):
- O observador B anotou "triagem morosa, só um profissional lá dentro, só uma sala" e "não há filas na recepção; o gargalo maior são as esperas de triagem/consulta".
- O observador B anotou que o tempo de espera deve considerar "risco + prioridade + hora de chegada".

## 4. Conferência final

| Item | O que foi visto |
|---|---|
| 1. Entrada | Vai direto ao guichê e diz nome ou nascimento, ou entrega documento, e descreve o que sente. O recepcionista coleta dados e necessidade e coloca o paciente na fila, que aparece no painel. Não há senha. |
| 2. Quem é atendido primeiro | "Um pouco de tudo?" (risco, prioridade, chegada). Não confirmado. A anotou preferência na fila ligada ao risco às 16:38. |
| 3. Recepção | 1 guichê. Cadastro no sistema, na hora, e envio ao painel. Leva 2 a 3 min. |
| 4. Triagem | Anexa à recepção. Há cores de risco; só vimos verde e amarelo. |
| 5. Chamada | Voz, painel, nome completo e consultório. Fora da sala é muito difícil de ouvir. Sem resposta em 3 chamadas, é marcada falta. A TV mostra um histórico com horário, nome e etapa (triagem ou consulta). Não observamos quem avança a fila (recepção, triagem ou médico). |
| 6. Prioridades legais | Só vimos a possibilidade no panfleto. Registrados: idosos, criança de colo, pessoa com deficiência e gestante. Direito a acompanhante: idosos (>60), menores de 18 e mulheres em geral. |
| 7. Informam quanto falta | **Não.** |
| 8. Ferramentas | Computadores na recepção e na triagem. TV com som e imagem para chamar. Poucas pessoas no celular na espera, e a maioria do público era idosa (impressão). |
| 9. Problemas | Só reclamações sobre a demora (às 16:19, sobre a triagem de B1; às 16:44, de paciente amarelo). |
| 10. Espera | ~30 assentos, banheiro para 2 pessoas, ar-condicionado, pouco ruído. |

## 5. Depois da visita

### Fluxo em 5 linhas

1. O paciente vai direto ao único guichê, informa nome ou nascimento ou entrega documento, e descreve o que sente. O cadastro é feito na hora (~2 a 3 min).
2. O recepcionista coloca o paciente na fila, que aparece no painel.
3. Espera a triagem, de 2 a pelo menos 10 min nos casos com hora. Um profissional, na única sala, dá a cor do risco com pulseira (3 a 8 min).
4. Volta a esperar a consulta: de 3 a 14 min em três casos e pelo menos 36 min em dois pacientes de pulseira verde. A chamada é por nome e consultório, no painel e por voz. Sem resposta em 3 chamadas, é marcada falta.
5. Consulta, de ~6 min a mais de 24 min nos casos vistos, e na maioria das vezes o paciente só vai embora. Em nenhuma etapa a unidade informa quanto falta.

**Isto vale para 19/11/2026, tarde, UPA. Não generalizar.**

### Pontos de dor

| Ponto de dor | Horas do registro | Ideia de funcionalidade do app |
|---|---|---|
| Espera longa e desigual: de 2 a pelo menos 10 min até a triagem e de 3 a mais de 36 min entre a triagem e a consulta, com 1 sala de triagem e cerca de 3 consultórios. Pacientes reclamaram da triagem demorada (16:19) e da espera (16:44) | 16:19, 16:41, 16:44, 16:55, 17:03 | Mostrar posição e estimativa de espera em faixa |
| Nenhuma informação de quanto falta | 16:32, conferência 7 | Estimativa e etapa atual no app |
| Chamada quase inaudível na área externa | conferência 5 | Notificação "você foi chamado (consultório N)" |
| Nome completo exposto na TV | 16:27, 16:32 | Identificar o paciente no app por código, sem expor o nome |
| O paciente não vê o critério de ordem; o risco só aparece na pulseira | 16:35, 16:48 | Mostrar a etapa e a regra de ordem |
| Recepcionista sai do guichê e o paciente que chega fica esperando | 16:48 | Check-in no app antes de chegar ao guichê |

A etapa que limita o fluxo (gargalo) é indicada, mas **não está confirmada**. As esperas mais longas (B1 e B2, ambos de pulseira verde) foram depois da triagem, e antes dela os casos com hora ficaram entre 2 e cerca de 10 min. B anotou também "triagem morosa" (um profissional, uma sala), e a duração de consulta variou de ~6 min a mais de 24 min. A amostra é pequena: são dois pacientes com espera longa.

### Dúvidas que ficaram

| Dúvida do MEMORY.md | O que a visita mostrou | Esclareceu? |
|---|---|---|
| Quem atribui o fator de risco? | A triagem, um profissional na sala anexa (16:19, 16:35). A categoria profissional não foi vista. | sim |
| Qual escala de risco? | Cores em pulseira, verde e amarelo vistos. Vermelho é provável, mas não observado. Protocolo oficial não confirmado. | parcial |
| Como estimar a espera sem histórico? | A unidade não informa nada hoje. Os tempos acima servem só como ordem de grandeza. | parcial |
| Como o paciente se identifica? | Nome ou nascimento, ou documento, e relato do que sente, no guichê (17:10). | sim |
| Como o app conhece o local? | Fila única mista, com o consultório dito na chamada (16:27, conferência 5). | parcial |

Outras dúvidas. **Não há acesso à unidade para perguntar**, então cada uma ganhou uma premissa (seção abaixo) ou vai à orientadora:
1. Qual é o critério real de ordem na triagem e na consulta (risco, prioridade legal, chegada)? Nos casos vistos, a ordem da triagem não parece ser só a de chegada, e A anotou preferência na fila ligada ao risco (16:38).
2. Qual é o protocolo de classificação de risco, quem é o profissional da triagem e existem outras cores?
3. A falta é definitiva? O paciente pode voltar?
4. Qual o intervalo entre as 3 chamadas?
5. Consultas agendadas interferem na demanda espontânea? Não observamos nenhuma.
6. Quem autoriza o app e a exibição do nome? Registrado como "o próprio cliente"; confirmar quem é.
7. Quem opera o painel e avança a fila: recepção, triagem ou médico?

### Premissas assumidas

A dupla não tem como perguntar à unidade. Por isso, o que a visita não respondeu fica como **premissa**: uma suposição declarada, que o protótipo usa e que **não foi validada com a unidade**. Onde der, o app deixa a premissa configurável para não depender dela. As fontes de pesquisa abaixo foram conferidas nos textos originais em 23/11/2026. Ficaram sem conferir: o manual da UPA 24h do Ministério da Saúde (só um trecho foi lido), o Estatuto da Pessoa Idosa além do art. 39 e a fonte oficial do COFEN (usei o Normas Brasil).

| # | Premissa | Base | Como o app se protege |
|---|---|---|---|
| P1 | A escala de risco segue o Protocolo de Manchester (ou uma adaptação), com 5 cores: vermelho, laranja, amarelo, verde e azul. Vimos só verde e amarelo. | Pesquisa: uma UPA 24h de Belo Horizonte usa o Sistema de Triagem de Manchester ([CBCEnf](https://inscricoes-cbcenf.cofen.gov.br/anais/21/30416/trabalhoresumodownload)) e a Prefeitura do Rio usa um "Manchester adaptado" ([carioca.rio](https://carioca.rio/?p=71246)). A norma do COFEN fala em "protocolo adotado pela instituição" ([Resolução 661/2021](https://www.normasbrasil.com.br/norma/resolucao-661-2021_410743.html)), então não há protocolo nacional único. Não confirmado na unidade. | A escala é uma lista configurável, sem cor fixa no código. |
| P2 | Os prazos máximos por cor não são fixos, e as fontes divergem. | Pesquisa: Rio de Janeiro, laranja 15, amarelo 30 e verde 60 min, e azul 24 h ([carioca.rio](https://carioca.rio/?p=71246)); reportagem do Correio Braziliense, laranja 10, amarelo 60, verde 120 e azul 240 min, sem fonte oficial ([Correio Braziliense](https://www.correiobraziliense.com.br/aqui/?p=32615)). A [Resolução CFM 2079/2014](https://www.normasbrasil.com.br/norma/resolucao-2079-2014_274743.html), que vale para UPAs, só fixa 120 min no máximo para o acesso ao médico na menor urgência. | O app não usa prazo por cor na primeira versão. |
| P3 | A ordem de atendimento combina risco, prioridade legal e chegada, mas a combinação real é desconhecida. O protótipo usa uma regra padrão **marcada como hipótese**, a decidir com a orientadora. | Observado: "um pouco de tudo?" (conferência 2) e preferência na fila ligada ao risco (A, 16:38). Pesquisa: a literatura diverge entre risco primeiro e prioridade legal do 80+ ([Fiocruz](https://www.cadernos.prodisa.fiocruz.br/index.php/cadernos/article/download/462/522)). | A regra de ordenação é trocável (`RegraOrdenacao`, RF14). |
| P4 | O profissional da triagem é um enfermeiro. | Pesquisa: no âmbito da equipe de enfermagem, a classificação de risco é privativa do enfermeiro ([Resolução COFEN 661/2021](https://www.normasbrasil.com.br/norma/resolucao-661-2021_410743.html), vigente, que revogou a [423/2012](https://www.normasbrasil.com.br/norma/resolucao-423-2012_239586.html)). A 661 fixa 4 min em média por classificação, e a triagem que vimos levou de 3 a 8 min. | Os requisitos dizem "profissional da triagem", sem categoria. |
| P5 | Quem não responde em 3 chamadas é marcado como falta e a fila anda, sem voltar à posição. | Observado: sem resposta em 3 chamadas, é marcada falta (conferência 5). Que a fila ande sem o paciente voltar à posição é suposição. O intervalo entre as chamadas é desconhecido. | O número de chamadas é configurável. |
| P6 | A UPA atende só demanda espontânea, sem consultas agendadas. | Conhecimento prévio da dupla: a UPA só atende por chegada. Nenhuma consulta agendada foi vista. | Consulta agendada fica fora do escopo. |
| P7 | A unidade (o "cliente") autoriza o app e a exibição do nome. Quem é, concretamente, fica com a orientadora (issue #19). | Relato da dupla. | O protótipo usa só dados fictícios e um código no lugar do nome. |

Para fechar P1, P3 e P5 sem perguntar, caberia uma segunda observação só de observar: a ordem das chamadas contra a hora de chegada e a cor, o intervalo entre as 3 chamadas e as cores que aparecem. Isso depende de a unidade permitir nova visita.

### Limitações

- Um dia (quinta), um turno (tarde) e cerca de 1 h 20 min de observação.
- Só áreas públicas: não vimos o interior da triagem nem dos consultórios.
- 9 pacientes acompanhados (mais um acompanhante), poucos com a jornada completa. Os tempos são ordem de grandeza, não média.
- O tempo de B2 é um piso: já estava na espera quando a observação começou e a chamada à consulta não foi vista.
- Duração de consulta: uma amostra completa (~6 min) e uma incompleta (pelo menos 24 min, ainda em curso quando fomos embora).
- Só vimos risco verde e amarelo. A cor só é conhecida depois da triagem, então a classificação dos pacientes é posterior à sua espera.
- Amarelo foi lido como nível de gravidade maior, não como o que o paciente sentia.
- Os horários foram anotados à mão, durante o movimento, e têm margem de erro.
- A contagem não foi exatamente a cada 10 min e não registrou chegadas. Foi feita pelos dois observadores, cada um em parte, e inclui pacientes, acompanhantes e equipe. O guichê não variou (sempre 1).
- Sem acesso à unidade para perguntas: o que a observação não mostrou virou premissa (P1 a P7), não resposta.
- É uma UPA de urgência. Em uma UBS o fluxo pode ser diferente.
- Os códigos A1 a A6 e B1 a B4 são de cada observador. Os números não repetem entre as folhas, mas a correspondência com a ordem original foi reconstruída na síntese.
