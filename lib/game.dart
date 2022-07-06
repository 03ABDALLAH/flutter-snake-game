import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/control_panel.dart';
import 'package:snake_game/direction.dart';
import 'package:snake_game/piece.dart';

class GamePage extends StatefulWidget {
  const GamePage({ Key? key }) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  int? upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  double? screenWidth, screenHeight;
  int step = 30;
  int length = 5;
  int score = 0;
  double speed = 1.0;
  Offset? foodPosition;
  late Piece food;
  List<Offset> positions = [];
  Direction direction = Direction.right;
  Timer? timer;





  void changeSpeed(){
    if(timer != null && timer!.isActive){
      timer?.cancel();
    }
    timer = Timer.periodic(Duration(milliseconds: 200 ~/ speed), (timer) {
      setState(() {
        
      });
     });
  }

  Widget getControls(){
    return ControlPanel(
      onTapped: (Direction newDirection){
        direction = newDirection;
      },
    );
  }

  Direction getRandomDirection(){
    int val = Random().nextInt(4);
    direction = Direction.values[val];
    return direction;
  }

  void restart(){
    length = 5;
    score = 0;
    speed = 1;
    positions = [];
    direction = getRandomDirection();
    changeSpeed();
  }


  @override
  initState(){
    super.initState();
    restart();
  }

  int getNearesTens(int num){
    int output;
    output = (num ~/ step)*step;
    if(output == 0){
      output += step;
    }
    return output;
  }

  Offset getRandomPosition(){
    Offset position;
    int posX = Random().nextInt(upperBoundX!) + lowerBoundX!;
    int posY = Random().nextInt(upperBoundY!) + lowerBoundY!;

    position = Offset(
      getNearesTens(posX).toDouble(),
      getNearesTens(posY).toDouble());
      return position;
  }


  void drawFood(){
    if(foodPosition == null){
      foodPosition = getRandomPosition();
    }

    if(foodPosition == positions[0]){
      length++;
      score += 5;
      speed += 0.25;
      foodPosition = getRandomPosition();
    }

    food = Piece(
      posX: foodPosition!.dx.toInt(), 
      posY: foodPosition!.dy.toInt(), 
      size: step, 
      color: Colors.red,
      isAnimated: true,
      );

  }

  void draw()async{

    if(positions.length == 0){
      positions.add(getRandomPosition());
    }

    while(length>positions.length){
      positions.add(positions[positions.length-1]);
    }

    for(var i=positions.length-1 ; i>0 ; i--){
      positions[i] = positions[i-1];
    }

    positions[0] = (await getNextPosition(positions[0]))!;
  }


  List<Piece> getPieces(){
    final pieces = <Piece>[];
    draw();
    drawFood();
    for(var i=0 ; i<length ; i++){
      if(i>=positions.length){
        continue;
      }
        
      pieces.add(Piece(
        posX: positions[i].dx.toInt(), 
        posY: positions[i].dy.toInt(), 
        size: step, 
        color: i.isEven ? Colors.red : Colors.lightBlue[300]!,
        isAnimated: false,
        ));
    }
    
    return pieces;
  }


  bool detectCollision(Offset position){

    if(position.dx >= upperBoundX! && direction == Direction.right){
      return true;
    }else if(position.dx <= lowerBoundX! && direction == Direction.left){
      return true;
    }else if(position.dy >= upperBoundY! && direction == Direction.down){
      return true;
    }else if(position.dy <= lowerBoundY! && direction == Direction.up){
      return true;
    }

    return false;
  }


  void showGameOverDialog(){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.blue,
              width: 3.0
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          title: Center(
            child: Text(
              "Game Over",
              style: TextStyle(color: Colors.white, fontSize: 35),
            ),
          ),
          content: score < 50 ? RichText(
            text: TextSpan(
              text: "You didn't play well good luck next time ",
              style: TextStyle(color: Colors.white, fontSize: 20),
              children: [
                TextSpan(
                text: "Your Score is : ",
                style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                TextSpan(
                text: score.toString(),
                style: TextStyle(color: Colors.green, fontSize: 25),
            )],    
            ),
          ) :RichText(
            text: TextSpan(
              text: "Your game is over but you played well. Your score is ",
              style: TextStyle(color: Colors.white, fontSize: 20),
              children: [
                TextSpan(
                text: "Your Score is : ",
                style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                TextSpan(
                text: score.toString(),
                style: TextStyle(color: Colors.green, fontSize: 25),
            )],    
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async{
                Navigator.of(context).pop();
                restart();
              },
              child: Text(
                "Restart",
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }


  

  Future <Offset?> getNextPosition(Offset position)async{
    Offset? nextPosition;

    if(direction == Direction.right){
      nextPosition = Offset(position.dx + step, position.dy);
    }else if(direction == Direction.left){
      nextPosition = Offset(position.dx - step, position.dy);
    }else if(direction == Direction.up){
      nextPosition = Offset(position.dx, position.dy - step);
    }else if(direction == Direction.down){
      nextPosition = Offset(position.dx, position.dy + step);
    }

    if(detectCollision(position)==true){
      if(timer != null && timer!.isActive){
        timer!.cancel();
      }
      await Future.delayed(Duration(milliseconds: 200), () => showGameOverDialog());
      return position;
    }
    return nextPosition;
  }

  Widget getScore(){
    return Positioned(
      top: 80.0,
      left: 50.0,
      child: Text(
        "Score :"+score.toString(),
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
    );
  }

 

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    lowerBoundX = step;
    lowerBoundY = step;

    upperBoundY = getNearesTens(screenHeight!.toInt()-step);
    upperBoundX = getNearesTens(screenWidth!.toInt()-step);

    return Scaffold(
      body: Container(
        color: Colors.teal[200],
        child: Stack(
          children: [
            Stack(
              children: 
                getPieces(),   
            ),
            getControls(),
            food,
            getScore()
          ],
        ),
      ),
    );
  }
}