class PayDetailsHistoryModel {
  int? challanNo;
  String? paymentType;
  int? firmId;
  String? firmName;
  String? eDate;
  String? to;
  int? through;
  String? throughName;
  num? debitAmount;
  String? details;

  PayDetailsHistoryModel(
      {this.challanNo,
      this.paymentType,
      this.firmId,
      this.firmName,
      this.eDate,
      this.to,
      this.through,
      this.throughName,
      this.debitAmount,
      this.details});

  PayDetailsHistoryModel.fromJson(Map<String, dynamic> json) {
    challanNo = json['challan_no'];
    paymentType = json['payment_type'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    eDate = json['e_date'];
    to = json['to'];
    through = json['through'];
    throughName = json['through_name'];
    debitAmount = json['debit_amount'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['challan_no'] = challanNo;
    data['payment_type'] = paymentType;
    data['firm_id'] = firmId;
    data['firm_name'] = firmName;
    data['e_date'] = eDate;
    data['to'] = to;
    data['through'] = through;
    data['through_name'] = throughName;
    data['debit_amount'] = debitAmount;
    data['details'] = details;
    return data;
  }
}
