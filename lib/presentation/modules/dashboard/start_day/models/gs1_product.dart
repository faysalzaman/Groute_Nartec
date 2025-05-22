import 'dart:convert';

class Product {
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
  double? price;
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
  List<String>? binLocation;
  String? createdAt;
  String? updatedAt;
  String? categoryId;
  String? memberId;
  dynamic category;

  // Legacy fields for backward compatibility
  String? userId;
  String? gcpGLNID;
  String? importCode;
  String? productnameenglish;
  String? productnamearabic;
  String? mnfCode;
  String? mnfGLN;
  String? provGLN;
  String? frontImage;
  String? backImage;
  String? childProduct;
  String? barcode;
  String? gpcCode;
  String? hSCODES;
  String? hsDescription;
  String? gcpType;
  String? prodLang;
  String? detailsPage;
  String? detailsPageAr;
  int? status_int;
  String? deletedAt;
  String? memberID;
  int? adminId;
  String? saveAs;
  String? gtinType;
  String? productUrl;
  String? productLinkUrl;
  String? digitalInfoType;
  String? readyForGepir;
  int? gepirPosted;
  String? image1;
  String? image2;
  String? image3;
  String? gpcType;

  Product({
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
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.memberId,
    this.category,
    // Legacy fields
    this.userId,
    this.gcpGLNID,
    this.importCode,
    this.productnameenglish,
    this.productnamearabic,
    this.mnfCode,
    this.mnfGLN,
    this.provGLN,
    this.frontImage,
    this.backImage,
    this.childProduct,
    this.barcode,
    this.gpcCode,
    this.hSCODES,
    this.hsDescription,
    this.gcpType,
    this.prodLang,
    this.detailsPage,
    this.detailsPageAr,
    this.status_int,
    this.deletedAt,
    this.memberID,
    this.adminId,
    this.saveAs,
    this.gtinType,
    this.productUrl,
    this.productLinkUrl,
    this.digitalInfoType,
    this.readyForGepir,
    this.gepirPosted,
    this.image1,
    this.image2,
    this.image3,
    this.gpcType,
  });

  Product.fromJson(Map<String, dynamic> json) {
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
    price = json['price']?.toDouble();
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
    if (json['binLocation'] != null) {
      if (json['binLocation'] is List) {
        binLocation = List<String>.from(json['binLocation']);
      } else if (json['binLocation'] is String) {
        try {
          binLocation = List<String>.from(jsonDecode(json['binLocation']));
        } catch (e) {
          binLocation = [json['binLocation']];
        }
      }
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    categoryId = json['categoryId'];
    memberId = json['memberId'];
    category = json['category'];

    // Legacy field mapping for backward compatibility
    userId = json['user_id'];
    gcpGLNID = json['gcpGLNID'];
    importCode = json['import_code'];
    productnameenglish = json['productnameenglish'] ?? name;
    productnamearabic = json['productnamearabic'] ?? nameAr;
    barcode = json['barcode'] ?? gtin;
    frontImage = json['front_image'] ?? image;
    backImage = json['back_image'];
    gpcCode = json['gpc_code'];
    detailsPage = json['details_page'];
    detailsPageAr = json['details_page_ar'];
    status_int = json['status'] is int ? json['status'] : null;
    deletedAt = json['deleted_at'];
    memberID = json['memberID'] ?? memberId;
    adminId = json['admin_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nameAr'] = nameAr;
    data['nameNL'] = nameNL;
    data['unit'] = unit;
    data['size'] = size;
    data['origin'] = origin;
    data['countrySale'] = countrySale;
    data['productType'] = productType;
    data['packagingType'] = packagingType;
    data['gpc'] = gpc;
    data['price'] = price;
    data['description'] = description;
    data['descriptionAr'] = descriptionAr;
    data['descriptionNL'] = descriptionNL;
    data['image'] = image;
    data['status'] = status;
    data['gtin'] = gtin;
    data['sku'] = sku;
    data['brandName'] = brandName;
    data['brandNameAr'] = brandNameAr;
    data['brandNameNL'] = brandNameNL;
    data['batch'] = batch;
    data['uniqueProductCode'] = uniqueProductCode;
    data['expiryDate'] = expiryDate;
    data['packagingDate'] = packagingDate;
    data['quantity'] = quantity;
    data['gln'] = gln;
    data['binLocation'] = binLocation;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['categoryId'] = categoryId;
    data['memberId'] = memberId;
    data['category'] = category;
    return data;
  }
}
