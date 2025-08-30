import 'package:flutter/material.dart';
import 'package:survival/main.dart';

class MainMenu extends StatelessWidget {
  final Survival game;
  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Survival',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => game.startGame(),
            child: const Text("Iniciar"),
          ),
        ],
      ),
    );
  }
}
