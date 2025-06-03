class CustomerProfileModel {
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
  String? logo;
  String? memberId;
  String? createdAt;
  String? updatedAt;

  CustomerProfileModel({
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
    this.logo,
    this.memberId,
    this.createdAt,
    this.updatedAt,
  });

  CustomerProfileModel.fromJson(Map<String, dynamic> json) {
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
    logo = json['logo'];
    memberId = json['memberId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['email'] = this.email;
    data['password'] = this.password;
    data['stackholderType'] = this.stackholderType;
    data['gs1CompanyPrefix'] = this.gs1CompanyPrefix;
    data['companyNameEnglish'] = this.companyNameEnglish;
    data['companyNameArabic'] = this.companyNameArabic;
    data['contactPerson'] = this.contactPerson;
    data['companyLandline'] = this.companyLandline;
    data['mobileNo'] = this.mobileNo;
    data['extension'] = this.extensions;
    data['zipCode'] = this.zipCode;
    data['website'] = this.website;
    data['gln'] = this.gln;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['status'] = this.status;
    data['logo'] = this.logo;
    data['memberId'] = this.memberId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
