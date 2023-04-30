// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:personal_assistant/jantungJarvis.dart';
import 'package:http/http.dart' as http;
import 'package:personal_assistant/model/news.dart';
import 'package:personal_assistant/services/weather_service.dart';
import 'model/weather.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:battery_plus/battery_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getWeather();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      getBatteryLevel();
    });
  }

  //////////// BATTERY PART //////////
  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _batteryStateSubscription;
  int _batteryLevel = 0;
  late Timer timer;

  getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });
  }

  //////////// WEATHER PART //////////
  WeatherService weatherService = WeatherService();
  Weather weather = Weather();

  String currentWeather = "";
  double tempC = 0;
  double tempF = 0;
  String name = "";
  String region = '';
  String country = '';
  String localTime = '';

  void getWeather() async {
    weather = await weatherService.getWeatherData("Surabaya");

    setState(() {
      currentWeather = weather.condition;
      tempF = weather.temperatureF;
      tempC = weather.temperatureC;
      name = weather.name;
      region = weather.region;
      country = weather.country;
      localTime = weather.localTime;
    });
  }

  //////////// NEWS PART //////////
  List<News> listNews = [];

  Future getNews() async {
    var response = await http.get(
      Uri.https("newsapi.org", "/v2/everything",
          {"domains": "wsj.com", "apiKey": "f379c97568a240e79cdd6e50245c4954"}),
    );
    var jsonData = jsonDecode(response.body);

    int i = 0;
    while (i <= 30) {
      for (var eachNews in jsonData['articles']) {
        final news = News(eachNews['title'], eachNews['description']);

        listNews.add(news);
      }
      i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    getNews();
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.black, Colors.grey],
        end: Alignment.bottomCenter,
      )),
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Row(
          children: [
            // LEFT SIDE
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Weather",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Container(
                      width: 200,
                      height: 75,
                      color: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$name, $region, $country \n $localTime \n $currentWeather \n ${tempC.toString()} Celcius, ${tempF.toString()} Farenheit",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
                  ),
                  Text(
                    "News",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Container(
                      width: 300,
                      height: 300,
                      color: Colors.grey,
                      child: FutureBuilder(
                        future: getNews(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return ListView.builder(
                              itemCount: listNews.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    listNews[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    listNews[index].desc,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // MID SIDE
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Mr Adnan Bayu \n Personal Assistant Mark I",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 8,
                  ),
                  Image.asset(
                    "assets/jarvis-logo.png",
                    scale: 1.5,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 10,
                  ),
                ],
              ),
            ),

            // RIGHT SIDE
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Battery Level",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Center(
                  child: CircularPercentIndicator(
                    center: Text(
                      "$_batteryLevel %",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    radius: 60,
                    animation: true,
                    progressColor: Colors.blueGrey,
                    backgroundColor: Colors.white,
                    animationDuration: 2000,
                    percent: 0.7,
                    lineWidth: 15,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: runVolumeControl,
                      icon: Icon(Icons.volume_up),
                      label: Text("volume control"),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: runCursorControl,
                      icon: Icon(Icons.mouse),
                      label: Text("cursor control"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
