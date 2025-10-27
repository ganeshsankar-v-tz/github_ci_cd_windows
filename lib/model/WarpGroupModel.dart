class WarpGroupModel {
  int? id;
  String? groupName;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? isActive;

  WarpGroupModel(
      {this.id,
      this.groupName,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.isActive});

  WarpGroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['group_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_name'] = this.groupName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_active'] = this.isActive;
    return data;
  }

  @override
  String toString() {
    return '$groupName';
  }
}
