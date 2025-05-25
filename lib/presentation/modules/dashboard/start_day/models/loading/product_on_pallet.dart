class ProductOnPallet {
  String? id;
  String? name;
  String? nameAr;
  String? nameNL;
  String? unit;
  String? size;
  String? origin;
  String? countrySale;
  String? productType;
  String? packagingType;
  String? gpc;
  int? price;
  String? description;
  String? descriptionAr;
  String? descriptionNL;
  String? image;
  String? status;
  String? gtin;
  String? sku;
  String? brandName;
  String? brandNameAr;
  String? brandNameNL;
  String? batch;
  String? uniqueProductCode;
  String? expiryDate;
  String? packagingDate;
  int? quantity;
  String? gln;
  String? binLocation;
  String? palletId;
  String? serialNumber;
  String? manufectureDate;
  String? createdAt;
  String? updatedAt;
  String? categoryId;
  String? memberId;
  String? productId;

  ProductOnPallet({
    this.id,
    this.name,
    this.nameAr,
    this.nameNL,
    this.unit,
    this.size,
    this.origin,
    this.countrySale,
    this.productType,
    this.packagingType,
    this.gpc,
    this.price,
    this.description,
    this.descriptionAr,
    this.descriptionNL,
    this.image,
    this.status,
    this.gtin,
    this.sku,
    this.brandName,
    this.brandNameAr,
    this.brandNameNL,
    this.batch,
    this.uniqueProductCode,
    this.expiryDate,
    this.packagingDate,
    this.quantity,
    this.gln,
    this.binLocation,
    this.palletId,
    this.serialNumber,
    this.manufectureDate,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.memberId,
    this.productId,
  });

  ProductOnPallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['nameAr'];
    nameNL = json['nameNL'];
    unit = json['unit'];
    size = json['size'];
    origin = json['origin'];
    countrySale = json['countrySale'];
    productType = json['productType'];
    packagingType = json['packagingType'];
    gpc = json['gpc'];
    price = json['price'];
    description = json['description'];
    descriptionAr = json['descriptionAr'];
    descriptionNL = json['descriptionNL'];
    image = json['image'];
    status = json['status'];
    gtin = json['gtin'];
    sku = json['sku'];
    brandName = json['brandName'];
    brandNameAr = json['brandNameAr'];
    brandNameNL = json['brandNameNL'];
    batch = json['batch'];
    uniqueProductCode = json['uniqueProductCode'];
    expiryDate = json['expiryDate'];
    packagingDate = json['packagingDate'];
    quantity = json['quantity'];
    gln = json['gln'];
    binLocation = json['binLocation'];
    palletId = json['palletId'];
    serialNumber = json['serialNumber'];
    manufectureDate = json['manufectureDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    categoryId = json['categoryId'];
    memberId = json['memberId'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['nameAr'] = this.nameAr;
    data['nameNL'] = this.nameNL;
    data['unit'] = this.unit;
    data['size'] = this.size;
    data['origin'] = this.origin;
    data['countrySale'] = this.countrySale;
    data['productType'] = this.productType;
    data['packagingType'] = this.packagingType;
    data['gpc'] = this.gpc;
    data['price'] = this.price;
    data['description'] = this.description;
    data['descriptionAr'] = this.descriptionAr;
    data['descriptionNL'] = this.descriptionNL;
    data['image'] = this.image;
    data['status'] = this.status;
    data['gtin'] = this.gtin;
    data['sku'] = this.sku;
    data['brandName'] = this.brandName;
    data['brandNameAr'] = this.brandNameAr;
    data['brandNameNL'] = this.brandNameNL;
    data['batch'] = this.batch;
    data['uniqueProductCode'] = this.uniqueProductCode;
    data['expiryDate'] = this.expiryDate;
    data['packagingDate'] = this.packagingDate;
    data['quantity'] = this.quantity;
    data['gln'] = this.gln;
    data['binLocation'] = this.binLocation;
    data['palletId'] = this.palletId;
    data['serialNumber'] = this.serialNumber;
    data['manufectureDate'] = this.manufectureDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['categoryId'] = this.categoryId;
    data['memberId'] = this.memberId;
    data['productId'] = this.productId;
    return data;
  }
}
