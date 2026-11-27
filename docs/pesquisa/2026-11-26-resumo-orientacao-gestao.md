# Fila digital na unidade de saúde: panorama do projeto

> **Rascunho.** Primeira versão, formalizada em 26/11/2026 e ainda em revisão pela dupla: não está 100%. Cópia datada do documento compartilhado; enquanto durar a revisão, as edições são feitas lá e esta cópia é atualizada depois.

Data: 26/11/2026

## O problema e o objetivo

Quem chega a uma unidade pública de saúde de Inhumas-GO espera sem saber quanto falta nem em que ordem será chamado. O projeto propõe um aplicativo de celular que organiza a fila de triagem e de atendimento e mostra a cada paciente a sua posição e uma estimativa de tempo.

O projeto é uma pesquisa aplicada, exploratória e descritiva, de abordagem qualitativa, conduzida como estudo de caso. Parte da ideia de que filas longas e imprevisíveis refletem fragilidades de gestão, e de que a transformação digital pode dar mais transparência ao paciente e mais apoio à equipe. O desenvolvimento segue o Scrum adaptado, em ciclos (sprints) de cerca de um mês, sem papéis formais.

A equipe é formada por Miguel e Heitor, estudantes de Engenharia de Software do IFG, com orientação da Profa. Celyce Lula.

## Levantamento bibliográfico

O levantamento reuniu 40 artigos científicos em quatro eixos: transformação digital, inovação social, empreendedorismo social e inovação em saúde. Ele fundamenta o projeto e foi feito em quatro passos, com apoio de inteligência artificial (IA) e decisão dos alunos em cada etapa.

1. **Busca exploratória (início de setembro).** Seis buscas no Google Acadêmico resultaram em 12 artigos de base e num primeiro relatório, de 3 de setembro.
2. **Vocabulário (setembro).** Um conjunto de 47 textos dos quatro temas foi lido com apoio de IA. Os alunos decidiram quais manter e revisaram a lista de termos extraídos. O resultado foram quatro listas de termos aprovados, uma por tema.
3. **Buscas na base Scopus (até 30 de setembro).** Com esses termos, a IA ajudou a escrever 8 fórmulas de busca, executou-as e os alunos revisaram os resultados. Cinco foram escolhidas e juntas somam cerca de 7,3 mil documentos. Duas foram descartadas (uma delas por repetir outra) e uma ficou como complemento.
4. **Seleção final (2 de outubro).** De cada busca por eixo foram escolhidos os 10 artigos mais aderentes ao tema, entre os 50 primeiros resultados. Os critérios foram: publicados entre 2020 e 2026, em português ou inglês, revisados por pares e com ligação direta com o tema. Dos 40 artigos, 36 já estão em PDF na pasta do projeto, e os 4 restantes aguardam acesso das editoras.

| Eixo | Documentos encontrados | Artigos selecionados |
|---|---|---|
| Transformação digital | 3.622 | 10 |
| Inovação social | 384 | 10 |
| Empreendedorismo social | 373 | 10 |
| Inovação em saúde | 834 | 10 |
| Saúde digital na atenção primária (lado aplicado) | 2.089 | 10 listados, textos a obter |

Na amostra analisada, nenhum documento apareceu em mais de um eixo, o que indica que cada busca traz um recorte diferente da literatura.

**O que a literatura oferece ao projeto**

- **Conceitos.** Transformação digital não é só comprar tecnologia: depende de governança e de decisões da organização (Ricciardi et al., 2019), e difere de simplesmente digitalizar um processo (Iyamu et al., 2021).
- **Empreendedorismo social em saúde.** Revisões mostram como iniciativas de valor social podem melhorar saúde e bem-estar (Roy et al., 2014; Godinho et al., 2023).
- **Riscos de implantação.** Inovações em serviços de saúde dependem de evidência de resultado, parcerias, pessoas que a defendam e do contexto (Barnett et al., 2011).
- **Evidência próxima do app.** Em três pronto-atendimentos de Xangai, 7.330 de 8.532 pacientes usaram o autorregistro pelo celular, e a espera antes da triagem caiu de 4,4 para 2,9 minutos em comparação com quiosques (Wang et al., 2024). Em dois hospitais da Tailândia, um sistema móvel de acompanhamento reduziu as perguntas dos pacientes à equipe em 83,3% (Vorakulpipat et al., 2019).

Esses resultados vêm de outros países e contextos e não devem ser transferidos automaticamente para a unidade estudada. A literatura sugere medir, na avaliação do projeto: tempo médio de espera, proporção de usuários que conclui o check-in, dúvidas dirigidas à equipe, qualidade da informação em tempo real e percepção de pacientes e profissionais.

## O que a visita mostrou

