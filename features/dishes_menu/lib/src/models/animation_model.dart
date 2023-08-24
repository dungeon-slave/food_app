import 'package:flutter/material.dart';

class AnimationModel {
  final AnimationController controller;
  final Animation<Rect?> animation;
  final String imageRef;

  const AnimationModel({
    required this.controller,
    required this.animation,
    required this.imageRef,
  });
}
