import 'package:feep_competition2021/Screens/hourlyWeatherScreen.dart';
import 'package:feep_competition2021/Screens/weeklyWeatherScreen.dart';
import 'package:feep_competition2021/provider/weatherProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/homeScreen.dart';
import 'package:logger/logger.dart';

var logger = Logger();

var config = {
  'OpenWeatherApiKey': 'ea43c1109bc0f41d9bc4859aa2090a30',
};

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MaterialApp(
        title: 'FEEPT_2021',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            elevation: 0,
          ),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.green,
          accentColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
        routes: {
          WeeklyScreen.routeName: (myCtx) => WeeklyScreen(),
          HourlyScreen.routeName: (myCtx) => HourlyScreen(),
        },
      ),
    );
  }
}
