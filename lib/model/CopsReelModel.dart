class CopsReelModel {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic weight;
  String? isActive;
  String? details;
  String? type;

  CopsReelModel(
      {this.id,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.weight,
      this.isActive,
      this.details,
      this.type});

  CopsReelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    weight = json['weight'];
    isActive = json['is_active'];
    details = json['details'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['weight'] = this.weight;
    data['is_active'] = this.isActive;
    data['details'] = this.details;
    data['type'] = this.type;
    return data;
  }
}
