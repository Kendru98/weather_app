import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/MyHomePage.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/PermissionScreen.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
                  const Image(image: AssetImage('icons/cloud-sun.png')),
                  const Padding(padding: EdgeInsets.only(top: 15.0)),
                  Text(
                    Strings.appTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5.0)),
                  Text(
                    'Aplikacja do monitorowania \n czystości powietrza',
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
                bottom: 45,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Przywiewam dane...',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300)),
                  ),
                ))
          ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => PermissionScreen())));
    } else {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        executeOnceAfterBuild();
      });
    }
  }

  Future executeOnceAfterBuild() async {
    bool serviceEnabled;
    var buttonclicked = false;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Włącz lokalizację aby pobrać dane'),
              actions: [
                TextButton(
                    onPressed: () {
                      buttonclicked = true;
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
      await Future.delayed(const Duration(seconds: 10));
      if (buttonclicked) {
        executeOnceAfterBuild();
      }
      //await Future.delayed(const Duration(seconds: 10));

    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  Container(
                      margin: EdgeInsets.only(left: 7),
                      child: Text("Pobieram dane...")),
                ],
              ),
            );
          });
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.lowest,
              forceAndroidLocationManager: true,
              timeLimit: Duration(seconds: 5))
          .then((value) => {loadLocationData(value)})
          .onError((error, stackTrace) => {
                Geolocator.getLastKnownPosition(
                        forceAndroidLocationManager: true)
                    .then((value) => {loadLocationData(value!)})
              });
    }
  }

  loadLocationData(Position value) async {
    var lat = value.latitude;
    var lon = value.longitude;
    WeatherFactory wf = WeatherFactory('9cf121969bdf3d91225425760a96ad3f',
        language: Language.POLISH);
    Weather w = await wf.currentWeatherByLocation(lat, lon);
    log(w.toJson().toString());
    List<Weather> w5d = await wf.fiveDayForecastByLocation(lat, lon);
    String _endpoint = 'https://api.waqi.info/feed/';
    var keyword = 'geo:$lat;$lon';
    var key = 'db13d4cf26d981f04b4a47d491a3882b02e554cf';
    String url = '$_endpoint/$keyword/?token=$key';

    http.Response response = await http.get(Uri.parse(url));
    log(response.body.toString());

    Map<String, dynamic> jsonBody = jsonDecode(response.body);
    AirQuality aq = new AirQuality(jsonBody);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) =>
                MyHomePage(weather: w, air: aq, weather5d: w5d))));
  }
}

class AirQuality {
  bool isGood = false;
  bool isBad = false;
  String quality = "";
  String advice = "";
  int aqi = 0;
  int pm25 = 0;
  int pm10 = 0;
  String station = "";

  AirQuality(Map<String, dynamic> jsonBody) {
    aqi = int.tryParse(jsonBody['data']['aqi'].toString()) ?? -1;
    pm25 = int.tryParse(jsonBody['data']['iaqi']['pm25']['v'].toString()) ?? -1;
    try {
      pm10 =
          int.tryParse(jsonBody['data']['iaqi']['pm10']['v'].toString()) ?? -1;
    } catch (e) {
      pm10 = -1;
      print(e);
    }
    station = jsonBody['data']['city']['name'].toString();
    setupLevel(aqi);
  }

  void setupLevel(int aqi) {
    if (aqi <= 100) {
      quality = "Bardzo dobra";
      advice = "Skorzystaj z dobrego powietrza i wyjdź na spacer";
      isGood = true;
    } else if (aqi <= 150) {
      quality = "Nie za dobra";
      advice = "Jeśli tylko możesz zostań w domu, załatwiaj sprawy online!";
      isBad = true;
    } else {
      quality = "Bardzo zła!";
      advice = "Zdecydowanie zostań w domu i załatwiaj sprawy online!";
    }
  }
}
