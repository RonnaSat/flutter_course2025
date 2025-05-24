import 'package:geolocator/geolocator.dart';

class LocationService {
  double? _latitude;
  double? _longitude;
  String? _locationError;

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get locationError => _locationError;
  bool get hasLocation => _latitude != null && _longitude != null;

  // Get current location from device
  Future<bool> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationError = "Location services are disabled.";
        // Optionally, you could try to open location settings:
        await Geolocator.openLocationSettings();
        return false;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _locationError = "Location permission denied";
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _locationError =
            "Location permissions are permanently denied. Please enable them in app settings.";
        // Optionally, you could try to open app settings:
        await Geolocator.openAppSettings();
        return false;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition();
      _latitude = position.latitude;
      _longitude = position.longitude;
      _locationError = null;

      return true;
    } catch (e) {
      _locationError = "Failed to get location: $e";
      // Log the error e for debugging if needed
      return false;
    }
  }
}
