class WarpingWagesConfigModel {
  int? id;
  int? yarnId;
  int? dftMeter;
  int? endsFrom;
  int? endsTo;
  num? wages;
  String? calcType;
  int? twistingWpu;
  int? warperNo;
  String? wagesFixedTo;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic createdBy;
  String? yarnName;
  String? creatorName;

  WarpingWagesConfigModel(
      {this.id,
        this.yarnId,
        this.dftMeter,
        this.endsFrom,
        this.endsTo,
        this.wages,
        this.calcType,
        this.twistingWpu,
        this.warperNo,
        this.wagesFixedTo,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.yarnName,
        this.creatorName});

  WarpingWagesConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnId = json['yarn_id'];
    dftMeter = json['dft_meter'];
    endsFrom = json['ends_from'];
    endsTo = json['ends_to'];
    wages = json['wages'];
    calcType = json['calc_type'];
    twistingWpu = json['twisting_wpu'];
    warperNo = json['warper_no'];
    wagesFixedTo = json['wages_fixed_to'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    yarnName = json['yarn_name'];
    creatorName = json['creator_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yarn_id'] = this.yarnId;
    data['dft_meter'] = this.dftMeter;
    data['ends_from'] = this.endsFrom;
    data['ends_to'] = this.endsTo;
    data['wages'] = this.wages;
    data['calc_type'] = this.calcType;
    data['twisting_wpu'] = this.twistingWpu;
    data['warper_no'] = this.warperNo;
    data['wages_fixed_to'] = this.wagesFixedTo;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['yarn_name'] = this.yarnName;
    data['creator_name'] = this.creatorName;
    return data;
  }
}
