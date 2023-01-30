import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:yuktidea/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Builder(builder: (context) {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/screen1.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.darken)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 50),
              child: Row(
                children: const [
                  Image(
                    image: AssetImage('assets/logo.png'),
                    height: 50,
                    width: 50,
                  ),
                  Text(
                    ' CINE COMPASS',
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'YOUR ONE STOP SOLUTION TO\nRent Pre-Production Equipments Easily',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(height: 50, width: 200),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                            ),
                            onPressed: (() {
                              Navigator.of(context).push(PageTransition(
                                  child: login(),
                                  type: PageTransitionType.rightToLeft));
                            }),
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }
}
