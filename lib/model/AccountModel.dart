class AccountModel {
  int? id;
  String? name;
  String? accountType;
  int? firmId;
  int? status;
  String? createdAt;
  String? updatedAt;

  AccountModel(
      {this.id,
      this.name,
      this.accountType,
      this.firmId,
      this.status,
      this.createdAt,
      this.updatedAt});

  AccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountType = json['account_type'];
    firmId = json['firm_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['account_type'] = this.accountType;
    data['firm_id'] = this.firmId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  @override
  String toString() {
    return "$name";
  }
}
