class LoginModel {
  Driver? driver;
  String? accessToken;

  LoginModel({this.driver, this.accessToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
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
  String? createdAt;
  String? updatedAt;
  String? memberId;
  String? vehicleId;
  String? routeId;

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
    this.createdAt,
    this.updatedAt,
    this.memberId,
    this.vehicleId,
    this.routeId,
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    memberId = json['memberId'];
    vehicleId = json['vehicleId'];
    routeId = json['routeId'];
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
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['memberId'] = memberId;
    data['vehicleId'] = vehicleId;
    data['routeId'] = routeId;
    return data;
  }
}
