class WarpDesignSheetModel {
  int? id;
  String? designName;
  String? yarnEndDetails;
  String? hint;
  String? yarnGroupDetails;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? activeStatus;

  WarpDesignSheetModel(
      {this.id,
      this.designName,
      this.yarnEndDetails,
      this.hint,
      this.yarnGroupDetails,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.activeStatus});

  WarpDesignSheetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    designName = json['design_name'];
    yarnEndDetails = json['yarn_end_details'];
    hint = json['hint'];
    yarnGroupDetails = json['yarn_group_details'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    activeStatus = json['active_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['design_name'] = this.designName;
    data['yarn_end_details'] = this.yarnEndDetails;
    data['hint'] = this.hint;
    data['yarn_group_details'] = this.yarnGroupDetails;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['active_status'] = this.activeStatus;
    return data;
  }

  @override
  String toString() {
    return '$designName';
  }
}
