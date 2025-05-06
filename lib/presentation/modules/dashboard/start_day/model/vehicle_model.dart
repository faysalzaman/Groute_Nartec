class VehicleModel {
  String? id;
  String? name;
  String? description;
  String? plateNumber;
  String? tyresCondition;
  String? aCCondition;
  String? petrolLevel;
  String? engineCondition;
  String? odoMeterReading;
  String? idNumber;
  String? photo;
  String? createdAt;
  String? updatedAt;
  String? memberId;

  VehicleModel({
    this.id,
    this.name,
    this.description,
    this.plateNumber,
    this.tyresCondition,
    this.aCCondition,
    this.petrolLevel,
    this.engineCondition,
    this.odoMeterReading,
    this.idNumber,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.memberId,
  });

  VehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    plateNumber = json['plateNumber'];
    tyresCondition = json['tyresCondition'];
    aCCondition = json['ACCondition'];
    petrolLevel = json['petrolLevel'];
    engineCondition = json['engineCondition'];
    odoMeterReading = json['odoMeterReading'];
    idNumber = json['idNumber'];
    photo = json['photo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    memberId = json['memberId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['plateNumber'] = plateNumber;
    data['tyresCondition'] = tyresCondition;
    data['ACCondition'] = aCCondition;
    data['petrolLevel'] = petrolLevel;
    data['engineCondition'] = engineCondition;
    data['odoMeterReading'] = odoMeterReading;
    data['idNumber'] = idNumber;
    data['photo'] = photo;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['memberId'] = memberId;
    return data;
  }
}
