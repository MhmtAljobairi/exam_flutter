class Address {
  late double latitude;
  late double longitude;
  late String country;
  late String city;
  late String area;
  late String street;
  late String buildingNo = "";

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "country": country,
        "city": city,
        "area": area,
        "street": street,
        "building_no": buildingNo,
      };
}
