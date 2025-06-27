class LocationInfo {
  final String longitude;
  final String latitude;
  final String address;
  final String pname;
  final String cityname;
  final String adname;
  final String name;

  const LocationInfo({
    required this.longitude,
    required this.latitude,
    required this.cityname,
    required this.address,
    required this.adname,
    required this.pname,
    required this.name,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
    longitude: json['longitude'],
    latitude: json['latitude'],
    cityname: json['cityname'],
    address: json['address'],
    adname: json['adname'],
    pname: json['pname'],
    name: json['name'],
  );
}
