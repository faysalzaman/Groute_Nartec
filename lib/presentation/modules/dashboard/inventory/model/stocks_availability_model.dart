class StocksAvailablityModel {
  String? purchaseOrderNumber;
  String? refNo;
  SalesInvoiceDetails? salesInvoiceDetails;
  int? totalStocks;

  StocksAvailablityModel({
    this.purchaseOrderNumber,
    this.refNo,
    this.salesInvoiceDetails,
    this.totalStocks,
  });

  StocksAvailablityModel.fromJson(Map<String, dynamic> json) {
    purchaseOrderNumber = json['purchaseOrderNumber'];
    refNo = json['refNo'];
    salesInvoiceDetails =
        json['SalesInvoiceDetails'] != null
            ? new SalesInvoiceDetails.fromJson(json['SalesInvoiceDetails'])
            : null;
    totalStocks = json['totalStocks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purchaseOrderNumber'] = this.purchaseOrderNumber;
    data['refNo'] = this.refNo;
    if (this.salesInvoiceDetails != null) {
      data['SalesInvoiceDetails'] = this.salesInvoiceDetails!.toJson();
    }
    data['totalStocks'] = this.totalStocks;
    return data;
  }
}

class SalesInvoiceDetails {
  String? id;
  String? productId;
  String? productName;
  String? productDescription;
  String? unitOfMeasure;
  String? quantity;
  String? quantityPicked;
  String? price;
  String? totalPrice;
  String? images;
  String? vehicleId;
  String? deliverySignature;
  String? deliveryDate;
  String? createdAt;
  String? updatedAt;
  String? salesInvoiceId;

  SalesInvoiceDetails({
    this.id,
    this.productId,
    this.productName,
    this.productDescription,
    this.unitOfMeasure,
    this.quantity,
    this.quantityPicked,
    this.price,
    this.totalPrice,
    this.images,
    this.vehicleId,
    this.deliverySignature,
    this.deliveryDate,
    this.createdAt,
    this.updatedAt,
    this.salesInvoiceId,
  });

  SalesInvoiceDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    unitOfMeasure = json['unitOfMeasure'];
    quantity = json['quantity'];
    quantityPicked = json['quantityPicked'];
    price = json['price'];
    totalPrice = json['totalPrice'];
    images = json['images'];
    vehicleId = json['vehicleId'];
    deliverySignature = json['deliverySignature'];
    deliveryDate = json['deliveryDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    salesInvoiceId = json['salesInvoiceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productDescription'] = this.productDescription;
    data['unitOfMeasure'] = this.unitOfMeasure;
    data['quantity'] = this.quantity;
    data['quantityPicked'] = this.quantityPicked;
    data['price'] = this.price;
    data['totalPrice'] = this.totalPrice;
    data['images'] = this.images;
    data['vehicleId'] = this.vehicleId;
    data['deliverySignature'] = this.deliverySignature;
    data['deliveryDate'] = this.deliveryDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['salesInvoiceId'] = this.salesInvoiceId;
    return data;
  }
}
