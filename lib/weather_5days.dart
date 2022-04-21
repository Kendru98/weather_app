import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class Weather5days extends StatefulWidget {
  Weather5days({required List<Weather> this.weather5d});
  final List<Weather> weather5d;

  @override
  State<Weather5days> createState() => _Weather5daysState();
}

class _Weather5daysState extends State<Weather5days> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.deepPurple[500],
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color.fromARGB(255, 105, 104, 155),
            Color.fromARGB(255, 100, 147, 185),
            Color.fromARGB(255, 21, 68, 75),
          ],
        ),
      ),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.weather5d.length,
          itemBuilder: (context, index) {
            return Center(
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Image(
                                  width: 70,
                                  height: 50,
                                  image: AssetImage(
                                      'icons/${widget.weather5d[index].weatherIcon}@2x.png')),
                              Text(
                                '${widget.weather5d[index].date?.hour}:00',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Text(
                                '${widget.weather5d[index].temperature?.celsius!.floor().toString()}°C',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 20.0,
                                        color: getColorByTemperature(widget
                                            .weather5d[index]
                                            .tempFeelsLike!
                                            .celsius!
                                            .floor()
                                            .toInt()),
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          //1 kolumna w rzedzie

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Wiatr:',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        Text(
                                          '${widget.weather5d[index].windSpeed} m/s ',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  fontSize: 15.0,
                                                  color: getColorByWind(widget
                                                      .weather5d[index]
                                                      .windSpeed!
                                                      .toDouble()),
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Text(
                                        //     '${widget.weather5d[index].weatherDescription}'),
                                        Text(
                                          'Wilgotność:',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        Text(
                                          '${widget.weather5d[index].humidity} % ',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  fontSize: 15.0,
                                                  color: getColorByHum(widget
                                                      .weather5d[index]
                                                      .humidity!
                                                      .toInt()),
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Ciśnienie:',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        Text(
                                          '${widget.weather5d[index].pressure} hPa ',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  fontSize: 15.0,
                                                  color: getColorByPressure(
                                                      widget.weather5d[index]
                                                          .pressure!
                                                          .toDouble()),
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(padding: EdgeInsets.only(top: 14)),
                                  Text(
                                    DateFormat.EEEE('pl').format(DateTime.parse(
                                        '${widget.weather5d[index].date}')),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  Text(
                                    DateFormat.MMMMd('pl').format(
                                        DateTime.parse(
                                            '${widget.weather5d[index].date}')),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  Text(
                                    '${widget.weather5d[index].areaName}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ]),
                          ),
                        ],
                      )),
                  Text(
                    '${widget.weather5d[index].weatherDescription}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700)),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[350],
                  )
                ],
              ),
            );
          }),
    ));
  }

  Color getColorByTemperature(int temperature) {
    if (temperature < 0) {
      return Color.fromRGBO(100, 181, 246, 1);
    } else if (temperature < 10) {
      return Color.fromRGBO(174, 213, 129, 1);
    } else if (temperature < 20) {
      return Color.fromRGBO(255, 241, 118, 1);
    } else if (temperature < 30) {
      return Color.fromRGBO(229, 115, 115, 1);
    } else {
      return Color.fromRGBO(183, 28, 28, 1);
    }
  }

  Color getColorByWind(double wind) {
    if (wind < 5.4) {
      return Color.fromRGBO(174, 213, 129, 1);
    } else if (wind < 20.7) {
      return Color.fromRGBO(255, 241, 118, 1);
    } else if (wind < 32.6) {
      return Color.fromRGBO(229, 115, 115, 1);
    } else {
      return Color.fromRGBO(183, 28, 28, 1);
    }
  }

  Color getColorByPressure(double pressure) {
    if (pressure < 1013.25) {
      return Color.fromRGBO(255, 241, 118, 1);
    } else if (pressure > 1013 && pressure < 1014) {
      return Color.fromRGBO(174, 213, 129, 1);
    } else {
      return Color.fromRGBO(229, 115, 115, 1);
    }
  }

  Color getColorByHum(int hum) {
    if (hum < 40) {
      return Color.fromRGBO(255, 241, 118, 1);
    } else if (hum > 40 && hum < 60) {
      return Color.fromRGBO(174, 213, 129, 1);
    } else {
      return Color.fromRGBO(229, 115, 115, 1);
    }
  }

  bool isNight(Weather weather) {
    final now = DateTime.now();

    return now.isAfter(weather.sunset!.toUtc()) ||
        now.isBefore(weather.sunrise!.toUtc());
  }

  LinearGradient getGradientByMood(Weather weather) {
    var main = weather.weatherMain;
    if (main == 'Clouds' || main == 'Drizzle' || main == 'Snow') {
      return const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Color(0xff6e6cd8),
          Color(0xff40a0ef),
          Color(0xff77e1ee),
        ],
      );
    } else if (main == 'Thunderstorm' || isNight(weather)) {
      return const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xff313545),
          Color(0xff121118),
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Color(0xff5283F0),
          Color(0xffCDEDD4),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }
}
