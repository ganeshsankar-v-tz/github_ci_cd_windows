class YarnStockBalanceModel {
  num? balanceQty;

  YarnStockBalanceModel({this.balanceQty});

  YarnStockBalanceModel.fromJson(Map<String, dynamic> json) {
    balanceQty = json['balance_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance_qty'] = balanceQty;
    return data;
  }
}
