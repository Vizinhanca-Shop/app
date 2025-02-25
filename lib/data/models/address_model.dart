class AddressModel {
  final int placeId;
  final String latitude;
  final String longitude;
  final String name;
  final String displayName;
  final String? city;
  final String? state;
  final String? country;

  AddressModel({
    required this.placeId,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.displayName,
    this.city,
    this.state,
    this.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      placeId: json['place_id'],
      latitude: json['lat'],
      longitude: json['lon'],
      name: json['name'],
      displayName: json['display_name'],
      city:
          json['address']['city'] ??
          json['address']['town'] ??
          json['address']['village'],
      state: json['address']['state'],
      country: json['address']['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'lat': latitude,
      'lon': longitude,
      'name': name,
      'display_name': displayName,
      'city': city,
      'state': state,
      'country': country,
    };
  }
}
