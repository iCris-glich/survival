import 'package:flutter/cupertino.dart';

class OverlayCrafteo extends StatelessWidget {
  const OverlayCrafteo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey.withOpacity(0.8),
      child: Center(
        child: Text(
          'Crafteo Overlay',
          style: TextStyle(
            color: CupertinoColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
