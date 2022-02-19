import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter_simple_platformer/game/level/level.dart';

// use HasCollidables so items can collide with each other
class SimplePlatformer extends FlameGame
    with HasCollidables, HasKeyboardHandlerComponents {
  Level? _currentLevel;
  // can not be private if level has to access it
  late Image spriteSheet;

  SimplePlatformer() : super() {
    // get information for each item in the game if debug is set to true
    debugMode = false;
  }
  @override
  Future<void>? onLoad() async {
    // make landscape and full screen
    Flame.device.fullScreen();
    Flame.device.setLandscape();
    // load the sprite-sheet
    spriteSheet = await images.load('Spritesheet.png');
    // make camera the same on every sized device
    camera.viewport = FixedResolutionViewport(Vector2(640, 330));
    // create the first level
    loadLevel('level2.tmx');
    return super.onLoad();
  }

  void loadLevel(String levelName) {
    // remove current level if there is one
    _currentLevel?.removeFromParent();
    // add new level-object
    _currentLevel = Level(levelName);
    add(_currentLevel!);
  }
}
