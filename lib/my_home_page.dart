import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/air_screen.dart';
import 'package:weather_app/splash_screen.dart';
import 'package:weather_app/weather_screen.dart';

import 'weather_5days.dart';

class MyHomePage extends StatefulWidget {
  // MyHomePage({required this.weather});
  MyHomePage(
      {required this.weather,
      required this.air,
      required List<Weather> this.weather5d});
  final Weather weather;
  final AirQuality air;
  final List<Weather> weather5d;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var screens;

  @override
  void initState() {
    screens = [
      AirScreen(air: widget.air),
      WeatherScreen(weather: widget.weather, weather5d: widget.weather5d),
      Weather5days(
        weather5d: widget.weather5d,
      )
    ];
    super.initState();
  }

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
              icon: Image.asset("icons/house.png"),
              activeIcon: Image.asset("icons/house-checked.png"),
              label: 'Powietrze'),
          BottomNavigationBarItem(
              icon: Image.asset("icons/cloud.png"),
              activeIcon: Image.asset("icons/cloud-checked.png"),
              label: 'Pogoda'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_sharp), label: 'Pogoda na 5 dni'),
        ],
      ),
    );
  }
}
