import 'package:groute_nartec/core/utils/app_date_formatter.dart';

class SalesOrderModel {
  String? id;
  String? salesInvoiceNumber;
  String? purchaseOrderNumber;
  String? refNo;
  String? orderDate;
  String? deliveryDate;
  String? totalAmount;
  String? status;
  String? subUserId;
  String? signature;
  String? assignedTime;
  String? startJourneyTime;
  String? arrivalTime;
  String? unloadingTime;
  String? invoiceCreationTime;
  String? endJourneyTime;
  String? pickDate;
  String? createdAt;
  String? updatedAt;
  String? driverId;
  String? memberId;
  String? customerId;
  List<SalesInvoiceDetails>? salesInvoiceDetails;
  Customer? customer;

  SalesOrderModel({
    this.id,
    this.salesInvoiceNumber,
    this.purchaseOrderNumber,
    this.refNo,
    this.orderDate,
    this.deliveryDate,
    this.totalAmount,
    this.status,
    this.subUserId,
    this.signature,
    this.assignedTime,
    this.startJourneyTime,
    this.arrivalTime,
    this.unloadingTime,
    this.invoiceCreationTime,
    this.endJourneyTime,
    this.pickDate,
    this.createdAt,
    this.updatedAt,
    this.driverId,
    this.memberId,
    this.customerId,
    this.salesInvoiceDetails,
    this.customer,
  });

  SalesOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesInvoiceNumber = json['salesInvoiceNumber'];
    purchaseOrderNumber = json['purchaseOrderNumber'];
    refNo = json['refNo'];
    orderDate = json['orderDate'];
    deliveryDate = json['deliveryDate'];
    totalAmount = json['totalAmount'];
    status = json['status'];
    subUserId = json['subUser_id'];
    signature = json['signature'];
    assignedTime = json['assignedTime'];
    startJourneyTime = json['startJourneyTime'];
    arrivalTime = json['arrivalTime'];
    unloadingTime = json['unloadingTime'];
    invoiceCreationTime = json['invoiceCreationTime'];
    endJourneyTime = json['endJourneyTime'];
    pickDate = json['pickDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    driverId = json['driverId'];
    memberId = json['memberId'];
    customerId = json['customerId'];
    if (json['SalesInvoiceDetails'] != null) {
      salesInvoiceDetails = <SalesInvoiceDetails>[];
      json['SalesInvoiceDetails'].forEach((v) {
        salesInvoiceDetails!.add(SalesInvoiceDetails.fromJson(v));
      });
    }
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salesInvoiceNumber'] = salesInvoiceNumber;
    data['purchaseOrderNumber'] = purchaseOrderNumber;
    data['refNo'] = refNo;
    data['orderDate'] = orderDate;
    data['deliveryDate'] = deliveryDate;
    data['totalAmount'] = totalAmount;
    data['status'] = status;
    data['subUser_id'] = subUserId;
    data['signature'] = signature;
    data['assignedTime'] = assignedTime;
    data['startJourneyTime'] = startJourneyTime;
    data['arrivalTime'] = arrivalTime;
    data['unloadingTime'] = unloadingTime;
    data['invoiceCreationTime'] = invoiceCreationTime;
    data['endJourneyTime'] = endJourneyTime;
    data['pickDate'] = pickDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['driverId'] = driverId;
    data['memberId'] = memberId;
    data['customerId'] = customerId;
    if (salesInvoiceDetails != null) {
      data['SalesInvoiceDetails'] =
          salesInvoiceDetails!.map((v) => v.toJson()).toList();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
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
  String? createdAt;
  String? updatedAt;
  String? vehicleId;
  String? salesInvoiceId;
  String? deliveryDate;

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
    this.createdAt,
    this.updatedAt,
    this.vehicleId,
    this.salesInvoiceId,
    this.deliveryDate,
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    vehicleId = json['vehicleId'];
    salesInvoiceId = json['salesInvoiceId'];
    deliveryDate =
        json['deliveryDate'] != null
            ? AppDateFormatter.fromString(json['deliveryDate'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productId'] = productId;
    data['productName'] = productName;
    data['productDescription'] = productDescription;
    data['unitOfMeasure'] = unitOfMeasure;
    data['quantity'] = quantity;
    data['quantityPicked'] = quantityPicked;
    data['price'] = price;
    data['totalPrice'] = totalPrice;
    data['images'] = images;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['vehicleId'] = vehicleId;
    data['salesInvoiceId'] = salesInvoiceId;
    data['deliveryDate'] = deliveryDate;
    return data;
  }
}

class Customer {
  String? id;
  String? customerId;
  String? email;
  String? password;
  String? stackholderType;
  String? gs1CompanyPrefix;
  String? companyNameEnglish;
  String? companyNameArabic;
  String? contactPerson;
  String? companyLandline;
  String? mobileNo;
  String? extensions;
  String? zipCode;
  String? website;
  String? gln;
  String? address;
  String? longitude;
  String? latitude;
  String? status;
  String? createdAt;
  String? updatedAt;

  Customer({
    this.id,
    this.customerId,
    this.email,
    this.password,
    this.stackholderType,
    this.gs1CompanyPrefix,
    this.companyNameEnglish,
    this.companyNameArabic,
    this.contactPerson,
    this.companyLandline,
    this.mobileNo,
    this.extensions,
    this.zipCode,
    this.website,
    this.gln,
    this.address,
    this.longitude,
    this.latitude,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    email = json['email'];
    password = json['password'];
    stackholderType = json['stackholderType'];
    gs1CompanyPrefix = json['gs1CompanyPrefix'];
    companyNameEnglish = json['companyNameEnglish'];
    companyNameArabic = json['companyNameArabic'];
    contactPerson = json['contactPerson'];
    companyLandline = json['companyLandline'];
    mobileNo = json['mobileNo'];
    extensions = json['extension'];
    zipCode = json['zipCode'];
    website = json['website'];
    gln = json['gln'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customerId'] = customerId;
    data['email'] = email;
    data['password'] = password;
    data['stackholderType'] = stackholderType;
    data['gs1CompanyPrefix'] = gs1CompanyPrefix;
    data['companyNameEnglish'] = companyNameEnglish;
    data['companyNameArabic'] = companyNameArabic;
    data['contactPerson'] = contactPerson;
    data['companyLandline'] = companyLandline;
    data['mobileNo'] = mobileNo;
    data['extension'] = extensions;
    data['zipCode'] = zipCode;
    data['website'] = website;
    data['gln'] = gln;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
