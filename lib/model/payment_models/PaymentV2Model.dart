class PaymentV2Model {
  int? id;
  int? firmId;
  String? firmName;
  String? eDate;
  String? details;
  int? challanNo;
  String? paymentType;
  late int ledgerId;
  String? ledgerName;
  num? totalAmount;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  num? tdsPer;
  num? tdsAmount;
  String? accountNo;
  String? bankingType;
  List<JobDetails>? jobDetails;
  List<AmountDetails>? amountDetails;

  PaymentV2Model({
    this.id,
    this.firmId,
    this.firmName,
    this.eDate,
    this.details,
    this.challanNo,
    this.paymentType,
    required this.ledgerId,
    this.ledgerName,
    this.totalAmount,
    this.jobDetails,
    this.amountDetails,
    this.creatorName,
    this.updatedName,
    this.tdsAmount,
    this.tdsPer,
    this.accountNo,
    this.createdAt,
    this.updatedAt,
    this.bankingType,
  });

  PaymentV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    eDate = json['e_date'];
    details = json['details'];
    challanNo = json['challan_no'];
    paymentType = json['payment_type'];
    ledgerId = json['ledger_id'];
    ledgerName = json['ledger_name'];
    totalAmount = json['total_amount'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    tdsAmount = json['tds_amount'];
    tdsPer = json['tds_per'];
    accountNo = json['account_no'];
    bankingType = json['banking_type'];
    if (json['job_details'] != null) {
      jobDetails = <JobDetails>[];
      json['job_details'].forEach((v) {
        jobDetails!.add(JobDetails.fromJson(v));
      });
    }
    if (json['amount_details'] != null) {
      amountDetails = <AmountDetails>[];
      json['amount_details'].forEach((v) {
        amountDetails!.add(AmountDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firm_id'] = firmId;
    data['firm_name'] = firmName;
    data['e_date'] = eDate;
    data['details'] = details;
    data['challan_no'] = challanNo;
    data['payment_type'] = paymentType;
    data['ledger_id'] = ledgerId;
    data['ledger_name'] = ledgerName;
    data['total_amount'] = totalAmount;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['tds_amount'] = tdsAmount;
    data['tds_per'] = tdsPer;
    data['account_no'] = accountNo;
    data['banking_type'] = bankingType;
    if (jobDetails != null) {
      data['job_details'] = jobDetails!.map((v) => v.toJson()).toList();
    }
    if (amountDetails != null) {
      data['amount_details'] = amountDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobDetails {
  int? id;
  int? paymentId;
  int? slipRecNo;
  num? qty;
  String? slipDate;
  num? creditAmount;
  int? createdBy;
  int? updatedBy;
  int? status;
  String? createdAt;
  String? updatedAt;

  JobDetails(
      {this.id,
      this.paymentId,
      this.slipRecNo,
      this.qty,
      this.slipDate,
      this.creditAmount,
      this.createdBy,
      this.updatedBy,
      this.status,
      this.createdAt,
      this.updatedAt});

  JobDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentId = json['payment_id'];
    slipRecNo = json['slip_rec_no'];
    qty = json['qty'];
    slipDate = json['slip_date'];
    creditAmount = json['credit_amount'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['payment_id'] = paymentId;
    data['slip_rec_no'] = slipRecNo;
    data['qty'] = qty;
    data['slip_date'] = slipDate;
    data['credit_amount'] = creditAmount;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class AmountDetails {
  int? id;
  int? paymentId;
  int? to;
  String? toName;
  String? eType;
  num? debitAmount;
  int? createdBy;
  int? updatedBy;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? details;

  AmountDetails(
      {this.id,
      this.paymentId,
      this.to,
      this.toName,
      this.eType,
      this.debitAmount,
      this.createdBy,
      this.updatedBy,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.details});

  AmountDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentId = json['payment_id'];
    to = json['to'];
    toName = json["to_name"];
    eType = json['e_type'];
    debitAmount = json['debit_amount'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['payment_id'] = paymentId;
    data['to'] = to;
    data['to_name'] = toName;
    data['e_type'] = eType;
    data['debit_amount'] = debitAmount;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['details'] = details;
    return data;
  }
}
