class AnnouncementAddressModel {
  final String latitude;
  final String longitude;
  final String postalCode;
  final String road;
  final String neighborhood;
  final String city;
  final String state;

  AnnouncementAddressModel({
    required this.latitude,
    required this.longitude,
    required this.postalCode,
    required this.road,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  factory AnnouncementAddressModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementAddressModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      postalCode: json['postalCode'],
      road: json['road'],
      neighborhood: json['neighborhood'],
      city: json['city'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lon': longitude,
      'postalCode': postalCode,
      'road': road,
      'neighborhood': neighborhood,
      'city': city,
    };
  }

  factory AnnouncementAddressModel.empty() {
    return AnnouncementAddressModel(
      latitude: '',
      longitude: '',
      postalCode: '',
      road: '',
      neighborhood: '',
      city: '',
      state: '',
    );
  }

  // create a method to return formatted address
  String getFormattedAddress() {
    return '$road, $neighborhood, $city - $state';
  }
}
