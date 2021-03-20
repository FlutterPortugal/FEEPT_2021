import 'package:feep_competition2021/main.dart';
import 'package:feep_competition2021/provider/locationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../provider/weatherProvider.dart';
import '../widgets/WeatherInfo.dart';
import '../widgets/fadeIn.dart';
import '../widgets/hourlyForecast.dart';
import '../widgets/locationError.dart';
import '../widgets/mainWeather.dart';
import '../widgets/requestError.dart';
import '../widgets/searchBar.dart';
import '../widgets/weatherDetail.dart';
import '../widgets/sevenDayForecast.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();

  /// dispose.
  @override
  void dispose() {
    this._pageController.dispose();
    super.dispose();
  }

  /// Get weather data using current location.
  Future<void> _fetchWeatherData(BuildContext context,
      {String location = ''}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
    try {
      await context.read<WeatherProvider>().getWeatherData(
          useCurrentLocation: location.isEmpty, location: location);
      Navigator.of(context).pop();
    } on LocationServiceException {
      // pop loading dialog.
      Navigator.of(context).popAndPushNamed(LocationError.routeName);
      // Navigator.of(context).pushNamed(LocationError.routeName);
    } on WeatherRequestException {
      // pop loading dialog.
      Navigator.of(context).popAndPushNamed(RequestError.routeName);
      // Navigator.of(context).pushNamed(RequestError.routeName);
    } catch (error) {
      logger.e(error);
      Navigator.of(context).pop();
    }
  }

  Widget nothingHereWidget(ThemeData theme) => FadeIn(
        delay: 0.33,
        child: Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Pull down to refresh',
                        style: theme.textTheme.headline4),
                    const SizedBox(width: 4.0),
                    Icon(Icons.arrow_downward,
                        color: theme.primaryColor, size: 32),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Or search for a specific location',
                      style: theme.textTheme.headline6),
                  const SizedBox(width: 4.0),
                  Icon(Icons.search, color: theme.primaryColor),
                ],
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: 'Requests ',
                      style: theme.textTheme.bodyText1,
                      children: [
                        TextSpan(text: ' '),
                        TextSpan(
                            text: 'Location Permission',
                            style: theme.textTheme.bodyText1
                                .copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: ' to get weather data for current location.',
                            style: theme.textTheme.bodyText1)
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      );

  /// build.
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, WeatherProvider provider, child) {
            return Column(
              children: [
                child,
                SmoothPageIndicator(
                  count: 2,
                  controller: _pageController,
                  effect: ExpandingDotsEffect(
                    activeDotColor: theme.primaryColor,
                    dotHeight: 6,
                    dotWidth: 6,
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      // -- First page view.
                      RefreshIndicator(
                        color: theme.primaryColor,
                        onRefresh: () => this._fetchWeatherData(context),
                        child: (provider.weather == null)
                            ? this.nothingHereWidget(theme)
                            : Container(
                                padding: const EdgeInsets.all(10),
                                width: mediaQuery.size.width,
                                child: ListView(
                                  children: [
                                    FadeIn(
                                      delay: 0,
                                      child: MainWeather(
                                        weather: provider.weather,
                                      ),
                                    ),
                                    FadeIn(
                                      delay: 0.33,
                                      child: WeatherInfo(
                                        weather: provider.currentWeather,
                                      ),
                                    ),
                                    FadeIn(
                                      delay: 0.66,
                                      child: HourlyForecast(
                                        provider.hourlyWeather,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      // -- Second page view.

                      RefreshIndicator(
                        color: theme.primaryColor,
                        onRefresh: () async =>
                            await this._fetchWeatherData(context),
                        child: (provider.currentWeather == null)
                            ? this.nothingHereWidget(theme)
                            : Container(
                                height: mediaQuery.size.height,
                                width: mediaQuery.size.width,
                                child: ListView(
                                  children: [
                                    FadeIn(
                                      delay: 0.33,
                                      child: SevenDayForecast(
                                        weather: provider.weather,
                                        dWeather: provider.sevenDayWeather,
                                      ),
                                    ),
                                    FadeIn(
                                      delay: 0.66,
                                      child: WeatherDetail(
                                        weather: provider.weather,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          child: SearchBar(
              onSearch: (value) =>
                  this._fetchWeatherData(context, location: value)),
        ),
      ),
    );
  }
}
