class TdsAmountDetailsModel {
  int? paymentId;
  int? challanNo;
  String? eDate;
  int? ledgerId;
  String? ledgerName;
  int? firmId;
  String? firmName;
  String? accountNo;
  String? accountHolder;
  String? panNo;
  String? panName;
  num? tdsPer;
  num? tdsAmount;

  TdsAmountDetailsModel({
    this.paymentId,
    this.challanNo,
    this.eDate,
    this.ledgerId,
    this.ledgerName,
    this.firmId,
    this.firmName,
    this.accountNo,
    this.accountHolder,
    this.panNo,
    this.panName,
    this.tdsPer,
    this.tdsAmount,
  });

  TdsAmountDetailsModel.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    challanNo = json['challan_no'];
    eDate = json['e_date'];
    ledgerId = json['ledger_id'];
    ledgerName = json['ledger_name'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    accountNo = json['account_no'];
    accountHolder = json['account_holder'];
    panNo = json['pan_no'];
    panName = json['pan_name'];
    tdsPer = json['tds_per'];
    tdsAmount = json['tds_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_id'] = paymentId;
    data['challan_no'] = challanNo;
    data['e_date'] = eDate;
    data['ledger_id'] = ledgerId;
    data['ledger_name'] = ledgerName;
    data['firm_id'] = firmId;
    data['firm_name'] = firmName;
    data['account_no'] = accountNo;
    data['account_holder'] = accountHolder;
    data['pan_no'] = panNo;
    data['pan_name'] = panName;
    data['tds_per'] = tdsPer;
    data['tds_amount'] = tdsAmount;
    return data;
  }
}
