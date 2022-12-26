class Amenities {
  Amenities({
    this.amenitiesId,
    this.amenitiesName,
    this.qty = 0,
    this.photo = "",
    this.isProhibited = false,
    this.defaultAmount = 0,
  });

  String? amenitiesId;
  String? amenitiesName;
  String? photo;
  int? qty;
  bool? isProhibited;
  int? defaultAmount;

  Amenities.fromJSon(Map<String, dynamic> json)
      : amenitiesName = json['AmenitiesName'],
        amenitiesId = json['AmenitisID'];

  Map<String, dynamic> toJson() => {
        'AmenitiesID': amenitiesId ?? "",
        // 'AmenitiesName': amenitiesName ?? "",
        'Amount': qty
      };

  @override
  String toString() {
    // TODO: implement toString
    return "{AmenitiesID : $amenitiesId, AmenitiesName : $amenitiesName, Qty : $qty, ImageURL : $photo, isProhibited: $isProhibited, default: $defaultAmount}";
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
        'FoodAmenitiesID': amenitiesId ?? "",
        // 'AmenitiesName': amenitiesName ?? "",
        'Amount': qty
      };

  @override
  String toString() {
    // TODO: implement toString
    return "{FoodAmenitiesId : $amenitiesId, FoodAmenitiesName : $amenitiesName, Amount : $qty, Photo : $photo}";
  }
}
