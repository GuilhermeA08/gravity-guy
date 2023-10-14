import 'package:flame/game.dart';
import 'package:flappybird/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Aplicativo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo centralizada
            //Careregar imagem logo.png
            Image.asset('assets/images/logo.png'), // <-- Imagem
            const SizedBox(height: 20),

            // Botão "Começar Jogo"
            ElevatedButton(
              onPressed: () {
                Get.to(GameWidget(
                  game: FlappyBirdGame(),
                  loadingBuilder: (context) {
                    return Text("loading");
                  },
                ));
              },
              child: const Text('Começar Jogo'),
            ),
          ],
        ),
      ),
    );
  }
}
