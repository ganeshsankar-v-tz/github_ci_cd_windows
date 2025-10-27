class NewUnitModel {
  int? id;
  String? unitName;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? decimal;
  String? activeStatus;

  NewUnitModel(
      {this.id,
      this.unitName,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.decimal,
      this.activeStatus});

  NewUnitModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unit_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    decimal = json['decimal'];
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unit_name'] = this.unitName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['decimal'] = this.decimal;
    data['active_status'] = this.activeStatus;
    return data;
  }

  @override
  String toString() {
    return '$unitName';
  }
}
