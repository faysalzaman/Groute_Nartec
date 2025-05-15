part of 'driver_model.dart';

class Route {
  String? id;
  String? nameEn;
  String? nameAr;
  String? nameNl;
  String? descriptionEn;
  String? descriptionAr;
  String? descriptionNl;
  List<Coordinate>? points;
  String? radius;
  String? glnNumber;
  String? createdAt;
  String? updatedAt;
  String? memberId;

  Route({
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

  Route.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
    nameNl = json['nameNl'];
    descriptionEn = json['descriptionEn'];
    descriptionAr = json['descriptionAr'];
    descriptionNl = json['descriptionNl'];
    radius = json['radius'];
    glnNumber = json['glnNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    memberId = json['memberId'];

    if (json['points'] != null) {
      points = <Coordinate>[];
      dynamic decodedData;
      try {
        if (json['points'] is String) {
          decodedData = jsonDecode(json['points']);
        } else {
          decodedData = json['points'];
        }
      } catch (e) {
        // Handle decoding error if necessary, maybe log it differently
        decodedData = null;
      }

      if (decodedData is List) {
        for (final item in decodedData) {
          if (item is Map<String, dynamic>) {
            try {
              points!.add(Coordinate.fromJson(item));
            } catch (e) {
              // Handle coordinate parsing error if necessary
            }
          } else {
            // Handle non-map items if necessary
          }
        }
      } else if (decodedData != null) {
        // Handle cases where points data is not a list
      }
    } else {
      points = null;
    }
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
    data['radius'] = radius;
    data['glnNumber'] = glnNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['memberId'] = memberId;
    if (points != null) {
      // Ensure points are encoded back to a JSON string if needed when sending data
      data['points'] = jsonEncode(points!.map((e) => e.toJson()).toList());
    }
    return data;
  }
}
