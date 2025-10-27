class AreaModel {
  int? id;
  String? name;
  int? cityId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? pincode;
  String? cityName;

  AreaModel(
      {this.id,
      this.name,
      this.cityId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.pincode,
      this.cityName});

  AreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cityId = json['city_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pincode = json['pincode'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['city_id'] = this.cityId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['pincode'] = this.pincode;
    data['city_name'] = this.cityName;
    return data;
  }

  @override
  String toString() {
    return '$name';
  }
}
