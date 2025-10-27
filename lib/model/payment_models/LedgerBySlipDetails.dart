class LedgerBySlipDetails {
  late int id;
  String? eDate;
  late int creditAmount;
  int? qty;
  bool? select = false;

  LedgerBySlipDetails({required this.id, this.eDate, this.creditAmount = 0, this.qty});

  LedgerBySlipDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eDate = json['e_date'];
    creditAmount = json['credit_amount'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['e_date'] = eDate;
    data['credit_amount'] = creditAmount;
    data['qty'] = qty;
    return data;
  }
}
