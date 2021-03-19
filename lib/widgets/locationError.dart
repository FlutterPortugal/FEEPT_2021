import 'package:feep_competition2021/provider/locationService.dart';
import 'package:flutter/material.dart';

class LocationError extends StatelessWidget {
  static const routeName = '/locationError';

  /// Fetch Data.
  void _enableLocation(BuildContext context) async {
    if (await LocationService.isServiceAvailable()) {
      Navigator.of(context).pop();
      return;
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Cannot Get Your Location'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'This app uses your phone location to get your location accurate weather data'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              color: Colors.black,
              size: 75,
            ),
            SizedBox(height: 10),
            Text(
              'Your Location is Disabled',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 10),
              child: Text(
                "Please turn on your location service and refresh the app",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('Enable Location'),
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 50),
              onPressed: () => this._enableLocation(context),
            ),
          ],
        ),
      ),
    );
  }
}
