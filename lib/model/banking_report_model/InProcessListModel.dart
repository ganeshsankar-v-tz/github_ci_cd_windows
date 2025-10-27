class InProcessListModel {
  int? id;
  String? paymentId;
  String? paymentDate;
  String? chequeNo;
  int? firmId;
  int? totalAmount;
  Null? transNo;
  String? createdAt;
  String? updatedAt;
  String? branchName;
  String? bankName;
  int? createdBy;
  Null? updatedBy;
  String? chequeDate;
  String? status;
  String? firmName;

  InProcessListModel(
      {this.id,
        this.paymentId,
        this.paymentDate,
        this.chequeNo,
        this.firmId,
        this.totalAmount,
        this.transNo,
        this.createdAt,
        this.updatedAt,
        this.branchName,
        this.bankName,
        this.createdBy,
        this.updatedBy,
        this.chequeDate,
        this.status,
        this.firmName});

  InProcessListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentId = json['payment_id'];
    paymentDate = json['payment_date'];
    chequeNo = json['cheque_no'];
    firmId = json['firm_id'];
    totalAmount = json['total_amount'];
    transNo = json['trans_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    branchName = json['branch_name'];
    bankName = json['bank_name'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    chequeDate = json['cheque_date'];
    status = json['status'];
    firmName = json['firm_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['payment_id'] = this.paymentId;
    data['payment_date'] = this.paymentDate;
    data['cheque_no'] = this.chequeNo;
    data['firm_id'] = this.firmId;
    data['total_amount'] = this.totalAmount;
    data['trans_no'] = this.transNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['branch_name'] = this.branchName;
    data['bank_name'] = this.bankName;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['cheque_date'] = this.chequeDate;
    data['status'] = this.status;
    data['firm_name'] = this.firmName;
    return data;
  }
}