import 'dart:convert';

class ViewAssignedRouteModel {
  String? id;
  String? nameEn;
  String? nameAr;
  String? nameNl;
  String? descriptionEn;
  String? descriptionAr;
  String? descriptionNl;
  String? points;
  num? radius;
  String? glnNumber;
  String? createdAt;
  String? updatedAt;
  String? memberId;

  ViewAssignedRouteModel({
    this.id,
    this.nameEn,
    this.nameAr,
    this.nameNl,
    this.descriptionEn,
    this.descriptionAr,
    this.descriptionNl,
    this.points,
    this.radius,
    this.glnNumber,
    this.createdAt,
    this.updatedAt,
    this.memberId,
  });

  ViewAssignedRouteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
    nameNl = json['nameNl'];
    descriptionEn = json['descriptionEn'];
    descriptionAr = json['descriptionAr'];
    descriptionNl = json['descriptionNl'];
    points = json['points'];
    radius = json['radius'];
    glnNumber = json['glnNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    memberId = json['memberId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nameEn'] = nameEn;
    data['nameAr'] = nameAr;
    data['nameNl'] = nameNl;
    data['descriptionEn'] = descriptionEn;
    data['descriptionAr'] = descriptionAr;
    data['descriptionNl'] = descriptionNl;
    data['points'] = points;
    data['radius'] = radius;
    data['glnNumber'] = glnNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['memberId'] = memberId;
    return data;
  }

  // Helper method to get parsed points
  List<RoutePoint> getParsedPoints() {
    if (points == null || points!.isEmpty) return [];

    try {
      final List<dynamic> pointsList = json.decode(points!);
      return pointsList.map((point) => RoutePoint.fromJson(point)).toList();
    } catch (e) {
      return [];
    }
  }
}

class RoutePoint {
  final double lat;
  final double lng;

  RoutePoint({required this.lat, required this.lng});

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}
