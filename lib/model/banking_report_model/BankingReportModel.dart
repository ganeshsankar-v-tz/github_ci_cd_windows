class BankingReportModel {
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
  String? bankingType;
  num? totalAmount;
  num? tdsPer;
  num? tdsAmount;
  num? cgst;
  num? sgst;
  num? grossAmount;

  BankingReportModel({
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
    this.bankingType,
    this.totalAmount,
    this.tdsPer,
    this.tdsAmount,
    this.cgst,
    this.sgst,
    this.grossAmount,
  });

  BankingReportModel.fromJson(Map<String, dynamic> json) {
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
    bankingType = json['banking_type'];
    totalAmount = json['total_amount'];
    tdsPer = json['tds_per'];
    tdsAmount = json['tds_amount'];
    cgst = json['cgst'];
    sgst = json['sgst'];
    grossAmount = json['gross_amount'];
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
    data['banking_type'] = bankingType;
    data['total_amount'] = totalAmount;
    data['tds_per'] = tdsPer;
    data['tds_amount'] = tdsAmount;
    data['cgst'] = cgst;
    data['sgst'] = sgst;
    data['gross_amount'] = grossAmount;
    return data;
  }
}
