class VehicleCheckModel {
  LastVehicleCheck? lastVehicleCheck;

  VehicleCheckModel({this.lastVehicleCheck});

  VehicleCheckModel.fromJson(Map<String, dynamic> json) {
    lastVehicleCheck =
        json['lastVehicleCheck'] != null
            ? LastVehicleCheck.fromJson(json['lastVehicleCheck'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lastVehicleCheck != null) {
      data['lastVehicleCheck'] = lastVehicleCheck!.toJson();
    }
    return data;
  }
}

class LastVehicleCheck {
  String? id;
  String? tyresCondition;
  String? aCCondition;
  String? petrolLevel;
  String? engineCondition;
  String? odoMeterReading;
  String? remarks;
  List<String>? photos;
  String? approvalStatus;
  String? vehicleId;
  String? createdAt;
  String? updatedAt;
  Vehicle? vehicle;
  double? latitude;
  double? longitude;

  LastVehicleCheck({
    this.id,
    this.tyresCondition,
    this.aCCondition,
    this.petrolLevel,
    this.engineCondition,
    this.odoMeterReading,
    this.remarks,
    this.photos,
    this.approvalStatus,
    this.vehicleId,
    this.createdAt,
    this.updatedAt,
    this.vehicle,
    this.latitude,
    this.longitude,
  });

  LastVehicleCheck.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tyresCondition = json['tyresCondition'];
    aCCondition = json['ACCondition'];
    petrolLevel = json['petrolLevel'];
    engineCondition = json['engineCondition'];
    odoMeterReading = json['odoMeterReading'];
    remarks = json['remarks'];
    photos = json['photos'].cast<String>();
    approvalStatus = json['approvalStatus'];
    vehicleId = json['vehicleId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tyresCondition'] = tyresCondition;
    data['ACCondition'] = aCCondition;
    data['petrolLevel'] = petrolLevel;
    data['engineCondition'] = engineCondition;
    data['odoMeterReading'] = odoMeterReading;
    data['remarks'] = remarks;
    data['photos'] = photos;
    data['approvalStatus'] = approvalStatus;
    data['vehicleId'] = vehicleId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Vehicle {
  String? id;
  String? name;
  String? plateNumber;
  String? photo;

  Vehicle({this.id, this.name, this.plateNumber, this.photo});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    plateNumber = json['plateNumber'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['plateNumber'] = plateNumber;
    data['photo'] = photo;
    return data;
  }
}
