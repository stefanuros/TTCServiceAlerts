import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:ttc_service_alerts/config/config.dart';

  /// This class is used to create a custom loading indicator
class LoadingIndicator extends StatefulWidget {

  /// This class is used to create a custom loading indicator
  LoadingIndicator();

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with TickerProviderStateMixin {
  AnimationController _controller;

  /// The duration of one loop of the animation
  static const _duration = 5000;

  @override
  void initState() {
    super.initState();

    // Creating the controller for the animation
    _controller = AnimationController(
      duration: Duration(
        milliseconds: _duration,
      ),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _startAnimation() async {
    try {
      // Start, and repeat, the animation
      await _controller.repeat().orCancel;
    } on TickerCanceled {
      // If this is reached, the animation is ended, probably because it was not
      // Needed anymore
    }
  }

  @override
  Widget build(BuildContext context) {
    _startAnimation();

    return Scaffold(
      body: Center(
        child: _AnimatedIcon(
          controller: _controller,
        ),
      ),
    );
  }
}

class _AnimatedIcon extends StatelessWidget {
  /// The type of curve for transitions
  static const _curveType = Curves.elasticInOut;

  /// How much relative weight the icons are given
  static const _iconWeight = 0.25;
  /// How much relative weight the rotation transitions are given
  static const _rotationWeight = 0.25;

  /// This is the animation controller
  final Animation<double> controller;
  /// This animation controls the icon currently being displayed in the loading 
  /// indicator
  final Animation<IconData> icon;
  /// This animation controls the rotation value of the loading indicator
  /// It is used to specify how rotated the icon is at any given time
  final Animation<double> rotation;

  _AnimatedIcon({Key key, this.controller})
      : icon = TweenSequence([
          TweenSequenceItem(
            tween: ConstantTween(
              Icons.directions_transit,
            ),
            weight: _iconWeight/2,
          ),
          TweenSequenceItem(
            tween: ConstantTween(
              Icons.subway,
            ),
            weight: _iconWeight,
          ),
          TweenSequenceItem(
            tween: ConstantTween(
              Icons.directions_bus,
            ),
            weight: _iconWeight,
          ),
          TweenSequenceItem(
            tween: ConstantTween(
              Icons.directions_railway,
            ),
            weight: _iconWeight,
          ),
          TweenSequenceItem(
            tween: ConstantTween(
              Icons.directions_transit,
            ),
            weight: _iconWeight/2,
          ),
        ]).animate(controller),
        rotation = TweenSequence([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.0,
              end: 2 * math.pi,
            ).chain(
              CurveTween(
                curve: _curveType,
              ),
            ),
            weight: _rotationWeight,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 2 * math.pi,
              end: 0.0,
            ).chain(
              CurveTween(
                curve: _curveType,
              ),
            ),
            weight: _rotationWeight,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 0.0,
              end: 2 * math.pi,
            ).chain(
              CurveTween(
                curve: _curveType,
              ),
            ),
            weight: _rotationWeight,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 2 * math.pi,
              end: 0.0,
            ).chain(
              CurveTween(
                curve: _curveType,
              ),
            ),
            weight: _rotationWeight,
          ),
        ]).animate(controller),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return new Container(
          child: Transform.rotate(
            angle: rotation.value,
            child: Icon(
              icon.value,
              size: loadingIconSize,
            ),
          ),
        );
      },
    );
  }
}
