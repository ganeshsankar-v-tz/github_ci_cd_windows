class CityModel {
  int? id;
  String? name;
  int? stateId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? stateName;

  CityModel(
      {this.id,
      this.name,
      this.stateId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.stateName});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['state_name'] = this.stateName;
    return data;
  }

  @override
  String toString() {
    return '$name';
  }
}
