class WeavingNewRecordModel {
  int? id;
  int? weaverId;
  int? loom;
  int? no;
  String? weavingAcType;
  int? productId;
  dynamic wages;
  dynamic deductionAmt;
  int? firmId;
  int? wagesAccount;
  String? transactionType;
  String? copsReels;
  String? widthPick;
  String? pinning;
  String? privateWeft;
  String? qtyType;
  String? entryType;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? weaverName;
  String? firmName;
  String? wagesAccountName;
  String? productName;

  WeavingNewRecordModel(
      {this.id,
      this.weaverId,
      this.loom,
      this.no,
      this.weavingAcType,
      this.productId,
      this.wages,
      this.deductionAmt,
      this.firmId,
      this.wagesAccount,
      this.transactionType,
      this.copsReels,
      this.widthPick,
      this.pinning,
      this.privateWeft,
      this.qtyType,
      this.entryType,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.weaverName,
      this.firmName,
      this.wagesAccountName,
      this.productName});

  WeavingNewRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weaverId = json['weaver_id'];
    loom = json['loom'];
    no = json['no'];
    weavingAcType = json['weaving_ac_type'];
    productId = json['product_id'];
    wages = json['wages'];
    deductionAmt = json['deduction_amt'];
    firmId = json['firm_id'];
    wagesAccount = json['wages_account'];
    transactionType = json['transaction_type'];
    copsReels = json['cops_reels'];
    widthPick = json['width_pick'];
    pinning = json['pinning'];
    privateWeft = json['private_weft'];
    qtyType = json['qty_type'];
    entryType = json['entry_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    weaverName = json['weaver_name'];
    firmName = json['firm_name'];
    wagesAccountName = json['wages_account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weaver_id'] = weaverId;
    data['loom'] = loom;
    data['no'] = no;
    data['weaving_ac_type'] = weavingAcType;
    data['product_id'] = productId;
    data['wages'] = wages;
    data['deduction_amt'] = deductionAmt;
    data['firm_id'] = firmId;
    data['wages_account'] = wagesAccount;
    data['transaction_type'] = transactionType;
    data['cops_reels'] = copsReels;
    data['width_pick'] = widthPick;
    data['pinning'] = pinning;
    data['private_weft'] = privateWeft;
    data['qty_type'] = qtyType;
    data['entry_type'] = entryType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['weaver_name'] = weaverName;
    data['firm_name'] = firmName;
    data['wages_account'] = wagesAccountName;
    return data;
  }
}
