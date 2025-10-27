// //AccountTypeModel

class AccountTypeModel {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  String? alias;
  String? nog;
  String? accountGroup;
  String? creatorName;

  AccountTypeModel(
      {this.id,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.alias,
      this.nog,
      this.accountGroup,
      this.creatorName});

  AccountTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    alias = json['alias'];
    nog = json['nog'];
    accountGroup = json['account_group'];
    creatorName = json['creator_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['alias'] = this.alias;
    data['nog'] = this.nog;
    data['account_group'] = this.accountGroup;
    data['creator_name'] = this.creatorName;
    return data;
  }

  @override
  String toString() {
    return '$name';
  }
}
