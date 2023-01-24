class Room {
  Room({
    this.roomId = "",
    this.roomName = "",
    this.roomAlias = "",
    this.floorId = "",
    this.floorName = "",
    this.buildingId = "",
    this.buildingName = "",
    this.roomType = "",
    this.minCapacity = "",
    this.maxCapacity = "",
    this.maxBookingDuration = "",
    this.coverPhoto = "",
    this.availability = "INACTIVE",
    this.areaPhoto,
    this.defaultFacilities,
    this.prohibitedFacilities,
    this.isCollapsed = false,
  });

  String roomId;
  String roomName;
  String roomAlias;
  String floorId;
  String floorName;
  String buildingId;
  String buildingName;
  String roomType;
  String minCapacity;
  String maxCapacity;
  String maxBookingDuration;
  String coverPhoto;
  String availability;
  List? areaPhoto;
  List? defaultFacilities;
  List? prohibitedFacilities;
  bool isCollapsed;

  Map<String, dynamic> toJson() => {
        '"RoomID"': '"$roomId"',
        '"RoomName"': '"$roomName"',
        '"RoomAlias"': '"$roomAlias"',
        '"AreaID"': '"$floorId"',
        '"AreaName"': '"$floorName"',
        '"BuildingID"': '"$buildingId"',
        '"BuildingName"': '"$buildingName"',
        '"RoomType"': '"$roomType"',
        '"MinCapacity"': '"$minCapacity"',
        '"MaxCapacity"': '"$maxCapacity"',
        '"MaxBookingDuration"': '"$maxBookingDuration"',
        '"CoverPhoto"': '"$coverPhoto"',
        '"AreaPhoto"': "$areaPhoto",
        '"DefaultFacilities"': '$defaultFacilities',
        '"Prohibited"': '$prohibitedFacilities',
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
