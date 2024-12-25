import 'package:flutter/widgets.dart';
import 'game-object.dart';
import 'sprite.dart';
import 'constants.dart';

List<Sprite> dinoSprites = [
  Sprite()..imagePath = "assets/images/dino/dino_1.png" ..imageWidth = 88 ..imageHeight = 94,
  Sprite()..imagePath = "assets/images/dino/dino_2.png" ..imageWidth = 88 ..imageHeight = 94,
  Sprite()..imagePath = "assets/images/dino/dino_3.png" ..imageWidth = 88 ..imageHeight = 94,
  Sprite()..imagePath = "assets/images/dino/dino_4.png" ..imageWidth = 88 ..imageHeight = 94,
  Sprite()..imagePath = "assets/images/dino/dino_5.png" ..imageWidth = 88 ..imageHeight = 94,
  Sprite()..imagePath = "assets/images/dino/dino_6.png" ..imageWidth = 88 ..imageHeight = 94,
];

enum DinoState {
  jumping,
  running,
  dead,
}

class Dino extends GameObject {
  Sprite currentSprite = dinoSprites[0];
  double dispY = 0;
  double velY = 0;
  DinoState state = DinoState.running;

  @override
  Widget render() {
    return Image.asset(currentSprite.imagePath);
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 2 - currentSprite.imageHeight - dispY,
      currentSprite.imageWidth.toDouble(),
      currentSprite.imageHeight.toDouble(),
    );
  }

  @override
  void update(Duration lastTime, Duration currentTime) {
    if (state == DinoState.dead) return; // Prevent updates if dead

    currentSprite = dinoSprites[(currentTime.inMilliseconds / 100).floor() % 2 + 2];

    double elapsedTimeSeconds = (currentTime - lastTime).inMilliseconds / 1000;

    dispY += velY * elapsedTimeSeconds;
    if (dispY <= 0) {
      dispY = 0;
      velY = 0;
      state = DinoState.running;
    } else {
      velY -= GRAVITY_PPSS * elapsedTimeSeconds;
    }
  }

  void jump() {
    if (state != DinoState.jumping && state != DinoState.dead) {
      state = DinoState.jumping;
      velY = 900;
    }
  }

  void die() {
    currentSprite = dinoSprites[5]; // Set to the dead sprite
    state = DinoState.dead;
  }

  void restart() {
    currentSprite = dinoSprites[0]; // Reset to the initial sprite
    dispY = 0;
    velY = 0;
    state = DinoState.running; // Reset state to running
  }
}