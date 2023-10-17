import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/4kgif.gif"), fit: BoxFit.cover,),
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                // Logo centralizada
                //Carregar imagem logo.png
                const SizedBox(height: 120),
                Image.asset('assets/images/gglogo.png', width: 300,),
                const SizedBox(height: 100),
                ClipOval(
                    child: Image.asset('assets/images/logo.png', scale: 1,), // <-- Imagem
                ),
                const SizedBox(height: 100),
          
                // Botão "Começar Jogo"
                ElevatedButton(
                  onPressed: () {
                    Get.to(GameWidget(
                      game: GravityGuyGame(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                  ),
                  child: const Text('Começar Jogo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
