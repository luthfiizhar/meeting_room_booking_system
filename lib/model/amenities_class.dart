class Amenities {
  Amenities({
    this.amenitiesId = "",
    this.amenitiesName = "",
    this.qty = 0,
    this.photo = "",
    this.isProhibited = false,
    this.defaultAmount = 0,
    this.roomAmenitiesId = "",
    this.type = "",
    this.typeName = "",
    this.isAvailableToUser = true,
  });

  String? amenitiesId;
  String? amenitiesName;
  String? photo;
  int? qty;
  bool? isProhibited;
  int? defaultAmount;
  String? roomAmenitiesId;
  String? type;
  String? typeName;
  bool? isAvailableToUser;

  Amenities.fromJSon(Map<String, dynamic> json)
      : amenitiesName = json['AmenitiesName'],
        amenitiesId = json['AmenitisID'];

  Map<String, dynamic> toJson() => {
        '"AmenitiesID"': '"$amenitiesId"',
        '"AmenitiesName"': '"$amenitiesName"',
        '"Amount"': '"$qty"',
        '"ImageURL"': '"$photo"',
        '"DefaultAmount"': '"$defaultAmount"',
        '"isProhibited"': '$isProhibited',
        '"RoomAmenitiesID"': '"$roomAmenitiesId"'
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class FoodAmenities {
  FoodAmenities({
    this.amenitiesId,
    this.amenitiesName,
    this.qty = 0,
    this.photo = "",
  });

  String? amenitiesId;
  String? amenitiesName;
  String? photo;
  int? qty;

  FoodAmenities.fromJSon(Map<String, dynamic> json)
      : amenitiesName = json['FoodAmenitiesName'],
        amenitiesId = json['FoodAmenitisID'];

  Map<String, dynamic> toJson() => {
        '"FoodAmenitiesID"': '"$amenitiesId"',
        '"AmenitiesName"': '"$amenitiesName"',
        // '"DefaultAmount"': '"0"',
        '"Amount"': '"$qty"'
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
