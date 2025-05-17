class ContainerResponseModel {
  final String level;
  final String ssccNo;
  final ContainerData container;
  final String message;

  ContainerResponseModel({
    required this.level,
    required this.ssccNo,
    required this.container,
    required this.message,
  });

  factory ContainerResponseModel.fromJson(Map<String, dynamic> json) {
    return ContainerResponseModel(
      level: json['level'],
      ssccNo: json['ssccNo'],
      container: ContainerData.fromJson(json['container']),
      message: json['message'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'ssccNo': ssccNo,
      'container': container.toJson(),
      'message': message,
    };
  }
}

class ContainerData {
  final String id;
  final String ssccNo;
  final String containerCode;
  final String description;
  final String memberId;
  final String binLocationId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<Pallet> pallets;

  ContainerData({
    required this.id,
    required this.ssccNo,
    required this.containerCode,
    required this.description,
    required this.memberId,
    required this.binLocationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.pallets,
  });

  factory ContainerData.fromJson(Map<String, dynamic> json) {
    return ContainerData(
      id: json['id'],
      ssccNo: json['SSCCNo'],
      containerCode: json['containerCode'],
      description: json['description'],
      memberId: json['memberId'],
      binLocationId: json['binLocationId'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      pallets:
          (json['pallets'] as List<dynamic>)
              .map((e) => Pallet.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'SSCCNo': ssccNo,
      'containerCode': containerCode,
      'description': description,
      'memberId': memberId,
      'binLocationId': binLocationId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'pallets': pallets.map((e) => e.toJson()).toList(),
    };
  }
}

class Pallet {
  final String id;
  final String ssccNo;
  final String description;
  final String memberId;
  final String binLocationId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String containerId;
  final List<SSCCPackage> ssccPackages;

  Pallet({
    required this.id,
    required this.ssccNo,
    required this.description,
    required this.memberId,
    required this.binLocationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.containerId,
    required this.ssccPackages,
  });

  factory Pallet.fromJson(Map<String, dynamic> json) {
    return Pallet(
      id: json['id'],
      ssccNo: json['SSCCNo'],
      description: json['description'],
      memberId: json['memberId'],
      binLocationId: json['binLocationId'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      containerId: json['containerId'] ?? '',
      ssccPackages:
          (json['ssccPackages'] as List<dynamic>)
              .map((e) => SSCCPackage.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'SSCCNo': ssccNo,
      'description': description,
      'memberId': memberId,
      'binLocationId': binLocationId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'containerId': containerId,
      'ssccPackages': ssccPackages.map((e) => e.toJson()).toList(),
    };
  }
}

class SSCCPackage {
  final String id;
  final String ssccNo;
  final String packagingType;
  final String description;
  final String memberId;
  final String binLocationId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? palletId;
  final String? containerId;
  final List<PackageDetail> details;

  SSCCPackage({
    required this.id,
    required this.ssccNo,
    required this.packagingType,
    required this.description,
    required this.memberId,
    required this.binLocationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.palletId,
    required this.containerId,
    required this.details,
  });

  factory SSCCPackage.fromJson(Map<String, dynamic> json) {
    return SSCCPackage(
      id: json['id'],
      ssccNo: json['SSCCNo'],
      packagingType: json['packagingType'],
      description: json['description'],
      memberId: json['memberId'],
      binLocationId: json['binLocationId'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      palletId: json['palletId'],
      containerId: json['containerId'],
      details:
          (json['details'] as List<dynamic>)
              .map((e) => PackageDetail.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'SSCCNo': ssccNo,
      'packagingType': packagingType,
      'description': description,
      'memberId': memberId,
      'binLocationId': binLocationId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'palletId': palletId,
      'containerId': containerId,
      'details': details.map((e) => e.toJson()).toList(),
    };
  }
}

class PackageDetail {
  final String id;
  final String masterPackagingId;
  final String? binLocationId;
  final String serialGTIN;
  final String serialNo;
  final List<dynamic> includedGTINPackages;

  PackageDetail({
    required this.id,
    required this.masterPackagingId,
    this.binLocationId,
    required this.serialGTIN,
    required this.serialNo,
    required this.includedGTINPackages,
  });

  factory PackageDetail.fromJson(Map<String, dynamic> json) {
    return PackageDetail(
      id: json['id'],
      masterPackagingId: json['masterPackagingId'],
      binLocationId: json['binLocationId'],
      serialGTIN: json['serialGTIN'],
      serialNo: json['serialNo'],
      includedGTINPackages: json['includedGTINPackages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'masterPackagingId': masterPackagingId,
      'binLocationId': binLocationId,
      'serialGTIN': serialGTIN,
      'serialNo': serialNo,
      'includedGTINPackages': includedGTINPackages,
    };
  }
}
