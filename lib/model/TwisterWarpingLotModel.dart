class TwisterWarpingLotModel {
  int? id;
  int? warperId;
  String? lot;
  String? recoredNo;
  int? firmId;
  int? accountTypeId;
  String? transactionType;
  String? details;
  int? status;
  String? createdAt;
  String? updatedAt;

  TwisterWarpingLotModel(
      {this.id,
      this.warperId,
      this.lot,
      this.recoredNo,
      this.firmId,
      this.accountTypeId,
      this.transactionType,
      this.details,
      this.status,
      this.createdAt,
      this.updatedAt});

  TwisterWarpingLotModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warperId = json['warper_id'];
    lot = json['lot'];
    recoredNo = json['recored_no'];
    firmId = json['firm_id'];
    accountTypeId = json['account_type_id'];
    transactionType = json['transaction_type'];
    details = json['details'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warper_id'] = this.warperId;
    data['lot'] = this.lot;
    data['recored_no'] = this.recoredNo;
    data['firm_id'] = this.firmId;
    data['account_type_id'] = this.accountTypeId;
    data['transaction_type'] = this.transactionType;
    data['details'] = this.details;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
