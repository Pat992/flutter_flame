import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'game/simple_platformer.dart';

void main() {
  runApp(const MyApp());
}

// make global to not create new instance in case of reload
final _game = SimplePlatformer();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GameWidget(
          // on debug-mode, the game should be reloaded, but not in release
          game: kDebugMode ? SimplePlatformer() : _game,
        ),
      ),
    );
  }
}
