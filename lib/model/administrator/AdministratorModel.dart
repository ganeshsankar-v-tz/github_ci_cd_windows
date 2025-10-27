class AdministratorModel {
  int? id;
  String? userName;
  String? userType;
  String? isActive;

  AdministratorModel({
    this.id,
    this.userName,
    this.userType,
    this.isActive,
  });

  AdministratorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    userType = json['user_type'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_name'] = userName;
    data['user_type'] = userType;
    data['is_active'] = isActive;
    return data;
  }

  @override
  String toString() {
    return "$userName";
  }
}
