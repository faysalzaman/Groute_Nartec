class GS1Product {
  String? id;
  String? userId;
  String? gcpGLNID;
  String? importCode;
  String? productnameenglish;
  String? productnamearabic;
  String? brandName;
  String? productType;
  String? origin;
  String? packagingType;
  String? mnfCode;
  String? mnfGLN;
  String? provGLN;
  String? unit;
  String? size;
  String? frontImage;
  String? backImage;
  String? childProduct;
  String? quantity;
  String? barcode;
  String? gpc;
  String? gpcCode;
  String? countrySale;
  String? hSCODES;
  String? hsDescription;
  String? gcpType;
  String? prodLang;
  String? detailsPage;
  String? detailsPageAr;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? memberID;
  int? adminId;
  String? saveAs;
  String? gtinType;
  String? productUrl;
  String? productLinkUrl;
  String? brandNameAr;
  String? digitalInfoType;
  String? readyForGepir;
  int? gepirPosted;
  String? image1;
  String? image2;
  String? image3;
  String? gpcType;

  GS1Product({
    this.id,
    this.userId,
    this.gcpGLNID,
    this.importCode,
    this.productnameenglish,
    this.productnamearabic,
    this.brandName,
    this.productType,
    this.origin,
    this.packagingType,
    this.mnfCode,
    this.mnfGLN,
    this.provGLN,
    this.unit,
    this.size,
    this.frontImage,
    this.backImage,
    this.childProduct,
    this.quantity,
    this.barcode,
    this.gpc,
    this.gpcCode,
    this.countrySale,
    this.hSCODES,
    this.hsDescription,
    this.gcpType,
    this.prodLang,
    this.detailsPage,
    this.detailsPageAr,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.memberID,
    this.adminId,
    this.saveAs,
    this.gtinType,
    this.productUrl,
    this.productLinkUrl,
    this.brandNameAr,
    this.digitalInfoType,
    this.readyForGepir,
    this.gepirPosted,
    this.image1,
    this.image2,
    this.image3,
    this.gpcType,
  });

  GS1Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    gcpGLNID = json['gcpGLNID'];
    importCode = json['import_code'];
    productnameenglish = json['productnameenglish'];
    productnamearabic = json['productnamearabic'];
    brandName = json['BrandName'];
    productType = json['ProductType'];
    origin = json['Origin'];
    packagingType = json['PackagingType'];
    mnfCode = json['MnfCode'];
    mnfGLN = json['MnfGLN'];
    provGLN = json['ProvGLN'];
    unit = json['unit'];
    size = json['size'];
    frontImage = json['front_image'];
    backImage = json['back_image'];
    childProduct = json['childProduct'];
    quantity = json['quantity'];
    barcode = json['barcode'];
    gpc = json['gpc'];
    gpcCode = json['gpc_code'];
    countrySale = json['countrySale'];
    hSCODES = json['HSCODES'];
    hsDescription = json['HsDescription'];
    gcpType = json['gcp_type'];
    prodLang = json['prod_lang'];
    detailsPage = json['details_page'];
    detailsPageAr = json['details_page_ar'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    memberID = json['memberID'];
    adminId = json['admin_id'];
    saveAs = json['save_as'];
    gtinType = json['gtin_type'];
    productUrl = json['product_url'];
    productLinkUrl = json['product_link_url'];
    brandNameAr = json['BrandNameAr'];
    digitalInfoType = json['digitalInfoType'];
    readyForGepir = json['readyForGepir'];
    gepirPosted = json['gepirPosted'];
    image1 = json['image_1'];
    image2 = json['image_2'];
    image3 = json['image_3'];
    gpcType = json['gpc_type'];
    productType = json['product_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['gcpGLNID'] = gcpGLNID;
    data['import_code'] = importCode;
    data['productnameenglish'] = productnameenglish;
    data['productnamearabic'] = productnamearabic;
    data['BrandName'] = brandName;
    data['ProductType'] = productType;
    data['Origin'] = origin;
    data['PackagingType'] = packagingType;
    data['MnfCode'] = mnfCode;
    data['MnfGLN'] = mnfGLN;
    data['ProvGLN'] = provGLN;
    data['unit'] = unit;
    data['size'] = size;
    data['front_image'] = frontImage;
    data['back_image'] = backImage;
    data['childProduct'] = childProduct;
    data['quantity'] = quantity;
    data['barcode'] = barcode;
    data['gpc'] = gpc;
    data['gpc_code'] = gpcCode;
    data['countrySale'] = countrySale;
    data['HSCODES'] = hSCODES;
    data['HsDescription'] = hsDescription;
    data['gcp_type'] = gcpType;
    data['prod_lang'] = prodLang;
    data['details_page'] = detailsPage;
    data['details_page_ar'] = detailsPageAr;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['memberID'] = memberID;
    data['admin_id'] = adminId;
    data['save_as'] = saveAs;
    data['gtin_type'] = gtinType;
    data['product_url'] = productUrl;
    data['product_link_url'] = productLinkUrl;
    data['BrandNameAr'] = brandNameAr;
    data['digitalInfoType'] = digitalInfoType;
    data['readyForGepir'] = readyForGepir;
    data['gepirPosted'] = gepirPosted;
    data['image_1'] = image1;
    data['image_2'] = image2;
    data['image_3'] = image3;
    data['gpc_type'] = gpcType;
    data['product_type'] = productType;
    return data;
  }
}
