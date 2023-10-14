import 'package:flappybird/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameOverScreen extends StatelessWidget {
  final int score;

  const GameOverScreen(this.score, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Game Over',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Pontuação: $score',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(const HomeScreen());
              },
              child: const Text('Reiniciar Jogo'),
            ),
          ],
        ),
      ),
    );
  }
}
