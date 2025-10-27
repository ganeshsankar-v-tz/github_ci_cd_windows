class ReturnWarpBalanceModel {
  dynamic balanceQty;

  ReturnWarpBalanceModel({this.balanceQty});

  ReturnWarpBalanceModel.fromJson(Map<String, dynamic> json) {
    balanceQty = json['balance_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance_qty'] = this.balanceQty;
    return data;
  }
}
