import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import './main.dart';
import 'package:flutter_animated_splash/flutter_animated_splash.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return AnimatedSplash(
      navigator: MyHomePage(title: 'Try to avoid cactus to get more score! '), //same of nextscreen
      durationInSeconds: 3, 
      backgroundColor: const Color.fromARGB(255, 85, 85, 85),
      type: Transition.size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              'assets/animation/Animation - 1735385047619.json', 
              width: 200, 
              height: 200, 
              
            ),
          ),
          SizedBox(height: 20),
          Text(
            'DINO GAME',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
          ),
        ],
      ), 
    );
  }
}