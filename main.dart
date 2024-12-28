import 'dart:math';
import 'package:flutter/material.dart';
import 'cactus.dart';
import 'cloud.dart';
import 'dino.dart';
import 'game-object.dart';
import 'ground.dart';
import 'splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Dino',
      debugShowCheckedModeBanner: false, 
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  Dino dino = Dino();
  double runDistance = 0;
  double runVelocity = 30;

  late AnimationController worldController;
  Duration lastUpdateCall = Duration();

  List<Cactus> cacti = [Cactus(worldLocation: Offset(200, 0))];

  List<Ground> ground = [
    Ground(worldLocation: Offset(0, 0)),
    Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
  ];

  List<Cloud> clouds = [
    Cloud(worldLocation: Offset(100, 20)),
    Cloud(worldLocation: Offset(200, 10)),
    Cloud(worldLocation: Offset(350, -10)),
  ];

  int score = 0;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    worldController = AnimationController(vsync: this, duration: Duration(days: 99));
    worldController.addListener(_update);
    worldController.forward();
  }

  void _die() {
    setState(() {
      isGameOver = true;
      worldController.stop();
      dino.die();
    });
  }

  void increaseScore() {
    setState(() {
      score += 1;
    });
  }

  _update() {
    if (isGameOver) return;

    Duration duration = worldController.lastElapsedDuration ?? Duration.zero;

    dino.update(lastUpdateCall, duration);

    double elapsedTimeSeconds = (duration - lastUpdateCall).inMilliseconds / 1000;

    runDistance += runVelocity * elapsedTimeSeconds;

    Size screenSize = MediaQuery.of(context).size;

    Rect dinoRect = dino.getRect(screenSize, runDistance);
    for (Cactus cactus in cacti) {
      Rect obstacleRect = cactus.getRect(screenSize, runDistance);
      if (dinoRect.overlaps(obstacleRect)) {
        _die();
      }

      if (obstacleRect.right < 0) {
        setState(() {
          cacti.remove(cactus);
          cacti.add(Cactus(worldLocation: Offset(runDistance + Random().nextInt(100) + 50, 0)));
          increaseScore();
        });
      }
    }

    for (Ground groundlet in ground) {
      if (groundlet.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          ground.remove(groundlet);
          ground.add(Ground(
              worldLocation: Offset(
                  ground.last.worldLocation.dx + groundSprite.imageWidth / 10,
                  0)));
        });
      }
    }

    for (Cloud cloud in clouds) {
      if (cloud.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          clouds.remove(cloud);
          clouds.add(Cloud(
              worldLocation: Offset(
                  clouds.last.worldLocation.dx + Random().nextInt(100) + 50,
                  Random().nextInt(40) - 20.0)));
        });
      }
    }

    lastUpdateCall = worldController.lastElapsedDuration ?? Duration.zero;
  }

  void _restartGame() {
  setState(() {
    isGameOver = false; 
    score = 0; 
    runDistance = 0; 
    cacti.clear();
    cacti.add(Cactus(worldLocation: Offset(300, 20))); 

    ground.clear();
    ground.add(Ground(worldLocation: Offset(0, 0))); 
    ground.add(Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))); 

    
    dino.restart();

    
    worldController.reset(); 
  });


  worldController.forward(); 
 }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];

    // Add background 
    children.add(Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"), 
            fit: BoxFit.cover,
          ),
        ),
      ),
    ));

    for (GameObject object in [...clouds, ...ground, ...cacti, dino]) {
      children.add(AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          }));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (!isGameOver) {
            dino.jump();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ...children,
            Positioned(
              top: 50,
              left: 20,
              child: Text(
                'Score: $score',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            if (isGameOver)
              Positioned(
                left: screenSize.width / 2 - 100,
                top: screenSize.height / 2 - 100,
                child: Container(
                  color: Colors.black54,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Game Over',
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Final Score: $score',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _restartGame,
                        child: Text('Restart'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}