part of 'driver_model.dart';

class Coordinate {
  double? latitude;
  double? longitude;

  Coordinate({this.latitude, this.longitude});

  Coordinate.fromJson(Map<String, dynamic> json) {
    // Make sure keys match ('lat', 'lng')
    if (json.containsKey('lat') && json.containsKey('lng')) {
      latitude = json['lat'];
      longitude = json['lng'];
    } else {
      // Handle missing keys if necessary, maybe throw an error or set defaults
      // throw FormatException("Invalid Coordinate format: $json");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = latitude;
    data['lng'] = longitude;
    return data;
  }
}
