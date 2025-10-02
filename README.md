Fitness Tracker
Este projeto Flutter é um aplicativo de monitoramento de atividades físicas com uma interface moderna e intuitiva. O aplicativo permite que os usuários registrem suas atividades, acompanhem seu progresso e vejam estatísticas pessoais.

Funcionalidades
Autenticação: Sistema de login e registro de usuários. Desenvolvido por Leonardo 

Registro de Atividades: Adicione novas atividades como corrida, ciclismo, yoga, e tipos personalizados. Desenvolvido por Leonardo

Histórico de Atividades: Visualize e filtre um histórico completo de todas as atividades registradas. Desenvolvido por Leonardo

Estatísticas: Acompanhe estatísticas totais, como tempo, distância e calorias. Desenvolvido por José Ricardo

Armazenamento Local: Os dados do usuário e das atividades são salvos localmente no dispositivo usando o pacote shared_preferences. Desenvolvido por José Ricardo

Requisitos de Instalação
Flutter SDK (versão 3.29.0 ou superior).

Dart SDK (versão 3.8.0 ou superior).

Um ambiente de desenvolvimento como Visual Studio Code ou Android Studio.

Um dispositivo Android ou iOS, ou um emulador/simulador configurado.

Instalação e Configuração
Siga os passos abaixo para instalar e executar o aplicativo em seu ambiente de desenvolvimento.

Clone o Repositório:
Abra o terminal e clone o repositório do projeto:


Instale as Dependências:
Acesse a pasta do projeto e instale todas as dependências Flutter listadas no pubspec.yaml.
flutter pub get


Execute o Aplicativo:
Certifique-se de que um dispositivo ou emulador esteja conectado e execute o aplicativo.



flutter run
O aplicativo será iniciado na tela de boas-vindas (SplashScreen), que verificará se há um usuário logado. Se não houver, ele o redirecionará para a tela de autenticação (AuthScreen) para que você possa criar uma nova conta e começar a usar o aplicativo.
