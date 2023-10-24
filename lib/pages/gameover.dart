import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/game_controller.dart';
import '../main.dart';

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
                children: [
                  Image.asset('assets/images/tgif.gif'),
                  Text(
                    'Pontuação: $score',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(right: 20, bottom: 50, left: 20),
                    height: 250,
                    child: ListView(
                      children: [
                        Table(
                          children: [
                            const TableRow(
                              children: [
                                TableCell(child: Center(
                                    child: Text('Ranking',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                                    )
                                  )
                                ),
                                TableCell(child: Center(
                                    child: Text('Pontuação',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                                    )
                                  )
                                ),
                              ],
                            ),
                            const TableRow(
                              children: [
                                TableCell(child: Text('')),
                                TableCell(child: Text('')),
                              ],
                            ),
                            for ( var i = 0; i < gameController.scores!.length; i++ )
                            TableRow(
                              children: [
                                TableCell(child: Center(
                                    child: Text('${i+1}º Lugar',
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                    )
                                  )
                                ),
                                TableCell(child: Center(
                                    child: Text('${gameController.scores![i].values.last}',
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                    )
                                  )
                                ),
                              ],
                            ),
                            const TableRow(
                              children: [
                                TableCell(child: Text('')),
                                TableCell(child: Text('')),
                              ],
                            ),
                          ],
                        ),
                      ]
                    ),
                  ),
                  
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
