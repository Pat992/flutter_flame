import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_simple_platformer/game/actors/coin.dart';
import 'package:flutter_simple_platformer/game/actors/door.dart';
import 'package:flutter_simple_platformer/game/actors/enemy.dart';
import 'package:flutter_simple_platformer/game/actors/platform.dart';
import 'package:flutter_simple_platformer/game/actors/player.dart';
import 'package:flutter_simple_platformer/game/simple_platformer.dart';

// Level object, the levelName is given to load the correct tiled-file
// use HasGameRef to get information from the FlameGame
class Level extends Component with HasGameRef<SimplePlatformer> {
  final String levelName;
  late Player _player;
  late Rect _levelBounds;

  Level(this.levelName) : super();

  @override
  Future<void>? onLoad() async {
    // Get tiled level
    final level = await TiledComponent.load(levelName, Vector2.all(32));
    add(level);

    // Get bounds of the level
    _levelBounds = Rect.fromLTWH(
        0,
        0,
        (level.tileMap.map.width * level.tileMap.map.tileWidth).toDouble(),
        (level.tileMap.map.height * level.tileMap.map.tileHeight).toDouble());
    _spawnActors(level.tileMap);
    _setupCamera();
    return super.onLoad();
  }

  void _spawnActors(RenderableTiledMap level) {
    // get the platforms-layer
    final platformLayer = level.getObjectGroupFromLayer('Platforms');
    // save all the tiled-spawn points in a variable
    final spawnPointLayer = level.getObjectGroupFromLayer('SpawnPoints');
    // go through all the platforms
    for (var platformItem in platformLayer.objects) {
      final platform = Platform(
        position: Vector2(platformItem.x, platformItem.y),
        size: Vector2(platformItem.width, platformItem.height),
      );
      add(platform);
    }
    // go through each of the spawn points
    for (var spawnPoint in spawnPointLayer.objects) {
      switch (spawnPoint.type) {
        // Thanks to tiled, we can use the created spawn points, and their sizes
        case 'Player':
          _player = Player(
            gameRef.spriteSheet,
            levelBounds: _levelBounds,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
            // make camera staying in the middle of the player
            anchor: Anchor.center,
          );
          // player then to level
          add(_player);
          break;
        case 'Coin':
          final coin = Coin(
            gameRef.spriteSheet,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          // player then to level
          add(coin);
          break;
        case 'Door':
          final door = Door(
            gameRef.spriteSheet,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          // player then to level
          add(door);
          break;
        case 'Enemy':
          final enemy = Enemy(
            gameRef.spriteSheet,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          // player then to level
          add(enemy);
          break;
      }
    }
  }

  // make camera follow the player
  void _setupCamera() {
    gameRef.camera.followComponent(_player);
    // make camera stay inside the level boundaries
    gameRef.camera.worldBounds = _levelBounds;
  }
}
