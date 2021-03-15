# Flutter Engaged Extended (Portugal) 2021

## Video

Esta é a aplicação a funcionar normalmente.

<img src="https://user-images.githubusercontent.com/404874/111205905-a8130a80-85bf-11eb-8d53-9f30f755ed2a.gif" width="300"/>


MP4: https://user-images.githubusercontent.com/404874/111205210-e52acd00-85be-11eb-8b52-da8a183caab9.mp4


## Objectivo

Neste repositório encontras o código fonte da aplicação que acabamos apresentar no ponto anterior mas modificada de forma a não funcionar como esperado.

O teu objetivo, caso aceites, é investigar o código e corrigir os pontos que não estão correctos. 

Uma correcção, não é melhorar a estrutura do código ou modificar a sua lógica mas sim a aplicação conseguir executar e estar identica ao video que partilhamos ao início deste documento, sem erros, sem problemas.

É necessário saber um pouco sobre Flutter, caso estejas a ver uma aplicação Flutter pela primeira vez podes sempre estudar o código Dart e/ou consultar os seguintes links:

* https://flutter.dev/docs/get-started/learn-more
* https://dart.dev/overview
* https://flutter.dev/docs/reference/tutorials

## Pre-Requisitos

Terás de ter flutter instalado, para tal segue as instruções em https://flutter.dev/docs/get-started/install

1. Cria uma conta em [OpenWeatherMap](https://openweathermap.org/).
2. Poderás então ver a tua API KEY em https://home.openweathermap.org/api_keys.
3. Faz FORK deste repositorio e faz clone do projecto. Para depois abrires Pull Request
4. Instala todas as dependencias com o "flutter pub get"
5. Abre o ficheiro **lib/main.dart** e copia a tua API, substituindo onde diz '<COLOCA_AQUI_A_TUA_CAHVE>'
```dart
    var config = {
    'OpenWeatherApiKey': '<COLOCA_AQUI_A_TUA_CHAVE>',
    };
```
6. Executa a aplicação (e corrige a mesma...)
7. Após concluir com sucesso as correcções, faz o commit das tuas alterações e abre um Pull Request a este repositório
8. Espera pelo resultado :) 


## Vencedor

O Vencedor será aquele que realizar o primeiro Pull Request com a aplicação a funcionar e com o UI idêntico ao video partilhado. 
O juri irá olhar para a hora do Pull Request para determinar a ordem das submissões.
Qualquer tentativa de adulterar o resultado será desqualificado.

Para ti, que leste este README até ao fim, damos-te já uma dica, é necessario substituir onde vès Color.green por Color.blue.

Mais importante, divirtam-se!
