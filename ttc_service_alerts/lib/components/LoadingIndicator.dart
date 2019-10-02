import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadingIndicator extends StatefulWidget {
  final Color _colour; // ignore: unused_field

  LoadingIndicator([this._colour = Colors.red]);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Color _colour; // ignore: unused_field
  int _duration = 5000;

  _LoadingIndicatorState({color = Colors.red, duration = 8000}) {
    this._colour = color;
    this._duration = duration;

  }

  @override
  void initState() {
    super.initState();

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
      await _controller.repeat().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
      print("Animation Failed");
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
  static const _curveType = Curves.elasticInOut;

  static const _iconWeight = 0.25;
  static const _rotationWeight = 0.25;

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

  final Animation<double> controller;
  final Animation<IconData> icon;
  final Animation<double> rotation;

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
              size: 45,
            ),
          ),
        );
      },
    );
  }
}
