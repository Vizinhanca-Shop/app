import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'
    show placemarkFromCoordinates, Placemark;
import 'package:vizinhanca_shop/data/models/address_model.dart';

abstract class LocationService {
  Future<LocationData> getCurrentLocation();
  Future<AddressModel> getAddressFromLocation(double lat, double lng);
}

class LocationData {
  final double latitude;
  final double longitude;

  LocationData({required this.latitude, required this.longitude});
}

class LocationServiceImpl implements LocationService {
  @override
  Future<LocationData> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw LocationException('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    final position = await Geolocator.getCurrentPosition();

    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Future<AddressModel> getAddressFromLocation(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];

      return AddressModel(
        placeId: place.hashCode,
        latitude: lat.toString(),
        longitude: lng.toString(),
        name: place.subLocality ?? '',
        displayName: place.subLocality ?? '',
        city: place.subAdministrativeArea ?? '',
        state: place.administrativeArea,
        country: place.country,
      );
    } catch (e) {
      throw LocationException('Error getting address from location');
    }
  }
}

class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => 'LocationException: $message';
}
