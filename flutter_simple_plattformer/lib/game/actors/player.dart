import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_platformer/game/actors/platform.dart';

class Player extends SpriteComponent
    with HasHitboxes, Collidable, KeyboardHandler {
  int _hasAxisInput = 0;
  final double _movementSpeed = 250;
  final Vector2 _velocity = Vector2.zero();
  final double _gravity = 10;
  final double _jumpSpeed = 620;
  bool _jumpInput = false;
  bool _isOnGround = false;
  final _onGroundVector = Vector2(0, -1);

  Player(
    Image image, {
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super.fromImage(
          image,
          srcPosition: Vector2.zero(),
          srcSize: Vector2.all(32),
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        );

  @override
  Future<void>? onLoad() {
    // Circle is needed for collision
    addHitbox(HitboxCircle());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // add movement
    _velocity.x = _hasAxisInput * _movementSpeed;
    // add gravity (increase over time)
    _velocity.y += _gravity;
    // jump if input and on ground
    if (_jumpInput) {
      if (_isOnGround) {
        _velocity.y = -_jumpSpeed;
        _isOnGround = false;
      }
      _jumpInput = false;
    }
    // add upper and lower limit
    // the minimal gravity needs to be negative the jump-speed, so the player cn jump
    _velocity.y = _velocity.y.clamp(-_jumpSpeed, 300);
    position += _velocity * dt;
    // flip player sprite if necessary
    if (_hasAxisInput < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (_hasAxisInput > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hasAxisInput = 0;
    _hasAxisInput += keysPressed.contains(LogicalKeyboardKey.keyA) ? -1 : 0;
    _hasAxisInput += keysPressed.contains(LogicalKeyboardKey.keyD) ? 1 : 0;
    _jumpInput = keysPressed.contains(LogicalKeyboardKey.space);
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    // check if player has landed
    if (other is Platform) {
      if (intersectionPoints.length == 2) {
        // get the middle between the two points of the player object
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // check if player is on ground -> use variable to not create a new Vector2 every time
        if (_onGroundVector.dot(collisionNormal) > 0.9) {
          _isOnGround = true;
        }

        position += collisionNormal.scaled(separationDistance);
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}