Em 19 de novembro de 2026, à tarde, os dois alunos observaram por cerca de 1 h 20 min a recepção e a sala de espera de uma UPA (unidade de pronto atendimento, de urgência), sem conversar com a equipe e sem coletar dados pessoais. A unidade tem 1 guichê, 1 sala de triagem e cerca de 3 consultórios. **Os resultados valem para essa tarde e para 9 pacientes acompanhados; são ordem de grandeza, não média.** Detalhes em [2026-11-19-visita-upa-sintese.md](2026-11-19-visita-upa-sintese.md).

1. **O atendimento tem duas etapas.** O paciente passa pelo guichê (cadastro na hora, em 2 a 3 minutos), pela triagem, onde recebe uma pulseira colorida de risco (vimos verde e amarela), e depois pela consulta. A mesma chamada serve às duas etapas.
2. **A espera é longa e desigual.** A espera mais longa ficou entre a triagem e a consulta, com dois pacientes de pulseira verde esperando pelo menos 36 minutos.
3. **Ninguém informa quanto falta.** Não há senha. O paciente é chamado pelo nome completo e pelo consultório, por voz e TV. O nome fica exposto e, fora da sala, a chamada quase não se ouve. Sem resposta a três chamadas, o paciente é marcado como falta.
4. **A ordem de atendimento não ficou clara.** Houve preferência ligada ao risco e a impressão de que se considera "um pouco de tudo": risco, prioridade legal e chegada.

| Etapa | Tempo observado |
|---|---|
| Espera até a triagem | 2 a pelo menos 10 min |
| Triagem | 3 a 8 min |
| Espera entre triagem e consulta | 3 a 14 min em três casos; pelo menos 36 min em dois |
| Consulta | cerca de 6 min a mais de 24 min |

Como a dupla não tem acesso à unidade para perguntar, tudo o que a observação não mostrou virou **premissa**: uma suposição declarada, usada no protótipo e ainda não validada. São sete, e as que pedem parecer estão na seção de dúvidas.

## Como o app vai funcionar

O app tem três perfis: o **paciente**, que faz o check-in e acompanha a fila; a **equipe da unidade**, que vê a fila, chama o próximo, registra o risco ao fim da triagem e marca a falta; e o **administrador**, que configura consultórios e regras. Quem na unidade exercerá o papel da equipe ainda é desconhecido, porque a visita não mostrou quem opera o painel.

| Situação | Hoje na unidade | Com o app |
|---|---|---|
| Entrar na fila | Cadastro no guichê, em 2 a 3 min, sem senha | Check-in pelo celular ao chegar; o paciente recebe um código de atendimento anônimo |
| Saber onde está | Sem informação | Vê a etapa (aguardando triagem ou consulta) e a posição na fila |
| Saber quanto falta | Ninguém informa | Estimativa em faixa (por exemplo, 20 a 30 min), calculada pela média dos atendimentos anteriores e pelos pacientes à frente |
| Ser chamado | Voz e TV, com nome completo; quase não se ouve fora da sala | Aviso no celular quando a vez estiver próxima e quando for chamado, com o consultório, mesmo com o app fechado |
| Privacidade | O nome completo aparece na TV | Chamada pelo código, sem o nome (proposta nossa, muda o que a unidade faz hoje) |
| Ordem de atendimento | Critério não confirmado | Regra de trabalho, só para testar: triagem por ordem de chegada e consulta por risco, com empate por chegada. A ordem real segue em aberto |

O paciente também poderá informar uma condição que dá prioridade legal, como ser idoso, gestante ou pessoa com deficiência. Como essa prioridade se combina com o risco é uma das dúvidas abaixo.

**Limites já assumidos.** O app complementa o painel e a recepção, que continuam existindo para quem não usa celular; na visita, a maioria do público era idosa e poucos usavam o aparelho. As notificações dependem de internet. O protótipo usa apenas dados fictícios e não será lançado para pacientes.

## Em que ponto o projeto está

O projeto está na fase de requisitos e modelagem, e parte do código já foi adiantada. As datas vêm do cronograma do projeto.

| Etapa | Cronograma | Situação em 26/11/2026 |
|---|---|---|
| Levantamento bibliográfico | set–out/2026 | Concluído: 40 artigos selecionados |
| Visita à unidade | nov/2026 | Primeira visita feita em 19/11; síntese pronta |
| Requisitos | nov–dez/2026 | Rascunho pronto (27 funcionais, 10 não funcionais, 7 premissas), a validar |
| Escolha das tecnologias | dez/2026–fev/2027 | Decidida; falta escolher onde o servidor será hospedado |
| Modelagem | dez/2026–fev/2027 | Arquitetura, fluxo e estados do paciente desenhados; diagramas UML formais previstos para jan/2027 |
| Núcleo da fila (regras em código) | adiantado | Pronto e testado; a regra de ordem é hipótese |
| Telas do app | mar/2027 em diante | Não iniciadas |
| Sprints 1 a 4: check-in, monitoramento da fila, notificações, integração e testes | mar–ago/2027 | Não iniciados |

