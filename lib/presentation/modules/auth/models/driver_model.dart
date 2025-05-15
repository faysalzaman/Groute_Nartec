import 'dart:convert';

import 'package:groute_nartec/presentation/modules/dashboard/start_day/model/vehicle_model.dart';

part 'coordinate_model.dart';
part 'route_model.dart';

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
  VehicleModel? vehicle;
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
    vehicle =
        json['vehicle'] != null ? VehicleModel.fromJson(json['vehicle']) : null;

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
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    if (route != null) {
      data['route'] = route!.toJson();
    }

    return data;
  }
}
