class BinLocationModel {
  String id;
  String groupWarehouse;
  String zones;
  String binNumber;
  String zoneType;
  int binHeight;
  int binRow;
  int binWidth;
  int binTotalSize;
  String binType;
  String gln;
  String sgln;
  String zoned;
  String zoneCode;
  String zoneName;
  int minimum;
  int maximum;
  int availableQty;
  String longitude;
  String latitude;
  String memberId;
  DateTime createdAt;
  DateTime updatedAt;

  BinLocationModel({
    required this.id,
    required this.groupWarehouse,
    required this.zones,
    required this.binNumber,
    required this.zoneType,
    required this.binHeight,
    required this.binRow,
    required this.binWidth,
    required this.binTotalSize,
    required this.binType,
    required this.gln,
    required this.sgln,
    required this.zoned,
    required this.zoneCode,
    required this.zoneName,
    required this.minimum,
    required this.maximum,
    required this.availableQty,
    required this.longitude,
    required this.latitude,
    required this.memberId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BinLocationModel.fromJson(Map<String, dynamic> json) {
    return BinLocationModel(
      id: json['id'],
      groupWarehouse: json['groupWarehouse'],
      zones: json['zones'],
      binNumber: json['binNumber'],
      zoneType: json['zoneType'],
      binHeight: json['binHeight'],
      binRow: json['binRow'],
      binWidth: json['binWidth'],
      binTotalSize: json['binTotalSize'],
      binType: json['binType'],
      gln: json['gln'],
      sgln: json['sgln'],
      zoned: json['zoned'],
      zoneCode: json['zoneCode'],
      zoneName: json['zoneName'],
      minimum: json['minimum'],
      maximum: json['maximum'],
      availableQty: json['availableQty'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      memberId: json['memberId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
