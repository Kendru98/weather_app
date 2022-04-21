import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/MyHomePage.dart';
import 'package:weather_app/SplashScreen.dart';

import 'main.dart';

class PermissionScreen extends StatefulWidget {
  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, //ukladanie rzeczy
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  color: Color(0xffffffff),
                  gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Color(0xff6671e5), Color(0xff4852d9)])),
            ),
            Align(
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage('icons/hand-wave.png')),
                  const Padding(padding: EdgeInsets.only(top: 15.0)),
                  Text(
                    'Hejka!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 50.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5.0)),
                  Text(
                    'Aplikacja ${Strings.appTitle} potrzebuje do działania \n przybliżonej lokalizacji urządzenia',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    )),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 15,
              child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  child: SizedBox(
                      width: double.infinity, //rozciaga do bokow
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(top: 12.0, bottom: 12.0)),
                        ),
                        child: const Text(
                          'Zgoda!',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        onPressed: () async {
                          LocationPermission permission =
                              await Geolocator.requestPermission();
                          if (permission == LocationPermission.always ||
                              permission == LocationPermission.whileInUse) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SplashScreen()));
                          }
                          //pytanie o permisje
                        },
                      ))),
            )
          ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
