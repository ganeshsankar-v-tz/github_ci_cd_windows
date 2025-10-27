class BankSubmittedTdsDetailsModel {
  int? id;
  List<int>? paymentId;
  String? paymentDate;
  String? chequeNo;
  int? firmId;
  num? totalAmount;
  String? transNo;
  String? branchName;
  String? bankName;
  String? chequeDate;
  int? approvedBy;
  String? approvedTime;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? firmName;
  String? approvedName;

  BankSubmittedTdsDetailsModel({
    this.id,
    this.paymentId,
    this.paymentDate,
    this.chequeNo,
    this.firmId,
    this.totalAmount,
    this.transNo,
    this.branchName,
    this.bankName,
    this.chequeDate,
    this.approvedBy,
    this.approvedTime,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.firmName,
    this.approvedName,
  });

  BankSubmittedTdsDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentId = json['payment_id'].cast<int>();
    paymentDate = json['payment_date'];
    chequeNo = json['cheque_no'];
    firmId = json['firm_id'];
    totalAmount = json['total_amount'];
    transNo = json['trans_no'];
    branchName = json['branch_name'];
    bankName = json['bank_name'];
    chequeDate = json['cheque_date'];
    approvedBy = json['approved_by'];
    approvedTime = json['approved_time'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    firmName = json['firm_name'];
    approvedName = json['approved_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['payment_id'] = paymentId;
    data['payment_date'] = paymentDate;
    data['cheque_no'] = chequeNo;
    data['firm_id'] = firmId;
    data['total_amount'] = totalAmount;
    data['trans_no'] = transNo;
    data['branch_name'] = branchName;
    data['bank_name'] = bankName;
    data['cheque_date'] = chequeDate;
    data['approved_by'] = approvedBy;
    data['approved_time'] = approvedTime;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['firm_name'] = firmName;
    data['approved_name'] = approvedName;
    return data;
  }
}
