import 'dart:convert';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/my_home_page.dart';
import 'package:weather_app/splash_screen.dart';
import 'package:flutter/material.dart';

class AirScreen extends StatefulWidget {
  AirScreen({Key? key, required this.air}) : super(key: key);
  final AirQuality air;

  @override
  State<AirScreen> createState() => _AirScreenState();
}

class _AirScreenState extends State<AirScreen> {
  PanelController _pc = new PanelController();
  final _cityname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, //ukladanie rzeczy
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    gradient: getGradientByMood(widget.air))),
            Align(
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    //?
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: Container(
                        height: 44.0,
                        child: TextFormField(
                          onEditingComplete: () {
                            getDataByCity(_cityname.text);
                            _cityname.clear();
                          },
                          controller: _cityname,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.pin_drop_outlined),
                              contentPadding: EdgeInsets.only(),
                              border: OutlineInputBorder(),
                              hintText: 'Wybierz miasto'),
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            height: 1.2,
                            color: getBackgroundTextColor(widget.air),
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 60.0)),
                  Text(
                    "Jakość powietrza",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                      fontSize: 14.0,
                      height: 1.2,
                      color: getBackgroundTextColor(widget.air),
                      fontWeight: FontWeight.w300,
                    )),
                  ),
                  Padding(padding: EdgeInsets.only(top: 2.0)),
                  Text(
                    widget.air.quality,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                      fontSize: 22.0,
                      height: 1.2,
                      color: getBackgroundTextColor(widget.air),
                      fontWeight: FontWeight.w400,
                    )),
                  ),
                  Padding(padding: EdgeInsets.only(top: 24)),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 91.0,
                    child: Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center, //w pionie
                          children: [
                            Text(
                              (widget.air.aqi / 200 * 100).floor().toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                fontSize: 64.0,
                                height: 1.2,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              )),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: 'CAQI'),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _pc.open();
                                      },
                                    text: ' ⓘ',
                                    style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                      // decoration: TextDecoration.underline,
                                      fontSize: 20.0,
                                      height: 1.2,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w700,
                                    )),
                                  ),
                                ],
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _pc.open();
                                  },
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  fontSize: 16.0,
                                  height: 1.2,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 26)),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //sized box?
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "PM 2,5",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  fontSize: 14.0,
                                  height: 1.2,
                                  color: getBackgroundTextColor(widget.air),
                                  fontWeight: FontWeight.w300,
                                )),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 2.0)),
                              Text(
                                (widget.air.pm25.toString() + "%"),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  fontSize: 22.0,
                                  height: 1.2,
                                  color: getBackgroundTextColor(widget.air),
                                  fontWeight: FontWeight.w700,
                                )),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: getBackgroundTextColor(widget.air),
                          width: 24,
                          thickness: 1,
                        ),
                        Container(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'PM 10',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  fontSize: 14.0,
                                  height: 1.2,
                                  color: getBackgroundTextColor(widget.air),
                                  fontWeight: FontWeight.w300,
                                )),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 2.0)),
                              Text(
                                (widget.air.pm10.toString()) == '-1'
                                    ? 'brak'
                                    : (widget.air.pm10.toString() + "%"),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  fontSize: 22.0,
                                  height: 1.2,
                                  color: getBackgroundTextColor(widget.air),
                                  fontWeight: FontWeight.w700,
                                )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text(
                    "Stacja pomiarowa",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                      fontSize: 12.0,
                      height: 1.2,
                      color: getBackgroundTextColor(widget.air),
                      fontWeight: FontWeight.w300,
                    )),
                  ),
                  Padding(padding: EdgeInsets.only(top: 2)),
                  Text(
                    (widget.air.station),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                      fontSize: 14.0,
                      height: 1.2,
                      color: getBackgroundTextColor(widget.air),
                      fontWeight: FontWeight.w400,
                    )),
                  ),
                  Padding(padding: EdgeInsets.only(top: 76)),
                ],
              ),
            ),
            Positioned(
                left: 8,
                bottom: (76.0) * 2,
                right: 0,
                top: 0,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Stack(children: [
                    ClipRect(
                      child: Align(
                          alignment: Alignment.topLeft,
                          heightFactor: 1,
                          child: getDangerValueBottom(widget.air)),
                    ),
                    ClipRect(
                      child: Align(
                        alignment: Alignment.topLeft,
                        heightFactor: 1 - widget.air.aqi / 200.floor(),
                        child: getDangerValueTop(widget.air),
                      ),
                    ),
                  ]),
                )),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 62.0, left: 10, right: 10, bottom: 14),
                          child: Divider(
                            height: 10,
                            color: getBackgroundTextColor(widget.air),
                            thickness: 1,
                          )),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 24),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Container(
                              padding: EdgeInsets.all(10.0),
                              height: 38.0,
                              color: Colors.white,
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      alignment: Alignment.centerLeft,
                                      image: getAdviceImage(widget.air),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 8.0)),
                                    Text(
                                      widget.air.advice,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                          textStyle: const TextStyle(
                                        fontSize: 12.0,
                                        height: 1.2,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                      )),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                )),
            SlidingUpPanel(
              controller: _pc,
              minHeight: 0,
              maxHeight: 340,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              panel: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 32)),
                        Text(
                          'Indeks CAQI',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontSize: 14.0,
                            height: 1.2,
                            color: getBackgroundTextColor(widget.air),
                            fontWeight: FontWeight.w400,
                          )),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 8.0)),
                        Text(
                          'Indeks CAQI (ang. Common Air Quality Index) pozwala przedstawić sytuację w Europiie w porównywalny i łatwy do zrozumienia sposób. Wartość indeksu jest prezentowana w postaci jednej liczby. Skala ma rozpietość od 0 do wartości powyżej 100 i powyżej bardzo zanieczyszone. Im wyższa wartość wskażnika, tym większe ryzyko złego wpływu na zdrowie i sampoczucie.',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            fontSize: 12.0,
                            height: 1.2,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          )),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 14)),
                        Text(
                          ' Pył zawieszony PM2,5 i PM10',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontSize: 14.0,
                            height: 1.2,
                            color: getBackgroundTextColor(widget.air),
                            fontWeight: FontWeight.w400,
                          )),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 8.0)),
                        Text(
                          ' Pyły zawieszone to mieszanina bardzo małych cząstek. PM10 to wszystkie pyły mniejsze niz 10μm, natomiast w przypadku  PM2,5 nie większe niż 2,5μm. Zanieczyszczenia pyłowe mają zdolność do adsorpcji swojej powierzchni innych, bardzo szkodliwych związków chemicznych: dioksyn, furanów, metali ciężkich, czy benzo(a)pirenu - najbardziej toksycznego skłądnika smogu.',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            fontSize: 12.0,
                            height: 1.2,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          )),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 14)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  bool havePermission() {
    return true;
  }

  LinearGradient getGradientByMood(AirQuality air) {
    if (air.isGood) {
      return const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Color(0xff4acf8c),
          Color(0xff75eda6),
        ],
      );
    } else if (air.isBad) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xfffbda61),
          Color(0xfff76b1c),
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Color(0xfff4003a),
          Color(0xffff8888),
        ],
      );
    }
  }

  Color getBackgroundTextColor(AirQuality air) {
    if (air.isGood || air.isBad) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  getDangerValueBottom(AirQuality air) {
    if (air.isGood || air.isBad) {
      return Image.asset('icons/danger-value-negative.png', scale: 0.9);
    } else {
      return Image.asset('icons/danger-value.png', scale: 0.9);
    }
  }

  getDangerValueTop(AirQuality air) {
    if (air.isGood) {
      return Image.asset('icons/danger-value-negative.png',
          color: Color(0xff4acf8c), scale: 0.9);
    } else if (air.isBad) {
      return Image.asset('icons/danger-value-negative.png',
          color: Color(0xfffbda61), scale: 0.9);
    } else {
      return Image.asset('icons/danger-value.png',
          color: Color.fromARGB(157, 253, 1, 60), scale: 0.9);
    }
  }

  getAdviceImage(AirQuality air) {
    if (air.isGood) {
      return const AssetImage('icons/happy.png');
    } else if (air.isBad) {
      return const AssetImage('icons/ok.png');
    } else {
      return const AssetImage('icons/sad.png');
    }
  }

  getDataByCity(String choosenCity) async {
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
    String cityname = choosenCity.trim();
    print('debugairscreen');
    print(cityname);
    WeatherFactory wfc = WeatherFactory('9cf121969bdf3d91225425760a96ad3f',
        language: Language.POLISH);
    Weather wc = await wfc.currentWeatherByCityName(cityname);

    log(wc.toJson().toString());
    var lat = wc.latitude; // pobieram koordynaty z weatherapi
    var lon = wc.longitude; // pobieram koordynaty z weatherapi
    List<Weather> w5d = await wfc.fiveDayForecastByCityName(cityname);
    print('5dniowadebug');
    print(w5d);
    String _endpoint = 'https://api.waqi.info/feed/';
    var keyword = 'geo:$lat;$lon';
    var key = 'db13d4cf26d981f04b4a47d491a3882b02e554cf';
    String url = '$_endpoint/$keyword/?token=$key'; //lat i lon

    http.Response response = await http.get(Uri.parse(url));
    log(response.body.toString());
    Map<String, dynamic> jsonBody = jsonDecode(response.body);
    AirQuality aq = AirQuality(jsonBody);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) =>
                MyHomePage(weather: wc, air: aq, weather5d: w5d))));
  }
}
