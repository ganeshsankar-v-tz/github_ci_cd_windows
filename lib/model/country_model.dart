class Country_Model {
  int? id;
  String? name;
  Null? countryId;
  int? status;
  String? createdAt;
  String? updatedAt;

  Country_Model(
      {this.id,
      this.name,
      this.countryId,
      this.status,
      this.createdAt,
      this.updatedAt});

  Country_Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  @override
  String toString() {
    return '$name';
  }
}
