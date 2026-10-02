import 'package:geolocator/geolocator.dart';

class UserLocation {
  final double latitude;
  final double longitude;
  final String cityName;
  final bool isLiveGps;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    this.isLiveGps = false,
  });
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  UserLocation _currentLocation = UserLocation(
    latitude: 20.3547,
    longitude: 85.8155,
    cityName: "Bhubaneswar",
    isLiveGps: false,
  );

  UserLocation get currentLocation => _currentLocation;

  Future<UserLocation> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _currentLocation;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _currentLocation;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _currentLocation;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 4));

      _currentLocation = UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: "Bhubaneswar",
        isLiveGps: true,
      );
    } catch (_) {
      // Graceful fallback to default Bhubaneswar KIIT coordinates
    }

    return _currentLocation;
  }

  void setManualLocation(String cityName, double lat, double lng) {
    _currentLocation = UserLocation(
      latitude: lat,
      longitude: lng,
      cityName: cityName,
      isLiveGps: false,
    );
  }
}

final locationService = LocationService();
