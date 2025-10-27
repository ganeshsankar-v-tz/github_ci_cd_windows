class AppHistoryModel {
  int? id;
  int? userId;
  String? module;
  String? action;
  String? databaseModel;
  String? details;
  String? createdAt;
  String? createdBy;
  String? role;

  AppHistoryModel({
    this.id,
    this.userId,
    this.module,
    this.action,
    this.databaseModel,
    this.details,
    this.createdAt,
    this.createdBy,
    this.role,
  });

  AppHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    module = json['module'];
    action = json['action'];
    databaseModel = json['Database_Model'];
    details = json['details'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['module'] = module;
    data['action'] = action;
    data['Database_Model'] = databaseModel;
    data['details'] = details;
    data['created_at'] = createdAt;
    data['created_by'] = createdBy;
    data['role'] = role;
    return data;
  }
}
