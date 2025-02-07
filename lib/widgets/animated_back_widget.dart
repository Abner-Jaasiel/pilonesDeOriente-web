/*import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:spritewidget/spritewidget.dart';

class AnimatedBackground extends NodeWithSize {
  AnimatedBackground(super.size) { 
    _loadSprites();
  }

  Future<void> _loadSprites() async { 
    final backgroundImage = await _loadImage('assets/sprites/background.png');
    final backgroundSprite = Sprite.fromImage(backgroundImage);
    backgroundSprite.position = const Offset(0, 0);
    backgroundSprite.scale = 2.0; 
    addChild(backgroundSprite);
 
    final characterImage = await _loadImage('assets/sprites/character.png');
    final characterSprite = Sprite.fromImage(characterImage);
    characterSprite.position = Offset(size.width / 2, size.height / 2);
    addChild(characterSprite);
 
    final moveAnimation = MotionTween<double>(
      setter: (value) {
        characterSprite.position = Offset(value, characterSprite.position.dy);
      },
      start: 0.0,
      end: size.width,
      duration: 5.0,  
    );
    characterSprite.motions.run(MotionRepeatForever(motion: moveAnimation));
  }

  Future<ui.Image> _loadImage(String path) async {
    final imageProvider = AssetImage(path);
    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    final completer = Completer<ui.Image>();
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    });
    imageStream.addListener(listener);
    return completer.future;
  }
}*/
