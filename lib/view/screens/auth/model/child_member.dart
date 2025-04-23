class ChildMember {
  String? id;
  String? memberId;
  String? userName;
  String? email;
  String? password;
  String? role;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? nfcNumber;
  String? nfcSearchToken;
  bool? isNFCEnabled;
  ParentUserData? parentUserData;
  String? gs1Userid;

  ChildMember({
    this.id,
    this.memberId,
    this.userName,
    this.email,
    this.password,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.nfcNumber,
    this.nfcSearchToken,
    this.isNFCEnabled,
    this.parentUserData,
    this.gs1Userid,
  });

  ChildMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    isActive = json['is_active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    nfcNumber = json['nfcNumber'];
    nfcSearchToken = json['nfcSearchToken'];
    isNFCEnabled = json['isNFCEnabled'];
    parentUserData =
        json['ParentUserData'] != null
            ? ParentUserData.fromJson(json['ParentUserData'])
            : null;
    gs1Userid = json['gs1Userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['userName'] = userName;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    data['is_active'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['nfcNumber'] = nfcNumber;
    data['nfcSearchToken'] = nfcSearchToken;
    data['isNFCEnabled'] = isNFCEnabled;
    if (parentUserData != null) {
      data['ParentUserData'] = parentUserData!.toJson();
    }
    data['gs1Userid'] = gs1Userid;
    return data;
  }
}

class ParentUserData {
  String? id;
  String? email;
  String? password;
  String? stackholderType;
  String? gs1CompanyPrefix;
  String? companyNameEnglish;
  String? companyNameArabic;
  String? contactPerson;
  String? companyLandline;
  String? mobileNo;
  String? extension;
  String? zipCode;
  String? website;
  String? gln;
  String? address;
  String? longitude;
  String? latitude;
  String? status;
  String? createdAt;
  String? updatedAt;

  ParentUserData({
    this.id,
    this.email,
    this.password,
    this.stackholderType,
    this.gs1CompanyPrefix,
    this.companyNameEnglish,
    this.companyNameArabic,
    this.contactPerson,
    this.companyLandline,
    this.mobileNo,
    this.extension,
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

  ParentUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    stackholderType = json['stackholderType'];
    gs1CompanyPrefix = json['gs1CompanyPrefix'];
    companyNameEnglish = json['companyNameEnglish'];
    companyNameArabic = json['companyNameArabic'];
    contactPerson = json['contactPerson'];
    companyLandline = json['companyLandline'];
    mobileNo = json['mobileNo'];
    extension = json['extension'];
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
    data['email'] = email;
    data['password'] = password;
    data['stackholderType'] = stackholderType;
    data['gs1CompanyPrefix'] = gs1CompanyPrefix;
    data['companyNameEnglish'] = companyNameEnglish;
    data['companyNameArabic'] = companyNameArabic;
    data['contactPerson'] = contactPerson;
    data['companyLandline'] = companyLandline;
    data['mobileNo'] = mobileNo;
    data['extension'] = extension;
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
