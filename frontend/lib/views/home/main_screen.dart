import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/funight_bg.png',
            fit: BoxFit.cover,
          ),

          // Sombra para melhorar a visibilidade do conteúdo
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Conteúdo principal
          Column(
            children: [
              const SizedBox(height: 80), // Espaço no topo

              // Logo da aplicação
              Image.asset(
                'assets/logo_white.png', // Adiciona a imagem do logo na pasta assets/
                width: 900,
              ),

              const Spacer(), // Empurra os botões para baixo

              // Botões de Login e Registo
              Padding(
                padding: const EdgeInsets.only(bottom: 50), // Espaço na parte inferior
                child: Column(
                  children: [
                    buildLoginButton(context),
                    const SizedBox(height: 15),
                    buildRegisterButton(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget separado para evitar erro de chave global duplicada
  Widget buildLoginButton(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          print('Login Pressionado');
        },
        child: const Text(
          'Login',
        ),
      ),
    );
  }

  // Widget separado para evitar erro de chave global duplicada
  Widget buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: 250,
      child: OutlinedButton(
        onPressed: () {
          print('Botão Registrar Pressionado');
        },
        child: const Text('Registar'),
      ),
    );
  }
}