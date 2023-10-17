import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'game_controller.dart';
import 'main.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final GameController gameController = Get.put(GameController());

  GameOverScreen(this.score, {super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {await Get.to(const HomeScreen()); return false;},
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/night.jpg"), fit: BoxFit.cover,),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/tgif.gif'),
                  const SizedBox(height: 200),
                  Text(
                    'Pontuação: $score',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => {
                      gameController.score.value = 0,
                      Get.to(const HomeScreen()),
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Retornar à Tela Inicial'),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
