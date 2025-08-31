import 'package:flutter/cupertino.dart';
import 'package:survival/main.dart';

class OverlayPause extends StatelessWidget {
  final Survival game;
  const OverlayPause({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(30, 42, 42, 43).withOpacity(0.8),
    );
  }
}
