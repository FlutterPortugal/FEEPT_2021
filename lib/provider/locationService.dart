import 'package:feep_competition2021/main.dart';
import 'package:location/location.dart';

class LocationServiceException implements Exception {
  final String message;
  const LocationServiceException([this.message = '']);
}

class LocationService {
  /// Requesting service wrapper.
  /// According to the offical package docs: `In order to request location, you should always check manually Location Service status and Permission status.`
  /// https://pub.dev/packages/location
  /// Returns true if service is already enabled or `requestService()`successed.
  static Future<bool> _requestService() async {
    logger.d('Requesting location service.');
    // `location` is singleton.
    final location = Location();
    return (await location.serviceEnabled()) ? true : location.requestService();
  }

  /// Check permission to access location service.
  /// Also required according to official extensions docs.
  /// If permission is granted once, it will not pop again.
  static Future<PermissionStatus> _hasPermission() async {
    logger.d('Requesting access permission for location service.');
    // `location` is singleton.
    final location = Location();
    final permit = await location.hasPermission();
    if (permit == PermissionStatus.denied ||
        permit == PermissionStatus.deniedForever) {
      // location user permission modal.
      return await location.requestPermission();
    }
    return permit;
  }

  /// Check if location service is available and the app has access permissions.
  static Future<bool> isServiceAvailable() async {
    // request location service.
    if (!await _requestService()) {
      logger.w('Service not available.');
      return false;
    }
    // request permission status.
    final permit = await _hasPermission();
    if (permit != PermissionStatus.granted &&
        permit != PermissionStatus.grantedLimited) {
      logger.w('Permission not granted.');
      return false;
    }
    return true;
  }

  /// Get current location with latitude and longitude.
  static Future<LocationData> myLocation() async =>
      await Location().getLocation();
}
