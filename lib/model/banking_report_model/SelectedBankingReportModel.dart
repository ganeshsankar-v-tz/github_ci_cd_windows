class SelectedBankingReportModel {
  int? id;
  int? firmId;
  String? paymentDate;
  String? chequeNo;
  String? transNo;
  String? branchName;
  String? bankName;
  String? chequeDate;
  String? status;
  List<Payment>? payment;

  SelectedBankingReportModel({
    this.id,
    this.firmId,
    this.paymentDate,
    this.chequeNo,
    this.transNo,
    this.branchName,
    this.bankName,
    this.chequeDate,
    this.status,
    this.payment,
  });

  SelectedBankingReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    paymentDate = json['payment_date'];
    chequeNo = json['cheque_no'];
    transNo = json['trans_no'];
    branchName = json['branch_name'];
    bankName = json['bank_name'];
    chequeDate = json['cheque_date'];
    status = json['status'];
    if (json['payment'] != null) {
      payment = <Payment>[];
      json['payment'].forEach((v) {
        payment!.add(new Payment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firm_id'] = firmId;
    data['payment_date'] = paymentDate;
    data['cheque_no'] = chequeNo;
    data['trans_no'] = transNo;
    data['branch_name'] = branchName;
    data['bank_name'] = bankName;
    data['cheque_date'] = chequeDate;
    data['status'] = status;
    if (payment != null) {
      data['payment'] = payment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payment {
  int? challanNo;
  int? id;
  int? firmId;
  String? paymentType;
  int? ledgerId;
  String? accountNo;
  String? paymentStatus;
  String? ledgerName;
  String? firmName;
  String? eDate;
  num? totalAmount;
  num? tdsPer;
  num? tdsAmount;
  num? grossAmount;
  num? cgst;
  num? sgst;

  Payment({
    this.challanNo,
    this.id,
    this.firmId,
    this.paymentType,
    this.ledgerId,
    this.accountNo,
    this.paymentStatus,
    this.ledgerName,
    this.firmName,
    this.eDate,
    this.totalAmount,
    this.tdsPer,
    this.tdsAmount,
    this.grossAmount,
    this.cgst,
    this.sgst,
  });

  Payment.fromJson(Map<String, dynamic> json) {
    challanNo = json['challan_no'];
    id = json['id'];
    firmId = json['firm_id'];
    paymentType = json['payment_type'];
    ledgerId = json['ledger_id'];
    accountNo = json['account_no'];
    paymentStatus = json['payment_status'];
    ledgerName = json['ledger_name'];
    firmName = json['firm_name'];
    eDate = json['e_date'];
    totalAmount = json['total_amount'];
    tdsPer = json['tds_per'];
    tdsAmount = json['tds_amount'];
    grossAmount = json['gross_amount'];
    cgst = json['cgst'];
    sgst = json['sgst'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['challan_no'] = challanNo;
    data['id'] = id;
    data['firm_id'] = firmId;
    data['payment_type'] = paymentType;
    data['ledger_id'] = ledgerId;
    data['account_no'] = accountNo;
    data['payment_status'] = paymentStatus;
    data['ledger_name'] = ledgerName;
    data['firm_name'] = firmName;
    data['e_date'] = eDate;
    data['total_amount'] = totalAmount;
    data['tds_per'] = tdsPer;
    data['tds_amount'] = tdsAmount;
    data['gross_amount'] = grossAmount;
    data['cgst'] = cgst;
    data['sgst'] = sgst;
    return data;
  }
}
