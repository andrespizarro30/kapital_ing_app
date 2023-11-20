import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer(){
    Timer(const Duration(seconds: 5), () async{
      Navigator.pushNamedAndRemoveUntil(context,'login',(route) => false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white60,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: AnimatedTextKit(
                  repeatForever: true,
                  pause: Duration(milliseconds: 500),
                  animatedTexts: [
                    ColorizeAnimatedText(
                        'Bienvenido a la App',
                        textStyle: TextStyle(
                          fontSize: 45.0,
                          fontFamily: 'Signatra',
                        ),
                        colors: [
                          Colors.yellow,
                          Colors.black
                        ],
                        textAlign: TextAlign.center,
                    ),
                    ColorizeAnimatedText(
                        'Cargando Información...',
                        textStyle: TextStyle(
                          fontSize: 45.0,
                          fontFamily: 'Signatra',
                        ),
                        colors: [
                          Colors.black,
                          Colors.yellow,
                        ],
                        textAlign: TextAlign.center
                    ),
                    ColorizeAnimatedText(
                        'Por favor espere...',
                        textStyle: TextStyle(
                          fontSize: 45.0,
                          fontFamily: 'Signatra',
                        ),
                        colors: [
                          Colors.yellow,
                          Colors.black,
                        ],
                        textAlign: TextAlign.center
                    )
                  ],
                )
              ),
              SizedBox(
                height: 40.0,
              ),
              Image.asset("images/kapital_logo.jpg"),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                  width: double.infinity,
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      ColorizeAnimatedText(
                          'Contruyendo Futuro',
                          textStyle: TextStyle(
                            fontSize: 20.0
                          ),
                          colors: [
                            Colors.yellow,
                            Colors.black
                          ],
                          textAlign: TextAlign.center
                      )
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
