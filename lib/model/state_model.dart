class StateModel {
  int? id;
  String? name;
  int? countryId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? countryName;

  StateModel(
      {this.id,
      this.name,
      this.countryId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.countryName});

  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['country_name'] = this.countryName;
    return data;
  }

  @override
  String toString() {
    return '$name';
  }
}
