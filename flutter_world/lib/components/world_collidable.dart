import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

// Hitboxes created with collision maps
class WorldCollidable extends PositionComponent
    with HasGameRef, HasHitboxes, Collidable {
  WorldCollidable() {
    addHitbox(HitboxRectangle());
  }
}
