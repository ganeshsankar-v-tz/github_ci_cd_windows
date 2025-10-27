class WindingYarnConversationModel {
  int? id;
  int? fromYarnId;
  dynamic fromQty;
  int? toYarnId;
  dynamic toQty;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;
  String? creatorName;
  String? toYarnName;
  String? fromYarnName;
  String? unitName;

  WindingYarnConversationModel(
      {this.id,
      this.fromYarnId,
      this.fromQty,
      this.toYarnId,
      this.toQty,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.creatorName,
      this.toYarnName,
      this.unitName,
      this.fromYarnName});

  WindingYarnConversationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromYarnId = json['from_yarn_id'];
    fromQty = json['from_qty'];
    toYarnId = json['to_yarn_id'];
    toQty = json['to_qty'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    creatorName = json['creator_name'];
    toYarnName = json['to_yarn_name'];
    unitName = json['unit_name'];
    fromYarnName = json['from_yarn_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_yarn_id'] = this.fromYarnId;
    data['from_qty'] = this.fromQty;
    data['to_yarn_id'] = this.toYarnId;
    data['to_qty'] = this.toQty;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['creator_name'] = this.creatorName;
    data['to_yarn_name'] = this.toYarnName;
    data['unit_name'] = this.unitName;
    data['from_yarn_name'] = this.fromYarnName;
    return data;
  }

  @override
  String toString() {
    return "${fromYarnName}";
  }
}
