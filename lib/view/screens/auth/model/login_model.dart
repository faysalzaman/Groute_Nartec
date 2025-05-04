import 'dart:convert';

class LoginModel {
  int? statusCode;
  bool? success;
  String? message;
  LoginData? data;

  LoginModel({this.statusCode, this.success, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = LoginData.fromJson(json['data']);
    } else {
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  Driver? driver;
  String? accessToken;

  LoginData({this.driver, this.accessToken});

  LoginData.fromJson(Map<String, dynamic> json) {
    if (json['driver'] != null) {
      driver = Driver.fromJson(json['driver']);
    } else {
      driver = null;
    }
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    data['accessToken'] = accessToken;
    return data;
  }
}

class Driver {
  String? id;
  String? name;
  String? nameAr;
  String? nameNl;
  String? email;
  String? password;
  String? idNumber;
  String? phone;
  String? license;
  String? experience;
  String? availability;
  String? photo;
  bool? isNFCEnabled;
  String? nfcNumber;
  String? createdAt;
  String? updatedAt;
  String? memberId;
  String? vehicleId;
  String? routeId;
  dynamic vehicle;
  Route? route;
  String? radius;

  Driver({
    this.id,
    this.name,
    this.nameAr,
    this.nameNl,
    this.email,
    this.password,
    this.idNumber,
    this.phone,
    this.license,
    this.experience,
    this.availability,
    this.photo,
    this.isNFCEnabled,
    this.nfcNumber,
    this.createdAt,
    this.updatedAt,
    this.memberId,
    this.vehicleId,
    this.routeId,
    this.vehicle,
    this.route,
    this.radius,
  });

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['nameAr'];
    nameNl = json['nameNl'];
    email = json['email'];
    password = json['password'];
    idNumber = json['idNumber'];
    phone = json['phone'];
    license = json['license'];
    experience = json['experience'];
    availability = json['availability'];
    photo = json['photo'];
    isNFCEnabled = json['isNFCEnabled'];
    nfcNumber = json['nfcNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    memberId = json['memberId'];
    vehicleId = json['vehicleId'];
    routeId = json['routeId'];
    vehicle = json['vehicle'];

    if (json['route'] != null) {
      route = Route.fromJson(json['route']);
    } else {
      route = null;
    }

    radius = json['radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nameAr'] = nameAr;
    data['nameNl'] = nameNl;
    data['email'] = email;
    data['password'] = password;
    data['idNumber'] = idNumber;
    data['phone'] = phone;
    data['license'] = license;
    data['experience'] = experience;
    data['availability'] = availability;
    data['photo'] = photo;
    data['isNFCEnabled'] = isNFCEnabled;
    data['nfcNumber'] = nfcNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['memberId'] = memberId;
    data['vehicleId'] = vehicleId;
    data['routeId'] = routeId;
    data['vehicle'] = vehicle;
    if (route != null) {
      data['route'] = route!.toJson();
    }

    return data;
  }
}

class Route {
  String? id;
  String? nameEn;
  String? nameAr;
  String? nameNl;
  String? descriptionEn;
  String? descriptionAr;
  String? descriptionNl;
  List<Coordinate>? points;
  String? radius;
  String? glnNumber;
  String? createdAt;
  String? updatedAt;
  String? memberId;

  Route({
    this.id,
    this.nameEn,
    this.nameAr,
    this.nameNl,
    this.descriptionEn,
    this.descriptionAr,
    this.descriptionNl,
    this.points,
    this.radius,
    this.glnNumber,
    this.createdAt,
    this.updatedAt,
    this.memberId,
  });

  Route.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
    nameNl = json['nameNl'];
    descriptionEn = json['descriptionEn'];
    descriptionAr = json['descriptionAr'];
    descriptionNl = json['descriptionNl'];
    radius = json['radius'];
    glnNumber = json['glnNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    memberId = json['memberId'];

    if (json['points'] != null) {
      points = <Coordinate>[];
      dynamic decodedData;
      try {
        if (json['points'] is String) {
          decodedData = jsonDecode(json['points']);
        } else {
          decodedData = json['points'];
        }
      } catch (e) {
        // Handle decoding error if necessary, maybe log it differently
        decodedData = null;
      }

      if (decodedData is List) {
        for (final item in decodedData) {
          if (item is Map<String, dynamic>) {
            try {
              points!.add(Coordinate.fromJson(item));
            } catch (e) {
              // Handle coordinate parsing error if necessary
            }
          } else {
            // Handle non-map items if necessary
          }
        }
      } else if (decodedData != null) {
        // Handle cases where points data is not a list
      }
    } else {
      points = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nameEn'] = nameEn;
    data['nameAr'] = nameAr;
    data['nameNl'] = nameNl;
    data['descriptionEn'] = descriptionEn;
    data['descriptionAr'] = descriptionAr;
    data['descriptionNl'] = descriptionNl;
    data['radius'] = radius;
    data['glnNumber'] = glnNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['memberId'] = memberId;
    if (points != null) {
      // Ensure points are encoded back to a JSON string if needed when sending data
      data['points'] = jsonEncode(points!.map((e) => e.toJson()).toList());
    }
    return data;
  }
}

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
