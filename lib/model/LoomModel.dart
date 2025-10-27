class LoomModel {
  int? id;
  int? weaverId;
  int? weavNo;
  String? subWeaverNo;
  String? introDate;
  String? weeklyInwardDay;
  String? details;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? activeStatus;
  String? llName;
  String? currentStatus;
  int? productId;
  String? productName;

  LoomModel({
    this.id,
    this.weaverId,
    this.introDate,
    this.weavNo,
    this.weeklyInwardDay,
    this.details,
    this.status,
    this.subWeaverNo,
    this.createdAt,
    this.updatedAt,
    this.activeStatus,
    this.llName,
    this.currentStatus,
    this.productId,
    this.productName,
  });

  LoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weaverId = json['weaver_id'];
    weavNo = json['weav_no'];
    introDate = json['intro_date'];
    weeklyInwardDay = json['weekly_inward_day'];
    details = json['details'];
    status = json['status'];
    subWeaverNo = json['sub_weaver_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    activeStatus = json['active_status'];
    llName = json['ll_name'];
    currentStatus = json['current_status'];
    productId = json['product_id'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weaver_id'] = weaverId;
    data['weav_no'] = weavNo;
    data['intro_date'] = introDate;
    data['weekly_inward_day'] = weeklyInwardDay;
    data['details'] = details;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['active_status'] = activeStatus;
    data['ll_name'] = llName;
    data['current_status'] = currentStatus;
    data['sub_weaver_no'] = subWeaverNo;
    data['product_name'] = productName;
    data['product_id'] = productId;
    return data;
  }

  @override
  String toString() {
    return '$subWeaverNo';
  }
}