As escolhas de tecnologia e a divisão da fila em duas etapas foram registradas em decisões de arquitetura que a dupla já aprovou; elas aguardam a revisão final no repositório do projeto.

## Próximos passos

1. Receber o parecer das orientações e as respostas às dúvidas abaixo.
2. Definir a regra de ordem do protótipo e fechar as premissas que a visita não respondeu.
3. Fazer uma segunda observação na unidade, se ela permitir: a ordem real das chamadas, o intervalo entre as três chamadas e as cores de risco usadas.
4. Concluir a modelagem, incluindo os diagramas UML previstos para jan/2027.
5. Escolher onde o servidor da fila será hospedado.
6. Começar o Sprint 1 (check-in digital) em mar/2027.

## Dúvidas em aberto

São dez dúvidas de gestão, processo, pesquisa e avaliação. Cada uma diz o que destrava e com o que seguimos se não houver resposta, para o trabalho não parar.

| # | Dúvida | O que destrava | Se não houver resposta |
|---|---|---|---|
| 1 | Na unidade, o risco clínico vem antes da prioridade legal (idosos, gestantes, pessoas com deficiência) ou é o contrário? Existe um critério oficial para a ordem da triagem e da consulta? | A regra de ordem do app (premissa 3) | Chegada na triagem e risco na consulta, só como regra de trabalho para testar e fácil de trocar |
| 2 | Quem, na unidade ou na gestão municipal, pode autorizar uma segunda observação e confirmar pontos que não vimos: a escala de risco usada (premissa 1), quem faz a triagem (4), o que ocorre após a falta e o intervalo entre as três chamadas (5), e se há consultas agendadas (6)? | Fechar as premissas e refinar as estimativas de tempo | Seguimos com as premissas declaradas e deixamos cada uma configurável no app |
| 3 | Quem é o "cliente" que autoriza o uso do app e a exibição do nome do paciente (premissa 7)? | Autorização do uso e tratamento dos dados | Apenas dados fictícios e código no lugar do nome |
| 4 | A proposta define o administrador como o profissional da triagem ou da recepção que confirma cada etapa. Na documentação usamos "administrador" para quem configura a unidade e "equipe da unidade" para quem avança a fila, porque não vimos quem opera o painel. Essa mudança é aceitável? | Os perfis de usuário e as telas da equipe | Mantemos a divisão atual e a registramos como diferença em relação à proposta |
| 5 | Se o app for testado com pacientes reais, o projeto precisa de termo de consentimento (TCLE) e de aprovação de comitê de ética? Com que antecedência pedir? | Qualquer teste com pacientes reais | Somente dados fictícios, sem pacientes reais |
| 6 | Como avaliar o resultado se o app não será lançado? Bastam simulação com dados fictícios e demonstração à equipe da unidade, com indicadores como tempo médio de espera e percepção de pacientes e profissionais? Quais indicadores são essenciais? | O plano de avaliação e a discussão dos resultados | Simulação com os indicadores sugeridos pela literatura |
| 7 | O IFG pode pedir a credencial do login gov.br, ao menos de homologação, para um protótipo de pesquisa? Quem faria o pedido? | Forma de identificação do paciente no app | Cadastro simples próprio, só com dados fictícios; gov.br fica como recomendação futura |
| 8 | O projeto trabalha com custo zero. Dois itens podem exigir gasto: a hospedagem do servidor (uma das opções pede cartão de cobrança) e o aviso no iPhone (exige conta paga de desenvolvedor Apple, cerca de US$ 99 por ano, valor a confirmar). O IFG tem alguma dessas possibilidades? | Escolha da hospedagem e validação no iPhone | Hospedagem gratuita e validação das notificações só no Android, com a limitação registrada no relatório |
| 9 | Podemos reduzir o escopo dos diagramas UML do cronograma e manter a ordem atual das tarefas, em que o núcleo da fila foi adiantado? Qual o prazo e o modelo do relatório parcial? | Plano de modelagem e do relatório | Seguimos o cronograma oficial e registramos cada mudança de ordem |
| 10 | O levantamento atende à fundamentação teórica da proposta? Há algum eixo a ampliar ou aprofundar? | A redação das seções teóricas e do relatório | Usamos os 40 artigos como base e guardamos o material para consulta |

Premissas citadas: 1 escala de risco (Manchester, cinco cores); 3 ordem combina risco, prioridade legal e chegada; 4 o profissional da triagem é enfermeiro; 5 falta após três chamadas e a fila anda; 6 a unidade atende só demanda espontânea; 7 a unidade autoriza o app e a exibição do nome.
