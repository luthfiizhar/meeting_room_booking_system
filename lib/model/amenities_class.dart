class Amenities {
  Amenities({
    this.amenitiesId,
    this.amenitiesName,
    this.qty,
  });

  String? amenitiesId;
  String? amenitiesName;
  int? qty;

  Amenities.fromJSon(Map<String, dynamic> json)
      : amenitiesName = json['AmenitiesName'],
        amenitiesId = json['AmenitisID'];

  Map<String, dynamic> toJson() => {
        'AmenitiesID': amenitiesId ?? "",
        'AmenitiesName': amenitiesName ?? "",
        'Qty': qty
      };
}
