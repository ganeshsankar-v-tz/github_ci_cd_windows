class NewColorModel {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? llName;
  String? hexCode;
  String? isActive;

  NewColorModel(
      {this.id,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.llName,
      this.hexCode,
      this.isActive});

  NewColorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    llName = json['ll_name'];
    hexCode = json['hex_code'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['ll_name'] = this.llName;
    data['hex_code'] = this.hexCode;
    data['is_active'] = this.isActive;
    return data;
  }

  @override
  String toString() {
    return '$name';
  }
}
