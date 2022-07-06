import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  const Piece({ Key? key, required this.posX, required this.posY, required this.size, required this.color, this.isAnimated = false }) : super(key: key);

  final int posX, posY, size;
  final Color color;
  final bool isAnimated;

  @override
  State<Piece> createState() => _PieceState();
}


class _PieceState extends State<Piece> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;


  @override
  dispose() {
    _animationController.dispose(); 
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.25,
      duration: Duration(milliseconds: 1000),
      upperBound: 1.0
    );
    _animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _animationController.reset();
      }else if(status == AnimationStatus.dismissed){
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.posY.toDouble(),
      left: widget.posX.toDouble(),
      child: Opacity(
        opacity: widget.isAnimated? _animationController.value:1 ,
        child: Container(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 2, color: Colors.black)
          ),
        ),
      ),
    );
  }
}