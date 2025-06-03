class StocksOnVanModel {
  String? id;
  String? itemCode;
  String? itemDescription;
  String? itemUnit;
  int? availableQty;
  String? binNoLocation;
  int? itemPrice;
  String? batch;
  String? menuNumber;
  String? requestStatus;
  String? requestStatusCode;
  String? serialNumber;
  String? palletId;
  String? gln;
  String? salesInvoiceDetailId;
  String? expiryDate;
  String? manufectureDate;
  String? status;
  String? orderId;
  String? deliveryId;
  String? vehicleId;
  String? driverId;
  String? productId;
  String? createdAt;
  String? updatedAt;
  Vehicle? vehicle;

  StocksOnVanModel({
    this.id,
    this.itemCode,
    this.itemDescription,
    this.itemUnit,
    this.availableQty,
    this.binNoLocation,
    this.itemPrice,
    this.batch,
    this.menuNumber,
    this.requestStatus,
    this.requestStatusCode,
    this.serialNumber,
    this.palletId,
    this.gln,
    this.salesInvoiceDetailId,
    this.expiryDate,
    this.manufectureDate,
    this.status,
    this.orderId,
    this.deliveryId,
    this.vehicleId,
    this.driverId,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.vehicle,
  });

  StocksOnVanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemCode = json['itemCode'];
    itemDescription = json['itemDescription'];
    itemUnit = json['itemUnit'];
    availableQty = json['availableQty'];
    binNoLocation = json['binNoLocation'];
    itemPrice = json['itemPrice'];
    batch = json['batch'];
    menuNumber = json['menuNumber'];
    requestStatus = json['requestStatus'];
    requestStatusCode = json['requestStatusCode'];
    serialNumber = json['serialNumber'];
    palletId = json['palletId'];
    gln = json['gln'];
    salesInvoiceDetailId = json['salesInvoiceDetailId'];
    expiryDate = json['expiryDate'];
    manufectureDate = json['manufectureDate'];
    status = json['status'];
    orderId = json['orderId'];
    deliveryId = json['deliveryId'];
    vehicleId = json['vehicleId'];
    driverId = json['driverId'];
    productId = json['productId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['itemCode'] = this.itemCode;
    data['itemDescription'] = this.itemDescription;
    data['itemUnit'] = this.itemUnit;
    data['availableQty'] = this.availableQty;
    data['binNoLocation'] = this.binNoLocation;
    data['itemPrice'] = this.itemPrice;
    data['batch'] = this.batch;
    data['menuNumber'] = this.menuNumber;
    data['requestStatus'] = this.requestStatus;
    data['requestStatusCode'] = this.requestStatusCode;
    data['serialNumber'] = this.serialNumber;
    data['palletId'] = this.palletId;
    data['gln'] = this.gln;
    data['salesInvoiceDetailId'] = this.salesInvoiceDetailId;
    data['expiryDate'] = this.expiryDate;
    data['manufectureDate'] = this.manufectureDate;
    data['status'] = this.status;
    data['orderId'] = this.orderId;
    data['deliveryId'] = this.deliveryId;
    data['vehicleId'] = this.vehicleId;
    data['driverId'] = this.driverId;
    data['productId'] = this.productId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    return data;
  }
}

class Vehicle {
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
  String? gln;
  String? binNumber;
  String? createdAt;
  String? updatedAt;
  String? memberId;

  Vehicle({
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
    this.gln,
    this.binNumber,
    this.createdAt,
    this.updatedAt,
    this.memberId,
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
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
    gln = json['gln'];
    binNumber = json['binNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    memberId = json['memberId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['plateNumber'] = this.plateNumber;
    data['tyresCondition'] = this.tyresCondition;
    data['ACCondition'] = this.aCCondition;
    data['petrolLevel'] = this.petrolLevel;
    data['engineCondition'] = this.engineCondition;
    data['odoMeterReading'] = this.odoMeterReading;
    data['idNumber'] = this.idNumber;
    data['photo'] = this.photo;
    data['gln'] = this.gln;
    data['binNumber'] = this.binNumber;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['memberId'] = this.memberId;
    return data;
  }
}
