class WeaverAdvanceDetailsModel {
  int? ledgerId;
  int? balanceAmount;
  String? ledgerName;
  bool selected = false;

  WeaverAdvanceDetailsModel(
      {this.ledgerId, this.balanceAmount, this.ledgerName});

  WeaverAdvanceDetailsModel.fromJson(Map<String, dynamic> json) {
    ledgerId = json['ledger_id'];
    balanceAmount = json['balance_amount'];
    ledgerName = json['ledger_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ledger_id'] = ledgerId;
    data['balance_amount'] = balanceAmount;
    data['ledger_name'] = ledgerName;
    return data;
  }
}
