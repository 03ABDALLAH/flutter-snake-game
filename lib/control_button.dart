
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final Function() onPressed;
  final Icon icon;
  const ControlButton({ Key? key, required this.onPressed, required this.icon }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1,
      child: Container(
        width: 80.0,
        height: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.green[200],
            elevation: 0.0,
            onPressed: this.onPressed,
            child: this.icon,
          ),
        ),
      ),
    );
  }
}