import 'package:feep_competition2021/widgets/locationError.dart';
import 'package:feep_competition2021/widgets/requestError.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feep_competition2021/Screens/hourlyWeatherScreen.dart';
import 'package:feep_competition2021/Screens/weeklyWeatherScreen.dart';
import 'package:feep_competition2021/provider/weatherProvider.dart';

import 'Screens/homeScreen.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherProvider>(
      // First request?
      create: (context) => WeatherProvider(),
      child: MaterialApp(
        title: 'FEEPT_2021',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          primaryColor: Colors.blue,
          accentColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
        routes: {
          WeeklyScreen.routeName: (context) =>
              WeeklyScreen(), // not being used.
          HourlyScreen.routeName: (context) => HourlyScreen(),
          LocationError.routeName: (context) => LocationError(),
          RequestError.routeName: (context) => RequestError(),
        },
      ),
    );
  }
}
