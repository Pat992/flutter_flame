import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

// use HasHitboxes and Collidable to make this item collidable
class Platform extends PositionComponent with HasHitboxes, Collidable {
  // Unlike the other actors, here is no image needed, since the platforms are already on the tiled-file
  Platform({
    required Vector2 position,
    required Vector2 size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        ) {
    // Use debug mode to see the borders
    debugMode = false;
  }

  @override
  Future<void>? onLoad() {
    // Add a hitbox to the platform
    addHitbox(HitboxRectangle());
    // if the type is passive, it will not check for collisions multiple times, to save resources
    collidableType = CollidableType.passive;
    // it's possible to make the thing smaller then the image
    // addHitbox(HitboxRectangle(relation: Vector2.all(0.5)));
    return super.onLoad();
  }
}
