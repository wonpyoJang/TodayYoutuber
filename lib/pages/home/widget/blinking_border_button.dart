import 'package:flutter/material.dart';

class BlickingBorderButton extends StatefulWidget {
  const BlickingBorderButton({
    Key key,
    this.title,
    this.width,
    this.height,
  }) : super(key: key);
  final String title;
  final double width;
  final double height;

  @override
  _BlickingBorderButtonState createState() => _BlickingBorderButtonState();
}

class _BlickingBorderButtonState extends State<BlickingBorderButton>
    with SingleTickerProviderStateMixin {
  AnimationController _resizableController;

  @override
  void initState() {
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 600,
      ),
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _resizableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _resizableController,
        builder: (context, snapshot) {
          return Container(
            width: widget.width,
            height: widget.height,
            child: Center(
                child: Text(widget.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0))),
            decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    width: 2 + _resizableController.value * 3,
                    color: Colors.pink[300])),
          );
        });
  }
}
